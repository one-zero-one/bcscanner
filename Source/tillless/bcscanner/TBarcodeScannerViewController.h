//
//  TBarcodeScannerViewController.h
//  Scan bar codes
//
//  Created by Matthew Sinclair on 31/01/15.
//  Copyright (c) 2015 One Zero One. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBarcodeScannerViewController : UIViewController

@property (readonly)  AVCaptureSession           *session;
@property (readonly)  AVCaptureDevice            *device;
@property (readonly)  AVCaptureDeviceInput       *input;
@property (readonly)  AVCaptureMetadataOutput    *output;
@property (readonly)  AVCaptureVideoPreviewLayer *prevLayer;

@property (readwrite, assign) BOOL keepScanning;

@property (readonly)  NSError *lastError;

@property (weak) id <AVCaptureMetadataOutputObjectsDelegate> scanDelegate;

- (BOOL)setupScanner;
- (BOOL)startScanning;
- (BOOL)stopScanning;

@end
