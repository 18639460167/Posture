//
//  WGCameraOverlayView.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/23.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit

protocol WGCameraOverlayDelegate: AnyObject {
    // 是否是正身
    func changeDirection(front: Bool)
}
class WGCameraOverlayView: UIView {

    weak var delegate: WGCameraOverlayDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    private func setUpUI() {
        self.contentView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(SafeTopHeight+486*ScreenScale)
        }
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.contentView.snp_bottom)
        }
        self.sideBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(18*ScreenScale)
            make.left.equalToSuperview().offset(34*ScreenScale)
            make.size.equalTo(CGSize.init(width: 92*ScreenScale, height: 32*ScreenScale))
        }
        self.frontBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.sideBtn)
            make.right.equalToSuperview().offset(-34*ScreenScale)
            make.size.equalTo(CGSize.init(width: 92*ScreenScale, height: 32*ScreenScale))
        }
        self.camerBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40*ScreenScale)
            make.size.equalTo(CGSize.init(width: 75*ScreenScale, height: 75*ScreenScale))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var contentView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: SafeBottomHeight+486*ScreenScale))
        self.addSubview(view)
        
        
        let leftView = UIView.init(frame: .zero)
        leftView.backgroundColor = UIColor.init(hexString: "#293038")
        view.addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(17*ScreenScale)
        }
        let rightView = UIView.init(frame: .zero)
        rightView.backgroundColor = UIColor.init(hexString: "#293038")
        view.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(17*ScreenScale)
        }
        let topView = UIView.init(frame: .zero)
        topView.backgroundColor = UIColor.init(hexString: "#293038")
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(SafeTopHeight)
        }
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView.init(frame: .zero)
        self.addSubview(view)
        view.backgroundColor = UIColor.orange
//        view.backgroundColor = UIColor.init(hexString: "#293038")
        return view
    }()
    
    lazy var sideBtn: WGActionBtn = {
        let btn = WGActionBtn.init(frame: .zero)
        btn.messageLbl.text = "slide"
        self.bottomView.addSubview(btn)
        return btn
    }()
    lazy var frontBtn: WGActionBtn = {
        let btn = WGActionBtn.init(frame: .zero)
        btn.messageLbl.text = "front"
        btn.isSelected = true
        self.bottomView.addSubview(btn)
        return btn
    }()
    
    lazy var camerBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        btn.layer.borderWidth = 3*ScreenScale
        btn.layer.borderColor = UIColor.init(hexString: "#C6E2EF").cgColor
        btn.layer.cornerRadius = 75/2.0*ScreenScale
        self.bottomView.addSubview(btn)
        
        let whiteView = UIView.init(frame: .zero)
        whiteView.isUserInteractionEnabled = false
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 30*ScreenScale
        whiteView.layer.masksToBounds = true
        btn.addSubview(whiteView)
        whiteView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 60*ScreenScale, height: 60*ScreenScale))
        }
        return btn
    }()
    
    @objc func changeDirection(btn: UIButton) {
        if btn == self.sideBtn {
            btn.isSelected = true
            self.sideBtn.isSelected = false
        } else {
            btn.isSelected = true
            self.frontBtn.isSelected = false
        }
        self.delegate?.changeDirection(front: btn == self.sideBtn)
    }

}

class WGActionBtn: UIButton {
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 1.0 : 0
        }
    }
    var cameraFinish: Bool = false {
        didSet {
            self.isEnabled = !cameraFinish
            self.messageLbl.snp_remakeConstraints({ (make) in
                if cameraFinish {
                    make.right.equalToSuperview()
                    make.left.equalTo(self.finishImgView.snp_right).offset(2)
                    make.centerY.equalToSuperview()
                } else {
                    make.left.right.centerY.equalToSuperview()
                }
            })
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 5*ScreenScale
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        self.setUpUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpUI() {
        centerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.equalToSuperview()
        }
        self.finishImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        self.messageLbl.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalToSuperview()
        })
    }
    
    lazy var centerView: UIView = {
        let view = UIView.init(frame: .zero)
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        return view
    }()
    lazy var finishImgView: UIImageView = {
        let imageView = UIImageView.init(frame: .zero)
        imageView.image = UIImage.init(named: "")
        centerView.addSubview(imageView)
        return imageView
    }()
    
    lazy var messageLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 22*ScreenScale, weight: .regular)
        label.textColor = .white
        centerView.addSubview(label)
        return label
    }()
}
