
Pod::Spec.new do |s|
  s.name             = 'A11yUITests'
  s.version          = '1.0.1'
  s.summary          = 'Accessibility tests for XCUI Testing.'

  s.description      = <<-DESC
A library of common accessibility tests for use with XCUI Tests
                       DESC

  s.homepage         = 'https://github.com/rwapp/A11yUITests'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rob Whitaker' => 'rw@rwapp.co.uk' }
  s.source           = { :git => 'https://github.com/rwapp/A11yUITests.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MobileA11y'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/A11yUITests/**/*'

   s.frameworks = 'XCTest'
end
