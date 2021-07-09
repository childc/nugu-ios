Pod::Spec.new do |s|
  s.name = 'KeenSense'
  s.version = '1.4.0-beta.1'
  s.license = 'Apache License, Version 2.0'
  s.summary = 'Key Word Detector for NUGU'
  s.homepage = 'https://github.com/nugu-developers/nugu-ios'
  s.authors = { 'SK Telecom Co., Ltd.' => 'nugu_dev_sdk@sk.com' }
  s.source = { :git => 'https://github.com/nugu-developers/nugu-ios.git', :tag => s.version }
  s.documentation_url = 'https://developers.nugu.co.kr'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5'

  s.source_files = 'KeenSense/Sources/**/*.swift', 'KeenSense/Libraries/include/*.h'
  s.public_header_files = 'KeenSense/Libraries/include/*.h'
  s.vendored_frameworks = 'KeenSense/Libraries/TycheWakeupCommon.xcframework', 'KeenSense/Libraries/TycheWakeup.xcframework'
  s.resource = 'KeenSense/Resources/*'
  s.preserve_paths = 'KeenSense/Libraries/**'
  s.libraries = 'c++'
  s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/KeenSense/KeenSense/Libraries/**'}

  s.dependency 'NuguUtils', s.version.to_s
  
  s.dependency 'NattyLog', '~> 1'
  
end
