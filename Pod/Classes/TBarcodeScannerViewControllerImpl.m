//
//  TBarcodeScannerViewControllerImpl.h
//  Scan bar codes
//
//  Created by Matthew Sinclair on 31/01/15.
//  Copyright (c) 2015 One Zero One. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TBarcodeScannerViewControllerImpl.h"

@interface TBarcodeScannerViewControllerImpl () <AVCaptureMetadataOutputObjectsDelegate>
{
  AVCaptureSession *_session;
  AVCaptureDevice *_device;
  AVCaptureDeviceInput *_input;
  AVCaptureMetadataOutput *_output;
  AVCaptureVideoPreviewLayer *_prevLayer;
  BOOL _keepScanning;

  NSError *_lastError;

  __weak id<AVCaptureMetadataOutputObjectsDelegate> _scanDelegate;

  UIView *_highlightView;
}
@end

@implementation TBarcodeScannerViewControllerImpl

- (void)viewDidLoad
{
  [super viewDidLoad];

  _highlightView = [[UIView alloc] init];
  _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
  _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
  _highlightView.layer.borderWidth = 3;
  [self.view addSubview:_highlightView];
}

- (BOOL)setupScanner
{
  _session = [[AVCaptureSession alloc] init];
  _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  NSError *error = nil;

  _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
  if (_input) {
    [_session addInput:_input];
    _lastError = nil;
  } else {
    // NSLog(@"TBarcodeScannerViewControllerImpl#setupScanner: error setting up scanner: %@", error);
    _lastError = error;
    return NO;
  }

  _output = [[AVCaptureMetadataOutput alloc] init];
  [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  [_session addOutput:_output];

  _output.metadataObjectTypes = [_output availableMetadataObjectTypes];

  _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
  _prevLayer.frame = self.view.bounds;
  _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  [self.view.layer addSublayer:_prevLayer];

  [_session startRunning];

  [self.view bringSubviewToFront:_highlightView];

  return (_session && _session.isRunning);
}

- (BOOL)startScanning
{
  if (_session && ![_session isRunning]) {
    _highlightView.frame = CGRectZero;
    [_session startRunning];
    _highlightView.alpha = 1.0;
    return YES;
  } else {
    return NO;
  }
}

- (BOOL)stopScanning
{
  _highlightView.alpha = 0.0;
  _highlightView.frame = CGRectZero;
  if (_session && [_session isRunning]) {
    [_session stopRunning];
    return YES;
  } else {
    return NO;
  }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
  CGRect highlightViewRect = CGRectZero;
  AVMetadataMachineReadableCodeObject *barCodeObject;
  NSString *detectionString = nil;
  NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
      AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
      AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];

  for (AVMetadataObject *metadata in metadataObjects) {
    for (NSString *type in barCodeTypes) {
      if ([metadata.type isEqualToString:type])
      {
        barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
        highlightViewRect = barCodeObject.bounds;
        detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
        break;
      }
    }
    if (detectionString != nil)
    {
      break;
    }
  }

  _highlightView.frame = highlightViewRect;
  // NSLog(@"TBarcodeScannerViewControllerImpl:scanned: %@", detectionString);

  if (_scanDelegate != nil) {
    [_scanDelegate captureOutput:captureOutput didOutputMetadataObjects:metadataObjects fromConnection:connection ];
    if (_keepScanning == NO) {
      [_session stopRunning];
    }
  }
}

@end
