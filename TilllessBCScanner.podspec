Pod::Spec.new do |s|
  s.name                = "TilllessBCScanner"
  s.version             = "0.0.2"
  s.summary             = "TBarcodeScannerViewController suitable for working with RubyMotion."
  s.description         = <<-DESC
                          Concrete implementation of AVCaptureMetadataOutputObjectsDelegate in
                          TBarcodeScannerViewController to work with RubyMotion.
                          DESC
  s.homepage            = 'https://github.com/tillless/bcscanner'
  s.license             = 'MIT'
  s.author              = { "Tillless" => "info@tillless.com" }
  s.source              = { :git => 'https://github.com/tillless/bcscanner.git', :tag => s.version.to_s }
  s.social_media_url    = 'https://twitter.com/tillless'

  s.platform            = :ios, '8.1'
  s.requires_arc        = true

  s.source_files        = 'Pod/Classes/**/*'
  s.public_header_files = 'Pod/Classes/**/*.h'

  s.frameworks          = 'UIKit', 'QuartzCore'
end
