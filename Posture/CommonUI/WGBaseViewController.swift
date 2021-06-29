//
//  MEBaseViewController.swift
//  MandarinExam
//
//  Created by pisces_seven on 2021/5/17.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit
import SnapKit

let naviHeight = (SafeTopHeight + 48*ScreenScale)
let playAudioHeight = (110*ScreenScale + SafeBottomHeight)

class WGBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = Main_Color
    }

}
