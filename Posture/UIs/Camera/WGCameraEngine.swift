//
//  WGCameraEngine.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/24.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit
import AVFoundation
import PhotosUI

protocol WGCameraEngineDelegate: class {
  func cameraManDidStart(_ cameraMan: WGCameraEngine)
}

class WGCameraEngine: NSObject {
    
    let session = AVCaptureSession()
    let queue = DispatchQueue(label: "no.hyper.ImagePicker.Camera.SessionQueue")
    
    var backCamera: AVCaptureDeviceInput?
    var stillImageOutput: AVCaptureStillImageOutput?
    var startOnFrontCamera: Bool = false
    weak var delegate: WGCameraEngineDelegate?
    
    deinit {
        self.stop()
    }
    func setup(_ startOnFrontCamera: Bool = false) {
        self.startOnFrontCamera = startOnFrontCamera
        self.start()
    }
    // MARK: - Session
    var currentInput: AVCaptureDeviceInput? {
        return session.inputs.first as? AVCaptureDeviceInput
    }
    // 开启相机
    fileprivate func start() {
        // Devices
        setupDevices()
        
        guard let input = self.backCamera, let output = stillImageOutput else { return }
        
        addInput(input)
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        queue.async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                // 相机开启
                self.delegate?.cameraManDidStart(self)
            }
        }
    }
    // 相机停止
    func stop() {
        self.session.stopRunning()
    }
    
    func addInput(_ input: AVCaptureDeviceInput) {
        configurePreset(input)
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
    }
    
    func setupDevices() {
        // Input
        AVCaptureDevice
            .devices()
            .filter {
                return $0.hasMediaType(AVMediaType.video)
            }.forEach {
                switch $0.position {
                case .back:
                    self.backCamera = try? AVCaptureDeviceInput(device: $0)
                default:
                    break
                }
            }
        // Output
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
    }
    
    // MARK: - Configure
    func configure(_ block: () -> Void) {
        session.beginConfiguration()
        block()
        session.commitConfiguration()
    }
    // MARK: - Preset
    func configurePreset(_ input: AVCaptureDeviceInput) {
        for asset in preferredPresets() {
            if input.device.supportsSessionPreset(AVCaptureSession.Preset(rawValue: asset)) && self.session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: asset)) {
                self.session.sessionPreset = AVCaptureSession.Preset(rawValue: asset)
                return
            }
        }
    }
    
    func preferredPresets() -> [String] {
        return [
            AVCaptureSession.Preset.hd1280x720.rawValue
        ]
    }
    
    // 保存图片
    func takePhoto(_ previewLayer: AVCaptureVideoPreviewLayer, completion: ((UIImage?) -> Void)? = nil) {
        guard let connection = stillImageOutput?.connection(with: AVMediaType.video) else { return }
        
        queue.async {
            self.stillImageOutput?.captureStillImageAsynchronously(from: connection) { buffer, error in
                guard let buffer = buffer, error == nil && CMSampleBufferIsValid(buffer),
                      let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer),
                      let image = UIImage(data: imageData)
                else {
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                    return
                }
                var resultImage = image.zs_fixedImageToUpOrientation()
                let imageHeight = 486.0/341.0*resultImage.size.width
                let rect = CGRect.init(x: 0, y: 0, width: resultImage.size.width, height: imageHeight)
                print("裁剪旋转之后结果图:\(resultImage);\(image);rect:\(rect)")
                resultImage = resultImage.cropImageWithArea(rect) ?? resultImage
                print("裁剪旋转之后结果图:\(resultImage);\(image)")
                DispatchQueue.main.async {
                    completion?(resultImage)
                }
            }
        }
    }
    
    // MARK: - Lock
    
    func lock(_ block: () -> Void) {
        if let device = currentInput?.device, (try? device.lockForConfiguration()) != nil {
            block()
            device.unlockForConfiguration()
        }
    }
    
    func flash(_ mode: AVCaptureDevice.FlashMode) {
        guard let device = currentInput?.device, device.isFlashModeSupported(mode) else { return }
        
        queue.async {
            self.lock {
                device.flashMode = mode
            }
        }
    }
    
    func focus(_ point: CGPoint) {
        guard let device = currentInput?.device, device.isFocusModeSupported(AVCaptureDevice.FocusMode.locked) else { return }
        
        queue.async {
            self.lock {
                device.focusPointOfInterest = point
            }
        }
    }
    
}
