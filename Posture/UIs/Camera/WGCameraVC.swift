//
//  WGCameraVC.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/24.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit
import AVFoundation
import PhotosUI

class WGCameraVC: UIViewController {
    
    let cameraMan = WGCameraEngine()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var camerFinish: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        cameraMan.delegate = self
//        cameraMan.setup(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        previewLayer?.connection?.videoOrientation = .portrait
    }
    
    func setupPreviewLayer() {
        let layer = AVCaptureVideoPreviewLayer(session: cameraMan.session)
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.autoreverses = true
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        view.layer.insertSublayer(layer, at: 0)
        layer.frame = view.layer.bounds
        view.clipsToBounds = true
        
        previewLayer = layer
    }
    
    // 进行拍摄
    func takePicture(_ completion: @escaping (UIImage?) -> Void) {
        guard let previewLayer = previewLayer else { return }
        cameraMan.takePhoto(previewLayer) { (image) in
            completion(image)
        }
    }
    
}
extension WGCameraVC: WGCameraEngineDelegate {
    func cameraManDidStart(_ cameraMan: WGCameraEngine) {
        setupPreviewLayer()
        self.camerFinish?()
    }
}
