//
//  WGResultBrowerVIew.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/26.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit

class WGResultImageButton: UIButton {
    
    var resultImage: UIImage? = nil {
        didSet {
            self.resultImageView.image = resultImage
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.resultImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var resultImageView: UIImageView = {
        let reImageView = UIImageView.init(frame: .zero)
        reImageView.contentMode = .scaleAspectFill
        reImageView.layer.masksToBounds = true
        self.addSubview(reImageView)
        return reImageView
    }()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let image = resultImage {
            let browerView = HUPhotoBrowser.show(from: self.resultImageView, withImages: [image], at: 0)
            browerView.saveButton.isHidden = true
        }
    }
}

class WGResultBrowerView: UIView {

    static let shareBrower: WGResultBrowerView = WGResultBrowerView.init(frame: UIScreen.main.bounds)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Main_Color
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(SafeTopHeight-20)
            make.bottom.equalToSuperview().offset(-SafeBottomHeight)
            make.left.right.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        self.addSubview(imageView)
        return imageView
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    
    class func showBrowerImageView(image: UIImage) {
        WGResultBrowerView.shareBrower.removeFromSuperview()
        WGResultBrowerView.shareBrower.imageView.image = image
        UIApplication.shared.keyWindow?.addSubview(WGResultBrowerView.shareBrower)
    }

}
