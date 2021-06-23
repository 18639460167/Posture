//
//  WGCameraViewController.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/23.
//  Copyright © 2021 LOL. All rights reserved.
//  拍摄页

import UIKit

class WGCameraViewController: UIImagePickerController {

    init() {
        super.init(nibName: nil, bundle: nil)
        self.sourceType = .camera
        self.delegate = self
        self.showsCameraControls = false
        self.cameraOverlayView = self.overlayView
        self.cameraDevice = .rear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let previewSize = CGSize.init(width: ScreenWidth-34*ScreenScale, height: 486*ScreenScale)
        var offsetY: CGFloat = 0.0
        var scale: CGFloat = 2.0
        if (previewSize.height/previewSize.width) > (4.0 / 3.0){
            scale = 3.0 * previewSize.height / (4.0 * UIScreen.main.bounds.width)
            offsetY = previewSize.height * (scale - 1) * 0.5
        }
        self.cameraViewTransform = CGAffineTransform(translationX: 0, y: SafeTopHeight + offsetY)
        self.cameraViewTransform = self.cameraViewTransform.scaledBy(x: scale, y: scale)
    }
    
    lazy var overlayView: WGCameraOverlayView = {
        let view = WGCameraOverlayView.init(frame: UIScreen.main.bounds)
        return view
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WGCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let reultImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let image = reultImage.zs_fixedImageToUpOrientation()
            print("获取到结果图:\(image)")
        } else {
            if let reultImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let image = reultImage.zs_fixedImageToUpOrientation()
                print("获取到原始图:\(reultImage)")
            }
        }
    }
}
