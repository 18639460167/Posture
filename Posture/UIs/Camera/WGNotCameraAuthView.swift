//
//  WGNotCameraAuthView.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/29.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit

class WGNotCameraAuthView: UIView {

    var showAlert: Bool = true {
        didSet {
            self.titleLbl.isHidden = !showAlert
            self.sublabel.isHidden = !showAlert
            self.settingBtn.isHidden = !showAlert
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpUI () {
        self.backgroundColor = Main_Color
        
        self.titleLbl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(SafeTopHeight+190*ScreenScale)
        }
        sublabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLbl.snp_bottom).offset(30*ScreenScale)
        }
        settingBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(sublabel.snp_bottom).offset(30*ScreenScale)
            make.height.equalTo(30)
        }
        
        let cameraView = UIView.init(frame: .zero)
        cameraView.layer.borderWidth = 3.0
        cameraView.layer.cornerRadius = 75*ScreenScale/2.0
        cameraView.layer.borderColor = UIColor.init(hexString: "#C6E2EF").cgColor
        self.addSubview(cameraView)
        cameraView.layer.masksToBounds = true
        cameraView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 75*ScreenScale, height: 75*ScreenScale))
            make.bottom.equalToSuperview().offset(-48*ScreenScale-SafeBottomHeight)
        }
        let whiteView = UIView.init(frame: .zero)
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 30*ScreenScale
        whiteView.layer.masksToBounds = true
        cameraView.addSubview(whiteView)
        whiteView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(60*ScreenScale)
        }
    }
    
    lazy var titleLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        self.addSubview(label)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24*ScreenScale, weight: .bold)
        label.text = "Take a Test"
        return label
    }()
    lazy var sublabel: UILabel = {
        let sublabel = UILabel.init(frame: .zero)
        self.addSubview(sublabel)
        sublabel.textColor = .white
        sublabel.font = UIFont.systemFont(ofSize: 18*ScreenScale, weight: .regular)
        sublabel.text = "Enable access so you can\nstart your Spine Check test."
        sublabel.textAlignment = .center
        sublabel.numberOfLines = 0
        self.addSubview(sublabel)
        return sublabel
    }()
    lazy var settingBtn: UIButton = {
        let settingBtn = UIButton.init(frame: .zero)
        settingBtn.setTitleColor(UIColor.init(hexString: "#00A8FF"), for: .normal)
        settingBtn.setTitle("Enable Camera Access", for: .normal)
        settingBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        settingBtn.addTarget(self, action: #selector(openSettingAction), for: .touchUpInside)
        self.addSubview(settingBtn)
        return settingBtn
    }()
    
    @objc func openSettingAction() {
        ME_OpenSystemSetting()
    }

}
