#
# Be sure to run `pod lib lint CYFTokenInput.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JSTokenField"
  s.version          = "0.1.0"
  s.summary          = "JSTokenField with intrinsicContentSize."
  s.description      = <<-DESC
                       JSTokenField with intrinsicContentSize.

                       DESC
  s.homepage         = "https://github.com/yifeic/JSTokenField"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'Simplified BSD'
  s.author           = { "yifeic" => "yifei.chen@outlook.com" }
  s.source           = { :git => "https://github.com/yifeic/JSTokenField.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'JSTokenField/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
