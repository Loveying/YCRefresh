#
# Be sure to run `pod lib lint YCRefresh.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YCRefresh'
  s.version          = '1.0.0'
  s.license          = { :type => "MIT", :file => "LICENSE" }

  s.summary          = 'An easy way to use pull-to-refresh, MJRefresh with swift version.'
  s.homepage         = 'https://github.com/Loveying/YCRefresh'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "xiayingying" => "xyy_ios@163.com" }

  s.source           = { :git => 'https://github.com/Loveying/YCRefresh.git', :tag => "#{s.version}" }
  s.swift_version = '5.0'
  s.platform      = :ios
  s.ios.deployment_target  = '9.0'

  s.source_files = 'YCRefresh/Classes/**/*'
  s.resource      = "YCRefresh/**/*.bundle"
end
