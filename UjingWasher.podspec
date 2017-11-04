#
#  Be sure to run `pod spec lint UjingWasher.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#
#

Pod::Spec.new do |s|

s.name         = "UjingWasher"
s.version      = "1.0.0"
s.summary      = "对相机进行封装"

s.homepage     = "https://github.com/littleswan/UjingWasher"
# s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
s.author             = { "littleswan.app" => "littleswan.app@midea.com.cn" }

s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/littleswan/UjingWasher.git", :tag => "#{s.version}" }
# s.source      = { :git => "", :tag => "#{s.version}" }

s.requires_arc = true

s.subspec 'Plugins' do |ss|
ss.source_files = 'UjingWasher/Plugins/**/*.{h,m}'
ss.resources  = "UjingWasher/Plugins/**/*.png"

end

# 系统库依赖
s.frameworks = 'UIKit', 'CoreVideo', 'CoreMedia', 'AVFoundation', 'QuartzCore', 'Foundation', 'CFNetwork', 'CoreLocation', 'Security', 'SystemConfiguration', 'AlipaySDK'

# Cordova 依赖
s.dependency 'Cordova'

# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
end
