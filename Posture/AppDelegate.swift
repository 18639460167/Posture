//
//  AppDelegate.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.init(hexString: "#293038")
        self.window?.rootViewController = WGBaseNavViewController.init(rootViewController: WGHomeViewController.init())
        self.window?.makeKeyAndVisible()
        wg_getCurrentTime()
        return true
    }


}

