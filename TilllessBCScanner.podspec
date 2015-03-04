Pod::Spec.new do |s|
  s.name        = 'TilllessBCScanner'
  s.version     = '0.0.1'
  s.license     = 'MIT'
  s.platform    = :ios, '8.0'
  s.summary     = "Concrete implementtion of AVCaptureMetadataOutputObjectsDelegate in TBarcodeScannerViewController to work with RubyMotion."
  s.homepage    = 'https://github.com/tillless/bcscanner'
  s.author      = { 'Tillless' => 'info@tillless.com' }
  s.source      = { :git => 'git@github.com:tillless/bcscanner.git' }

  s.ios.source_files = 'Source/tillless/bcscanner/*{.h,m}'
  s.libraries = ''
  s.framework = 'QuartzCore', 'CoreText'
  # s.dependency ''
  s.prefix_header_file = 'XCodeProjectData/TilllessBCScanner/TilllessBCScanner-Prefix.pch'
  s.requires_arc = false
  s.xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++11',
    'CLANG_CXX_LIBRARY'           => 'libc++',
    'HEADER_SEARCH_PATHS'         => '$(SDKROOT)/usr/include/libxml2'
  }
end
