Pod::Spec.new do |spec|
  spec.name         = "SetgreetSDK"
  spec.version      = "1.0.0"
  spec.summary      = "Setgreet iOS SDK allows you to show Setgreet flows in your iOS app."
  spec.description  = <<-DESC
                      Setgreet iOS SDK is a powerful framework that enables you to integrate Setgreet flows 
                      into your iOS applications. It provides user identification, flow display, screen tracking, 
                      and event tracking capabilities for enhanced user engagement and analytics.
                      DESC
  spec.homepage     = "https://setgreet.com"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Setgreet" => "support@setgreet.com" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/setgreet/setgreet-ios-sdk.git", :tag => "#{spec.version}" }
  
  spec.vendored_frameworks = "SetgreetSDK.xcframework"
  spec.source_files = "SetgreetSDK.xcframework/**/*.h"

  # Preserve the framework structure
  spec.preserve_paths = "SetgreetSDK.xcframework"
  
  # Ensure the framework is properly linked
  spec.frameworks = "UIKit", "Foundation"
  
  # Minimum deployment target
  spec.ios.deployment_target = "15.0"
  
  # Swift version
  spec.swift_version = "5.0"
  
  # Validation
  spec.requires_arc = true
  
  # Pod validation
  spec.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/SetgreetSDK',
    'OTHER_LDFLAGS' => '$(inherited) -framework SetgreetSDK'
  }
  
  # User target configuration
  spec.user_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/SetgreetSDK',
    'OTHER_LDFLAGS' => '$(inherited) -framework SetgreetSDK'
  }
end
