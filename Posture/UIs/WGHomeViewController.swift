//
//  WGHomeViewController.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/18.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit

class WGHomeViewController: WGBaseViewController {

    var cacheModel: WGCacheModel = WGCacheModel.init()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FileManager.cacheResultRootPath()
        self.setUpUI()
        self.loadData()
        
    }
    
    private func setUpUI() {
        let imageView = UIImageView.init(frame: .zero)
        imageView.image = UIImage.init(named: "spine_check")
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(212*ScreenScale+SafeTopHeight-20)
            make.size.equalTo(CGSize.init(width: 191*ScreenScale, height: 195*ScreenScale))
        }
        let footImageView = UIImageView.init(frame: .zero)
        footImageView.image = UIImage.init(named: "foot")
        imageView.addSubview(footImageView)
        footImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(101*ScreenScale)
            make.top.equalToSuperview().offset(56*ScreenScale)
        }
        
        self.resultImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(SafeTopHeight)
            make.width.equalTo(180*ScreenScale)
        }
        self.slideImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.resultImageView.snp_right).offset(5)
            make.top.equalToSuperview().offset(SafeTopHeight)
            make.width.equalTo(180*ScreenScale)
        }
        
        self.testBtn.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom).offset(15*ScreenScale)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 150*ScreenScale, height: 32*ScreenScale))
        }
        self.historyBtn.snp.makeConstraints { (make) in
            make.top.equalTo(testBtn.snp_bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 150*ScreenScale, height: 32*ScreenScale))
        }
        self.spineCheckBtn.snp.makeConstraints { (make) in
            make.top.equalTo(historyBtn.snp_bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 150*ScreenScale, height: 32*ScreenScale))
        }
        
        let saveBtn = UIButton.init(frame: .zero)
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        self.view.addSubview(saveBtn)
        saveBtn.backgroundColor = .red
        saveBtn.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize.init(width: 100, height: 30))
        }
    }
    
    @objc func saveAction() {
        self.cacheModel.saveImages(frontImage: UIImage.init(named: "demo.jpeg")!, sideImage: UIImage.init(named: "demo1.jpeg")!) {
            
        }
        
    }
    
    func loadData() {
        WGNetWorkTool.getBaiduAccesstToekn(handle: nil)
        let list = WGResourceCacheTool.sharedInstance.cacheResourceList()
        print("list:\(list)")
        if list.count > 0 {
            self.cacheModel = list[0]
        }
    }
    
    lazy var testBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        self.view.addSubview(btn)
        btn.setTitle("Take Test", for: .normal)
        btn.setTitleColor(UIColor.init(hexString: "#7DD6E1"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15*ScreenScale, weight: .regular)
        btn.addTarget(self, action: #selector(testAction), for: .touchUpInside)
        return btn
    }()
    lazy var historyBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        self.view.addSubview(btn)
        btn.setTitle("View History", for: .normal)
        btn.setTitleColor(UIColor.init(hexString: "#7DD6E1"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15*ScreenScale, weight: .regular)
        btn.addTarget(self, action: #selector(historyAction), for: .touchUpInside)
        return btn
    }()
    lazy var spineCheckBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        self.view.addSubview(btn)
        btn.setTitle("bout Spine Check", for: .normal)
        btn.setTitleColor(UIColor.init(hexString: "#7DD6E1"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15*ScreenScale, weight: .regular)
        btn.addTarget(self, action: #selector(spineCheckAction), for: .touchUpInside)
        return btn
    }()

    @objc func testAction() {
        ME_GetAudioPermission { (success, first) in
            if success {
                let cameraVC = WGCameraViewController.init()
                self.navigationController?.pushViewController(cameraVC, animated: true)
            } else {
                // 弹出权限
                MECommonAlertView.showAlertView(title: "请先开启相机权限", destriciton: "需要根据您的照片进行识别", cancel: "放弃", confirm: "允许") { (tag) in
                    if tag == 2 {
                        ME_OpenSystemSetting()
                    }
                }
            }
        }
    }
    @objc func historyAction() {
        self.navigationController?.pushViewController(WGHistoryViewController.init(), animated: true)
        return
        let reultImage = UIImage.init(named: "demo.jpeg")
        guard let image = reultImage?.zs_fixedImageToUpOrientation() else {
            return
        }
        WGImageTool.compressedImageFiles(image) { (data) in
            if let image = UIImage.init(data: data) {
                if let frontInfo = self.cacheModel.frontPartsInfo {
                    let saveImage = WGNetWorkTool.drawPointInfo(info: frontInfo, isFront: true, resultImage: image)
                    self.resultImageView.image = saveImage
                } else {
                    WGNetWorkTool.updateImage(image: image) { (success, infoModel) in
                        if success, let infoModel = infoModel {
                            let saveImage = WGNetWorkTool.drawPointInfo(info: infoModel.person_info[0].body_parts! , isFront: true, resultImage: image)
                            self.cacheModel.frontPartsInfo = infoModel.person_info[0].body_parts
                            self.resultImageView.image = saveImage
                        }
                    }
                }
            }

        }
    }
    @objc func spineCheckAction() {
        print("侧身")
        let reultImage = UIImage.init(named: "demo1.jpeg")
        guard let image = reultImage?.zs_fixedImageToUpOrientation() else {
            return
        }
        WGImageTool.compressedImageFiles(image) { (data) in
            if let image = UIImage.init(data: data) {
                let updateImageHandle:((WGBodyPartsInfoModel, UIImage) -> Void) = {[weak self] (infoModel, resultImage) in
                    let saveImage = WGNetWorkTool.drawPointInfo(info: infoModel, isFront: false, resultImage: resultImage)
                    self?.cacheModel.sidePartsInfo = infoModel
                    self?.slideImageView.image = saveImage
                }
                if let frontInfo = self.cacheModel.sidePartsInfo {
                    updateImageHandle(frontInfo, image)
                } else {
                    WGNetWorkTool.updateImage(image: image) { (success, infoModel) in
                        if success, let infoModel = infoModel {
                            updateImageHandle(infoModel.person_info[0].body_parts!, image)
//                            let saveImage = WGNetWorkTool.drawPointInfo(info: infoModel.person_info[0].body_parts!, isFront: false, resultImage: image)
//                            self.cacheModel.sidePartsInfo = infoModel.person_info[0].body_parts
//                            self.slideImageView.image = saveImage
                        }
                    }
                }
                
            }

        }
        wg_getCurrentTime()
    }
    
    lazy var resultImageView: UIImageView = {
        let imageView = UIImageView.init(frame: .zero)
        self.view.addSubview(imageView)
        return imageView
    }()
    
    lazy var slideImageView: UIImageView = {
        let imageView = UIImageView.init(frame: .zero)
        self.view.addSubview(imageView)
        return imageView
    }()
}
