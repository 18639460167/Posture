platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

def network
  pod 'Alamofire', '4.8.2'
  pod 'Moya', '13.0.1'
  pod 'YYModel', '1.0.4'
  
  # UI适配
  pod 'SnapKit', '~> 4.2.0'
  # 图片加载
  pod 'SDWebImage', '5.9.1'
  pod 'YYCache', '~> 1.0.4'
  pod 'HUPhotoBrowser'
  
  pod 'LookinServer', :configurations => ['Debug']
end


target "Posture" do

  network

end


