//
//  WGAboutSpineCheckViewController.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/29.
//  Copyright © 2021 LOL. All rights reserved.
// 

import UIKit

class WGAboutSpineCheckViewController: WGBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpUI()
    }
    

    private func setUpUI() {
        let imageView = UIImageView.init(frame: .zero)
        imageView.image = UIImage.init(named: "about_icon")
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25*ScreenScale+SafeTopHeight)
            make.size.equalTo(CGSize.init(width: 195*ScreenScale, height: 195*ScreenScale))
        }
        let titleLbl = UILabel.init(frame: .zero)
        self.view.addSubview(titleLbl)
        titleLbl.text = "About Spine Check"
        titleLbl.textColor = UIColor.white
        titleLbl.font = UIFont.systemFont(ofSize: 23*ScreenScale, weight: .bold)
        titleLbl.textAlignment = .center
        titleLbl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp_bottom).offset(20*ScreenScale)
        }
        let message = "Spine Check is the first mobile application that offers an accessible at-home assessment for posture, created in collaboration with spinal experts. Poor posture commonly causes spinal dysfunction and joint degeneration, among a myriad of other illnesses. We strive to provide a reliable and informative test for posture, thereby empowering people to take preventative action regarding their posture before it is too late. Overall, we aim to increase awareness for postural health outside of the doctors’ office.\n \nNote: While Spine Check seeks to provide an accurate reference for postural health, we encourage everyone to seek medical consultation for professional diagnosis and advice. "
        let subLbl = UILabel.init(frame: .zero)
        self.view.addSubview(subLbl)
        subLbl.textColor = UIColor.white
        subLbl.numberOfLines = 0
        let font = UIFont.systemFont(ofSize: 12*ScreenScale, weight: .regular)
        subLbl.font = font
        subLbl.attributedText = message.me_addLineAttribute(5.0, kern: 0, font: font)
        subLbl.textAlignment = .center
        subLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35*ScreenScale)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLbl.snp_bottom).offset(30*ScreenScale)
        }
    }

}
