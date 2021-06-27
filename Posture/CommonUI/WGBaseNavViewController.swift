//
//  METabBarViewController.swift
//  MandarinExam
//
//  Created by pisces_seven on 2021/5/17.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit

class WGBaseNavViewController: UINavigationController, UINavigationControllerDelegate {
    
    var popDelegate: UIGestureRecognizerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavigationBarHidden(true, animated: false)
        self.popDelegate = self.interactivePopGestureRecognizer?.delegate
        self.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    /// 统一处理tabbar隐藏于显示
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - UINavigationControllerDelegate方法
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self.viewControllers[0] {
            self.interactivePopGestureRecognizer!.delegate = self.popDelegate
        }
        else {
            self.interactivePopGestureRecognizer!.delegate = nil
        }
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
