//
//  WGNetWorkTool.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/18.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit
import Alamofire

let baiduGetAccessTokenUrl = "https://aip.baidubce.com/oauth/2.0/token"
let baiduBodyAnalysisUrl = "https://aip.baidubce.com/rest/2.0/image-classify/v1/body_analysis"
let User_access_token = "User_access_token"
class WGNetWorkTool: NSObject {

    class func getBaiduAccesstToekn() {
        let params = [
            "grant_type": "client_credentials",
            "client_id": baiduAPIKey,
            "client_secret": baiduSecretKey
        ]
        Alamofire.request(baiduGetAccessTokenUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: [:]).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    let dict = json as! Dictionary<String,AnyObject>
                    let accessToken = dict["access_token"]
                    UserDefaults.standard.setValue(accessToken, forKey: User_access_token)
                    UserDefaults.standard.synchronize()
                    print("accessTOken:\(accessToken)")
                    break
                case .failure(let error):
                    print("请求错误:\(error)")
                }
            }
    }
    
    class func updateImage(image: UIImage) {
        let size = image.size
        if size.width < 50 || size.height < 50 {
            return
        }
        let token = (UserDefaults.standard.value(forKey: User_access_token) as? String) ?? ""
        let data = image.jpegData(compressionQuality: 1.0)
        let encodedImageStr = data?.base64EncodedString() ?? ""
        let url = baiduBodyAnalysisUrl + "?access_token=\(token)"
        print("url:(\(url)")
        let params = [
            "image": encodedImageStr
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: ["Content-Type": "application/x-www-form-urlencoded"]).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    print("accessTOken:\(json)")
                    break
                case .failure(let error):
                    print("请求错误:\(error)")
                }
            }
    }
    
    /// 获取网络状态
    class func NetWorkReachable() -> Bool {
        let networkManager = NetworkReachabilityManager(host: "https://www.baidu.com")
        let status = networkManager?.networkReachabilityStatus
        switch status {
        case .reachable(.ethernetOrWiFi), .reachable(.wwan):
            return true
        default:
            return false
        }
    }
}
