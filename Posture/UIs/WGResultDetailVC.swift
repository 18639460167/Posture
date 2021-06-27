//
//  WGResultDetailVC.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/25.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit

class WGResultDetailVC: WGBaseViewController {

    var cacheModel: WGCacheModel = WGCacheModel.init()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpUI()
    }
    
    private func setUpUI() {
        self.frontBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25*ScreenScale)
            make.size.equalTo(CGSize.init(width: 147*ScreenScale, height: 224*ScreenScale))
            make.top.equalToSuperview().offset(SafeTopHeight+5*ScreenScale)
        }
        self.sideBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-25*ScreenScale)
            make.size.equalTo(CGSize.init(width: 147*ScreenScale, height: 224*ScreenScale))
            make.top.equalTo(self.frontBtn)
        }
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-SafeBottomHeight)
            make.height.equalTo(35*ScreenScale)
        }
        let alertLbl = UILabel.init(frame: .zero)
        alertLbl.textAlignment = .center
        alertLbl.textColor = UIColor.white
        alertLbl.font = UIFont.systemFont(ofSize: 13*ScreenScale, weight: .medium)
        alertLbl.text = "Tap fpr full screen photo"
        self.view.addSubview(alertLbl)
        alertLbl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.frontBtn.snp_bottom).offset(10*ScreenScale)
        }
    }

    lazy var frontBtn: WGResultImageButton = {
        let btn = WGResultImageButton.init(frame: .zero)
        let frontPath = self.cacheModel.floderPath().me_appendingPath(path: frontImgName)
        let image = UIImage.init(contentsOfFile: frontPath)
        btn.resultImage = image
        self.view.addSubview(btn)
        return btn
    }()
    lazy var sideBtn: WGResultImageButton = {
        let btn = WGResultImageButton.init(frame: .zero)
        let frontPath = self.cacheModel.floderPath().me_appendingPath(path: sideImgName)
        let image = UIImage.init(contentsOfFile: frontPath)
        btn.resultImage = image
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView.init(frame: .zero)
        self.view.addSubview(view)
        view.addSubview(compareBtn)
        compareBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(view.snp_centerX)
        }
        view.addSubview(testBtn)
        testBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(compareBtn.snp_right)
        }
        let topLineView = UIView.init(frame: .zero)
        view.addSubview(topLineView)
        topLineView.backgroundColor = UIColor.white
        topLineView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        let centerLineView = UIView.init(frame: .zero)
        view.addSubview(centerLineView)
        centerLineView.backgroundColor = UIColor.white
        centerLineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.center.equalToSuperview()
            make.width.equalTo(0.5)
        }
        return view
    }()
    lazy var compareBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        self.view.addSubview(btn)
        btn.setTitle("Make Comparisons", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15*ScreenScale, weight: .medium)
        btn.addTarget(self, action: #selector(compareAction), for: .touchUpInside)
        return btn
    }()
    lazy var testBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        self.view.addSubview(btn)
        btn.setTitle("Take test again", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15*ScreenScale, weight: .medium)
        btn.addTarget(self, action: #selector(takeTestAction), for: .touchUpInside)
        return btn
    }()
    // 对比
    @objc func compareAction() {
        let vc = WGHistoryViewController.init()
        vc.firstCacheModel = self.cacheModel
        vc.isResult = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func takeTestAction() {
        self.enterCameraVC()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.popViewController(animated: true)
    }

}
