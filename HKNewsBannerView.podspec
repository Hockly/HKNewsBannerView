Pod::Spec.new do |s|


s.name         = "HKNewsBannerView"
s.version      = "1.01"
s.summary      = "简单易用的消息轮播器"

s.homepage     = "https://github.com/Hockly/HKNewsBannerView"

s.license      = "MIT"

s.author       = { "hockly" => "780871012@qq.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"


s.source       = { :git => "https://github.com/Hockly/HKNewsBannerView.git", :tag => "1.01"}


s.source_files  = "HKNewsBannerView/HKNewsBannerViewExample/HKNewsBannerView"


s.requires_arc = true

end
