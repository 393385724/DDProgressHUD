Pod::Spec.new do |s|  
  s.name             = "DDProgressHUD"  
  s.version          = "1.0.0"  
  s.summary          = "`DDProgressHUD` is a clean and easy-to-use HUD on iOS"  
  s.homepage         = "https://github.com/393385724/DDProgressHUD"  
  s.license          = 'MIT'  
  s.author           = { "llg" => "393385724@qq.com" }  
  s.source           = { :git => "https://github.com/393385724/DDProgressHUD.git", :tag => s.version.to_s }  
  
  s.platform     = :ios, '7.0'  
  s.ios.deployment_target = '7.0'  
  s.requires_arc = true  
  
  s.ios.source_files = 'DDProgressHUD/*.{h,m}'
  s.public_header_files = 'DDProgressHUD/DDProgressHUD.h'
  s.ios.resources = ['DDLogger/*.png']
  
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'
  s.dependency 'DGActivityIndicatorView', :git => 'https://github.com/393385724/DGActivityIndicatorView.git', :commit => '926c5140e40ec216eb5b9ac3a6add23bf4221fd8'

end  
