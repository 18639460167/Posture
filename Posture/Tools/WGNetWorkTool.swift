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

    static let shareTool: WGNetWorkTool = WGNetWorkTool.init()
    var tokenID: String = ""    // 百度TOkenID
    class func getBaiduAccesstToekn(handle: ((String?) -> Void)?) {
        if self.shareTool.tokenID.count > 0 {
            handle?(self.shareTool.tokenID)
            return
        }
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
                    if let accessToken = dict["access_token"] as? String {
                        self.shareTool.tokenID = accessToken
                        print("accessTOken:\(accessToken)")
                        handle?(accessToken)
                    } else {
                        handle?(nil)
                    }
                    break
                case .failure(let error):
                    handle?(nil)
                    print("请求错误:\(error)")
                }
            }
    }
    
    class func updateImage(image: UIImage, handle: ((Bool, WGBodyPointInfoModel?) -> Void)?) {
        self.getBaiduAccesstToekn { (token) in
            if let accessToken = token {
                let size = image.size
                if size.width < 50 || size.height < 50 {
                    return
                }
                let data = image.jpegData(compressionQuality: 1.0)
                let encodedImageStr = data?.base64EncodedString() ?? ""
                let url = baiduBodyAnalysisUrl + "?access_token=\(accessToken)"
                print("url:(\(url)")
                let params = [
                    "image": encodedImageStr
                ]
                Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: ["Content-Type": "application/x-www-form-urlencoded"]).validate()
                    .responseJSON { (response) in
                        switch response.result {
                        case .success(let json):
                            print("accessTOken:\(json)")
                            guard let jsonData = WGBodyPointInfoModel.yy_model(withJSON: response.data as Any) else {
                                DispatchQueue.main.async {
                                    handle?(false, nil)
                                }
                                return
                            }
                            if let info = json as? [String: Any] {
                                if let array = info["person_info"] as? NSArray {
                                    if let infoArray = NSArray.yy_modelArray(with: WGPersonInfoModel.classForCoder(), json: array) as? [WGPersonInfoModel] {
                                        print("=====:\(infoArray)")
                                        jsonData.person_info = infoArray
                                    }
                                }
                                
                            }
                            print("jsonData:\(jsonData), info:\(jsonData.person_info)")
                            DispatchQueue.main.async {
                                handle?(true, jsonData)
                            }
                            break
                        case .failure(let error):
                            DispatchQueue.main.async {
                                handle?(false, nil)
                            }
                            print("请求错误:\(error)")
                        }
                    }
            } else {
                DispatchQueue.main.async {
                    handle?(false, nil)
                }
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
    // 绘制点坐标，生成结果图
    class func drawPointInfo(info: WGBodyPartsInfoModel,
                             isFront: Bool,
                             resultImage: UIImage) -> UIImage {
        let lineWidth: CGFloat = 4.0
        let circleWidth: CGFloat = 20.0
        let size = resultImage.size
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        imageView.image = resultImage
        // 绘制眼的坐标
        let leftEyePoint = CGPoint.init(x: info.left_eye.x, y: info.left_eye.y)
        let rightEyePoint = CGPoint.init(x: info.right_eye.x, y: info.right_eye.y)
        let eyeCenterX = (leftEyePoint.x + rightEyePoint.x)/2.0
        let eyeCenterY = (leftEyePoint.y + rightEyePoint.y)/2.0
        let eyeCenterPoint = CGPoint.init(x: eyeCenterX, y: eyeCenterY)
        
        // 鼻子坐标
        let nosePoint = CGPoint.init(x: info.nose.x, y: info.nose.y)
        
        // 绘制肩膀的坐标
        let leftShoulderPoint = CGPoint.init(x: info.left_shoulder.x, y: info.left_shoulder.y)
        let rightShoulderPoint = CGPoint.init(x: info.right_shoulder.x, y: info.right_shoulder.y)
        let shoulderCenterX = (leftShoulderPoint.x+rightShoulderPoint.x)/2.0
        let shoulderCenterY = (leftShoulderPoint.y+rightShoulderPoint.y)/2.0
        let shoulderCenterPoint = CGPoint.init(x: shoulderCenterX, y: shoulderCenterY)
        
        // 绘制胯部
        let leftHipPoint = CGPoint.init(x: info.left_hip.x, y: info.left_hip.y)
        let rightHipPoint = CGPoint.init(x: info.right_hip.x, y: info.right_hip.y)
        let hipCenterX = (leftHipPoint.x+rightHipPoint.x)/2.0
        let hipCenterY = (leftHipPoint.y+rightHipPoint.y)/2.0
        let hipCenterPoint = CGPoint.init(x: hipCenterX, y: hipCenterY)
        
        //绘制膝盖
        let leftKneePoint = CGPoint.init(x: info.left_knee.x, y: info.left_knee.y)
        let rightKneePoint = CGPoint.init(x: info.right_knee.x, y: info.right_knee.y)
        let kneeCenterX = (leftKneePoint.x+rightKneePoint.x)/2.0
        let kneeCenterY = (leftKneePoint.y+rightKneePoint.y)/2.0
        let kneeCenterPoint = CGPoint.init(x: kneeCenterX, y: kneeCenterY)
        
        //绘制脚踝
        let leftAnklePoint = CGPoint.init(x: info.left_ankle.x, y: info.left_ankle.y)
        let rightAnklePoint = CGPoint.init(x: info.right_ankle.x, y: info.right_ankle.y)
        let ankleCenterX = (leftAnklePoint.x+rightAnklePoint.x)/2.0
        let ankleCenterY = (leftAnklePoint.y+rightAnklePoint.y)/2.0
        let ankleCenterPoint = CGPoint.init(x: ankleCenterX, y: ankleCenterY)
        
        let pointShapeLayer = CAShapeLayer.init()
        pointShapeLayer.fillColor = UIColor.clear.cgColor
        pointShapeLayer.strokeColor = UIColor.init(hexString: "#E33938").cgColor
        pointShapeLayer.lineWidth = lineWidth
        
        let mupath = CGMutablePath.init()
        let eyePath = UIBezierPath.init()
        eyePath.move(to: leftEyePoint)
        eyePath.addLine(to: rightEyePoint)
        
        let shoulderPath = UIBezierPath.init()
        shoulderPath.move(to: leftShoulderPoint)
        shoulderPath.addLine(to: rightShoulderPoint)
        
        let hipPath = UIBezierPath.init()
        hipPath.move(to: leftHipPoint)
        hipPath.addLine(to: rightHipPoint)
        
//        let kneePath = UIBezierPath.init()
//        kneePath.move(to: leftKneePoint)
//        kneePath.addLine(to: rightKneePoint)
        // Ankle
        let anklePath = UIBezierPath.init()
        anklePath.move(to: leftAnklePoint)
        anklePath.addLine(to: rightAnklePoint)
       
        var centerPoints: [CGPoint] = []    // 中心点
        var circlePoints: [CGPoint] = []    // 黄色圆点
        if isFront {
            // 获取胸部中心点
            let leftChestPointx = (leftShoulderPoint.x + leftHipPoint.x)/2.0
            let leftChestPointY = (leftShoulderPoint.y + leftHipPoint.y)/2.0
            let rightChestPointx = (rightShoulderPoint.x + rightHipPoint.x)/2.0
            let rightChestPointY = (rightShoulderPoint.y + rightHipPoint.y)/2.0
            let leftChestPoint = CGPoint.init(x: leftChestPointx, y: leftChestPointY)
            let rightChestPoint = CGPoint.init(x: rightChestPointx, y: rightChestPointY)
            let chestCenterPoint = CGPoint.init(x: (leftChestPointx+rightChestPointx)/2.0, y: (leftChestPointY+rightChestPointY)/2.0)
            let chestPath = UIBezierPath.init()
            chestPath.move(to: leftChestPoint)
            chestPath.addLine(to: rightChestPoint)

            
            mupath.addPath(eyePath.cgPath)
            mupath.addPath(shoulderPath.cgPath)
            mupath.addPath(chestPath.cgPath)
            mupath.addPath(hipPath.cgPath)
            mupath.addPath(anklePath.cgPath)
            centerPoints = [eyeCenterPoint, nosePoint, shoulderCenterPoint, chestCenterPoint,hipCenterPoint, ankleCenterPoint]
            circlePoints = [leftEyePoint, rightEyePoint, nosePoint, leftShoulderPoint, rightShoulderPoint, leftHipPoint, rightHipPoint, leftChestPoint, rightChestPoint, leftAnklePoint, rightAnklePoint]
        }
        
        if isFront == false {
            if info.isLeftBody {
                let letftEarPont = CGPoint.init(x: info.left_ear.x, y: info.left_ear.y)
                centerPoints = [letftEarPont, leftShoulderPoint, leftHipPoint, leftKneePoint, leftAnklePoint]
            } else {
                let rightEarPont = CGPoint.init(x: info.right_ear.x, y: info.right_ear.y)
                centerPoints = [rightEarPont, rightShoulderPoint, rightHipPoint, rightKneePoint, rightAnklePoint]
            }
        }
        let centerPath = UIBezierPath.init()
        for (index, point) in centerPoints.enumerated() {
            if index == 0 {
                centerPath.move(to: point)
            } else {
                centerPath.addLine(to: point)
            }
        }
        mupath.addPath(centerPath.cgPath)
        
        pointShapeLayer.path = mupath
        imageView.layer.addSublayer(pointShapeLayer)
        
        if isFront == false {
            circlePoints = centerPoints
        }
        for point in circlePoints {
            let circleVIew = UIImageView.init(frame: .zero)
            circleVIew.image = UIImage.init(named: "point_circle")
            circleVIew.bounds = CGRect.init(x: 0, y: 0, width: circleWidth, height: circleWidth)
            circleVIew.center = point
            imageView.addSubview(circleVIew)
        }
        
        let centerLayer = info.getBodyCenter(size: imageView.bounds.size, isFront: isFront)
        imageView.addSubview(centerLayer)
        let pointResultImage = wg_getImageFromView(view: imageView)
        return pointResultImage
    }
}


