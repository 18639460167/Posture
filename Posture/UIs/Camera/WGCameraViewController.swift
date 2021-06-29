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
        
        ME_GetAudioPermission { (success, first) in
            if success {
                self.cameraNotAuthView.isHidden = true
                self.cameraView.cameraMan.setup(false)
            } else {
                self.cameraNotAuthView.showAlert = true
            }
        }
    }
    
    func setUpUI() {
        self.view.layer.masksToBounds = true
        self.overlyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.view.addSubview(self.cameraView.view)
        self.view.bringSubviewToFront(self.overlyView)
        self.closeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(17*ScreenScale)
            make.size.equalTo(CGSize.init(width: 40*ScreenScale, height: 40*ScreenScale))
            make.top.equalToSuperview().offset(11*ScreenScale+SafeTopHeight)
        }
        
        self.secondAlertLbl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-167*ScreenScale-SafeBottomHeight)
        }
        self.firstAlertLbl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(secondAlertLbl.snp_top).offset(-5*ScreenScale)
        }
        self.cameraNotAuthView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "camera_back")
        imageView.isUserInteractionEnabled = false
        btn.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalTo(22*ScreenScale)
        }
        self.view.addSubview(btn)
        return btn
    }()
    
    @objc func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var overlyView: WGCameraOverlayView = {
        let view = WGCameraOverlayView.init(frame: .zero)
        view.camerBtn.addTarget(self, action: #selector(cameraAction), for: .touchUpInside)
        view.delegate = self
        view.isUserInteractionEnabled = false
        self.view.addSubview(view)
        return view
    }()
    
    lazy var cameraView: WGCameraVC = {
        let norScale: CGFloat = 72.0/128.0
        var width = ScreenWidth-34*ScreenScale
        var height = ScreenHeight-SafeTopHeight-SafeBottomHeight-160*ScreenScale
        let greenScale = CGFloat(width/height)
        print("计算前的scale：\(width) == height:\(height)")
        if greenScale > norScale {
            // 宽度固定 高度拉伸
            height = width / norScale
        } else {
            // 高度固定 宽度拉伸
            width = height*norScale
        }
        print("计算后的scale：\(width) == height:\(height)")
        let vc = WGCameraVC.init()
        vc.camerFinish = {[weak self] in
            self?.overlyView.isUserInteractionEnabled = true
        }
        vc.view.frame = CGRect.init(x: (ScreenWidth-width)/2.0, y: SafeTopHeight, width: width, height: height)
        return vc
    }()
    
    lazy var firstAlertLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        self.view.addSubview(label)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13*ScreenScale, weight: .medium)
        label.text = "Stand straight and face the camera"
        return label
    }()
    lazy var secondAlertLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        self.view.addSubview(label)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13*ScreenScale, weight: .medium)
        // Button lights up after adjusting the frame
        label.text = "Make sure the whole body is in the frame"
        return label
    }()
    
    lazy var cameraNotAuthView: WGNotCameraAuthView = {
        let view = WGNotCameraAuthView.init(frame: .zero)
        view.showAlert = false
//        view.showAlert = !WG_FirstCameraPermission
        self.view.addSubview(view)
        return view
    }()

    @objc func cameraAction() {
        WGLoadingView.showLoading()
        self.cameraView.takePicture {[weak self] (image) in
            if let resultImage = image {
                self?.updateImage(resultImage: resultImage)
            } else {
                WGLoadingView.hideLoading()
                print("失败了")
            }
        }
    }
    
    // 最后自动保存
    @objc func saveAction() {
        if sideFinish && self.frontFinish {
            self.overlyView.camerBtn.isUserInteractionEnabled = false
            // 全部完成，开始保存
            if let fronImage = self.frontResultImage, let sideImage = self.sideResultImage {
                self.cacheModel.saveImages(frontImage: fronImage, sideImage: sideImage) {
                    let vc = WGResultDetailVC.init()
                    vc.cacheModel = self.cacheModel
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.resetCameraMessage()
                }
            }
        }
    }
    
    // 拍照信息重制
    func resetCameraMessage() {
        self.cacheModel = WGCacheModel.init()
        self.frontFinish = false
        self.sideFinish = false
        self.overlyView.changeDirection(btn: self.overlyView.frontBtn)
        self.overlyView.camerBtn.isUserInteractionEnabled = true
    }

}

extension WGCameraViewController: WGCameraOverlayDelegate {
    func changeDirection(front: Bool) {
        self.isFront = front
        self.secondAlertLbl.textColor = .white
        self.secondAlertLbl.text = front ? "Make sure the whole body is in the frame" : "Button lights up after adjusting the frame"
    }
}

// MARK: - 图片识别
extension WGCameraViewController {
    private func updateImage(resultImage: UIImage) {
        WGNetWorkTool.updateImage(image: resultImage) { (success, infoModel) in
            if success, let infoModel = infoModel, let bodyInfo = infoModel.getMaxBodyInfo() {
                // 需要生成结果图
                if self.isFront{
                    let saveImage = WGNetWorkTool.drawPointInfo(info: bodyInfo , isFront: true, resultImage: resultImage)
                    self.cacheModel.frontPartsInfo = bodyInfo
                    self.frontResultImage = saveImage
                    self.frontFinish = true
                } else {
                    let saveImage = WGNetWorkTool.drawPointInfo(info: bodyInfo , isFront: false, resultImage: resultImage)
                    self.cacheModel.frontPartsInfo = bodyInfo
                    self.sideResultImage = saveImage
                    self.sideFinish = true
                }
            } else {
                self.secondAlertLbl.textColor = UIColor.init(hexString: "#E41717")
            }
            WGLoadingView.hideLoading()
        }
    }
}
