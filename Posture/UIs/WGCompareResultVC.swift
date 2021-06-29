//
//  WGCompareResultVC.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/26.
//  Copyright © 2021 LOL. All rights reserved.
//  对比

import UIKit

class WGCompareResultVC: WGBaseViewController {

    var firstCacheModel: WGCacheModel = WGCacheModel.init()
    var lastCacheModel: WGCacheModel = WGCacheModel.init()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpUI()
    }
    
    private func setUpUI() {
        self.titleLbl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(SafeTopHeight == 20 ? 0 : SafeTopHeight)
            make.height.equalTo(40*ScreenScale)
        }
        let lineView = UIView.init(frame: .zero)
        lineView.backgroundColor = .white
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1.0)
            make.top.equalTo(self.titleLbl.snp_bottom)
        }
        self.firstFrontBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25*ScreenScale)
            make.size.equalTo(CGSize.init(width: 147*ScreenScale, height: 224*ScreenScale))
            make.top.equalTo(lineView.snp_bottom).offset(13*ScreenScale)
        }
        self.lastFrontBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-25*ScreenScale)
            make.size.equalTo(CGSize.init(width: 147*ScreenScale, height: 224*ScreenScale))
            make.top.equalTo(self.firstFrontBtn)
        }
        let alertLbl = UILabel.init(frame: .zero)
        alertLbl.text = "Tap fpr full screen photo"
        alertLbl.textColor = .white
        alertLbl.font = UIFont.systemFont(ofSize: 13*ScreenScale, weight: .medium)
        self.view.addSubview(alertLbl)
        alertLbl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.firstFrontBtn.snp_bottom)
            make.height.equalTo(30*ScreenScale)
        }
        self.firstSideBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25*ScreenScale)
            make.size.equalTo(CGSize.init(width: 147*ScreenScale, height: 224*ScreenScale))
            make.top.equalTo(alertLbl.snp_bottom)
        }
        self.lastSideBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-25*ScreenScale)
            make.size.equalTo(CGSize.init(width: 147*ScreenScale, height: 224*ScreenScale))
            make.top.equalTo(self.firstSideBtn)
        }
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-SafeBottomHeight)
            make.height.equalTo(35*ScreenScale)
        }
    }

    lazy var titleLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24*ScreenScale, weight: .medium)
        if self.firstCacheModel.timeInfo.count > 3, self.lastCacheModel.timeInfo.count > 3 {
            let firstInfo = self.firstCacheModel.timeInfo
            let lastInfo = self.lastCacheModel.timeInfo
            label.text = "\(firstInfo[0]) \(firstInfo[3]) vs \(lastInfo[0]) \(lastInfo[3])"
        }
        self.view.addSubview(label)
        return label
    }()
    
    lazy var firstFrontBtn: WGResultImageButton = {
        let btn = WGResultImageButton.init(frame: .zero)
        let frontPath = self.firstCacheModel.floderPath().me_appendingPath(path: frontImgName)
        let image = UIImage.init(contentsOfFile: frontPath)
        btn.resultImage = image
        self.view.addSubview(btn)
        return btn
    }()
    lazy var firstSideBtn: WGResultImageButton = {
        let btn = WGResultImageButton.init(frame: .zero)
        let frontPath = self.firstCacheModel.floderPath().me_appendingPath(path: sideImgName)
        let image = UIImage.init(contentsOfFile: frontPath)
        btn.resultImage = image
        self.view.addSubview(btn)
        return btn
    }()
    lazy var lastFrontBtn: WGResultImageButton = {
        let btn = WGResultImageButton.init(frame: .zero)
        let frontPath = self.lastCacheModel.floderPath().me_appendingPath(path: frontImgName)
        let image = UIImage.init(contentsOfFile: frontPath)
        btn.resultImage = image
        self.view.addSubview(btn)
        return btn
    }()
    lazy var lastSideBtn: WGResultImageButton = {
        let btn = WGResultImageButton.init(frame: .zero)
        let frontPath = self.lastCacheModel.floderPath().me_appendingPath(path: sideImgName)
        let image = UIImage.init(contentsOfFile: frontPath)
        btn.resultImage = image
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView.init(frame: .zero)
        self.view.addSubview(view)
        view.addSubview(testBtn)
        testBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(view.snp_centerX)
        }
        view.addSubview(exportBtn)
        exportBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(testBtn.snp_right)
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
    lazy var exportBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        self.view.addSubview(btn)
        btn.setTitle("Export", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15*ScreenScale, weight: .medium)
        btn.addTarget(self, action: #selector(exportAction), for: .touchUpInside)
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
    @objc func exportAction() {
        
    }
    
    @objc func takeTestAction() {
        self.enterCameraVC()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
