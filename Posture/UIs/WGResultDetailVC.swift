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
    }

    lazy var frontBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        let frontPath = self.cacheModel.floderPath().me_appendingPath(path: frontImgName)
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.white.cgColor
        let image = UIImage.init(contentsOfFile: frontPath)
        btn.setBackgroundImage(image, for: .normal)
        self.view.addSubview(btn)
        return btn
    }()
    lazy var sideBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        let frontPath = self.cacheModel.floderPath().me_appendingPath(path: sideImgName)
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.white.cgColor
        let image = UIImage.init(contentsOfFile: frontPath)
        btn.setBackgroundImage(image, for: .normal)
        self.view.addSubview(btn)
        return btn
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.popViewController(animated: true)
    }

}
