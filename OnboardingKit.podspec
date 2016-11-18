#
#  Be sure to run `pod spec lint OnboardingKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "OnboardingKit"
  s.version      = "0.0.5"
  s.summary      = "A simple and interactive framework for making iOS onboarding experience easy and fun!"
  s.homepage     = "https://github.com/Athlee/OnboardingKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Eugene Mozharovsky" => "mozharovsky@live.com" }
  s.social_media_url   = "http://twitter.com/dottieyottie"
  s.platform     = :ios, "10.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/Athlee/OnboardingKit.git", :tag => s.version }
  s.source_files  = "Source/**/*.swift"
  s.requires_arc = true

  # Waiting for Swift 3 support
  # s.dependency 'TZStackView'

end
