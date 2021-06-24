//
//  WGCameraViewController.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/23.
//  Copyright © 2021 LOL. All rights reserved.
//  拍摄页

import UIKit

class WGCameraViewController: WGBaseViewController {

    var isFront: Bool = true
    var sideFinish: Bool = false {
        didSet {
            self.overlyView.sideBtn.cameraFinish = sideFinish
            if self.frontFinish == false {
                self.overlyView.changeDirection(btn: self.overlyView.frontBtn)
            }
            if sideFinish {
                self.saveAction()
            }
        }
    }
    var frontFinish: Bool = false {
        didSet {
            self.overlyView.frontBtn.cameraFinish = frontFinish
            if self.sideFinish == false {
                self.overlyView.changeDirection(btn: self.overlyView.sideBtn)
            }
            if frontFinish {
                self.saveAction()
            }
        }
    }
    var cacheModel: WGCacheModel = WGCacheModel.init()
    private var frontResultImage: UIImage?
    private var sideResultImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpUI()
    }
    
    func setUpUI() {
        self.view.addSubview(self.cameraView.view)
        self.overlyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var overlyView: WGCameraOverlayView = {
        let view = WGCameraOverlayView.init(frame: .zero)
        view.camerBtn.addTarget(self, action: #selector(cameraAction), for: .touchUpInside)
        view.delegate = self
        self.view.addSubview(view)
        return view
    }()
    
    lazy var cameraView: WGCameraVC = {
        let width: CGFloat = ScreenWidth-34*ScreenScale
        let height: CGFloat = 128.0/72.0*width
        let vc = WGCameraVC.init()
        vc.view.frame = CGRect.init(x: 17*ScreenScale, y: SafeTopHeight, width: width, height: height)
        return vc
    }()

    @objc func cameraAction() {
        self.cameraView.takePicture {[weak self] (image) in
            if let resultImage = image {
                WGNetWorkTool.updateImage(image: resultImage) { (success, infoModel) in
                    if success, let infoModel = infoModel {
                        // 需要生成结果图
                        if self?.isFront  ?? true{
                            let saveImage = WGNetWorkTool.drawPointInfo(info: infoModel.person_info[0].body_parts! , isFront: true, resultImage: resultImage)
                            self?.cacheModel.frontPartsInfo = infoModel.person_info[0].body_parts
                            self?.frontResultImage = saveImage
                            self?.frontFinish = true
                        } else {
                            let saveImage = WGNetWorkTool.drawPointInfo(info: infoModel.person_info[0].body_parts! , isFront: false, resultImage: resultImage)
                            self?.cacheModel.frontPartsInfo = infoModel.person_info[0].body_parts
                            self?.sideResultImage = saveImage
                            self?.sideFinish = true
                        }
                        
                    }
                }
            } else {
                print("失败了")
            }
        }
    }
    
    // 最后自动保存
    @objc func saveAction() {
        if sideFinish && self.frontFinish {
            // 全部完成，开始保存
            if let fronImage = self.frontResultImage, let sideImage = self.sideResultImage {
                self.cacheModel.saveImages(frontImage: fronImage, sideImage: sideImage) {
                    
                }
            }
        }
    }
    
    func showLoading() {
        
    }

}

extension WGCameraViewController: WGCameraOverlayDelegate {
    func changeDirection(front: Bool) {
        self.isFront = front
    }
}
