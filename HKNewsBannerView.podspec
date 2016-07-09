Pod::Spec.new do |s|


s.name         = "HKNewsBannerView"
s.version      = "1.0.1"
s.summary      = "简单易用的消息轮播器"

s.homepage     = "https://github.com/Hockly/HKNewsBannerView"

s.license      = "MIT"

s.author       = { "hockly" => "780871012@qq.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"


s.source       = { :git => "https://github.com/Hockly/HKNewsBannerView.git", :tag => "1.0.1"}


s.source_files  = "HKNewsBannerView/HKNewsBannerView/*.{h,m}"


s.requires_arc = true

end
