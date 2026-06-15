Pod::Spec.new do |spec|
  spec.name         = "SetgreetSDKLottie"
  spec.version      = "1.0.2"
  spec.summary      = "Optional Lottie animation support for the Setgreet iOS SDK."
  spec.description  = <<-DESC
                      Adds Lottie animation rendering to the Setgreet iOS SDK.
                      Install this pod only if your Setgreet flows use Lottie
                      animation components. The core SetgreetSDK pod carries no
                      Lottie dependency; this companion brings in lottie-ios and
                      registers the Lottie component at runtime via
                      `SetgreetLottie.register()`.
                      DESC
  spec.homepage     = "https://setgreet.com"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Setgreet" => "support@setgreet.com" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/setgreet/setgreet-ios-sdk.git", :tag => "#{spec.version}" }

  spec.vendored_frameworks = "SetgreetSDKLottie.xcframework"
  spec.source_files = "SetgreetSDKLottie.xcframework/**/*.h"

  # Preserve the framework structure
  spec.preserve_paths = "SetgreetSDKLottie.xcframework"

  # Ensure the framework is properly linked
  spec.frameworks = "UIKit", "Foundation"

  # Dependencies: the core SDK (exact-version lockstep) + Lottie.
  # Lottie floor matches the version the companion binary is built against
  # (lottie-spm 4.6.x) and the SPM install instructions in the README.
  spec.dependency 'SetgreetSDK', '1.0.2'
  spec.dependency 'lottie-ios', '~> 4.6'

  # Minimum deployment target
  spec.ios.deployment_target = "15.0"

  # Swift version
  spec.swift_version = "5.0"

  # Validation
  spec.requires_arc = true

  # Pod validation
  spec.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/SetgreetSDKLottie',
    'OTHER_LDFLAGS' => '$(inherited) -framework SetgreetSDKLottie'
  }

  # User target configuration
  spec.user_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/SetgreetSDKLottie',
    'OTHER_LDFLAGS' => '$(inherited) -framework SetgreetSDKLottie'
  }
end
