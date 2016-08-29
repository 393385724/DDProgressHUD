Pod::Spec.new do |s|  
  s.name             = "DDProgressHUD"  
  s.version          = "1.0.1"  
  s.summary          = "`DDProgressHUD` is a clean and easy-to-use HUD on iOS"  
  s.homepage         = "https://github.com/393385724/DDProgressHUD"  
  s.license          = 'MIT'  
  s.author           = { "llg" => "393385724@qq.com" }  
  s.source           = { :git => "https://github.com/393385724/DDProgressHUD.git", :tag => s.version.to_s }  
  
  s.platform     = :ios, '7.0'  
  s.ios.deployment_target = '7.0'  
  s.requires_arc = true  
  
  s.ios.source_files = 'DDProgressHUD/*.{h,m}','DDProgressHUD/Views/*{h,m}','DDProgressHUD/DDActivityIndicatorView/*{h,m}','DDProgressHUD/DDActivityIndicatorView/Animations/*{h,m}'
  s.public_header_files = 'DDProgressHUD/DDProgressHUD.h'
  s.ios.resources = ['DDProgressHUD/Resources/*.png']
  
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'
end  
