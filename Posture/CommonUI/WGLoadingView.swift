//
//  WGLoadingView.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/26.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit

class WGLoadingView: UIView {

    static let shareInstance: WGLoadingView = WGLoadingView.init(frame: UIScreen.main.bounds)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Main_Color.withAlphaComponent(0.6)
        let imageView = UIImageView.init(frame: .zero)
        imageView.image = UIImage.init(named: "loading")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(214*ScreenScale)
            make.height.equalTo(220*ScreenScale)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    class func showLoading() {
        WGLoadingView.shareInstance.removeFromSuperview()
        UIApplication.shared.keyWindow?.addSubview(WGLoadingView.shareInstance)
    }
    
    class func hideLoading() {
        WGLoadingView.shareInstance.removeFromSuperview()
    }

}
