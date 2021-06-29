//
//  WGBodyPointInfoModel.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/21.
//  Copyright © 2021 LOL. All rights reserved.
//  人体信息解析

import UIKit

@objcMembers
class WGBodyPointInfoModel: WGBaseDataModel {
    var log_id: String = ""                     // 唯一的log id，用于问题定位
    var person_info: [WGPersonInfoModel] = []   // 人的关键点信息
    var person_num: NSInteger = 0               // 识别人的数量
    var isFront: Bool = true                    // 正面照
    
    class func modelContainerPropertyGenericClass() -> [String: Any]? {
        return ["person_info": [WGPersonInfoModel.classForCoder()]]
    }
    
    // 获取score最大的人像
    func getMaxBodyInfo() -> WGBodyPartsInfoModel? {
        if self.person_info.count > 0 {
            if self.person_info.count == 1 {
                return self.person_info[0].body_parts
            }
            var maxIndex = 0
            var score: CGFloat = self.person_info[1].location?.score ?? 0;
            for (index, info) in self.person_info.enumerated() {
                if score < (info.location?.score ?? 0) {
                    maxIndex = index
                    score = info.location?.score ?? 0
                }
            }
            if maxIndex < self.person_info.count {
                return self.person_info[maxIndex].body_parts!
            }
        }
        
        return nil
    }
}

@objcMembers
class WGPersonInfoModel: WGBaseDataModel {
    var body_parts: WGBodyPartsInfoModel? = nil       // 关键坐标点
    var location: WGPersionLocationInfoModel? = nil  // 人在图中的位置
    class func modelContainerPropertyGenericClass() -> [String: Any]? {
        return ["body_parts": WGBodyPartsInfoModel.classForCoder(),
                "location": WGPersionLocationInfoModel.classForCoder()]
    }
}

// MARK: - 关键点
@objcMembers
class WGBodyPartsInfoModel: WGBaseDataModel {
    // 头顶
    var top_head: WGPointInfoModel = WGPointInfoModel.init()
    // 鼻子
    var nose: WGPointInfoModel = WGPointInfoModel.init()
    // 颈部(喉结)
    var neck: WGPointInfoModel = WGPointInfoModel.init()
    
    // 左/右耳
    var left_ear: WGPointInfoModel = WGPointInfoModel.init()
    var right_ear: WGPointInfoModel = WGPointInfoModel.init()
    
    // 左/右眼
    var left_eye: WGPointInfoModel = WGPointInfoModel.init()
    var right_eye: WGPointInfoModel = WGPointInfoModel.init()
    
    // 左/右嘴角
    var left_mouth_corner: WGPointInfoModel = WGPointInfoModel.init()
    var right_mouth_corner: WGPointInfoModel = WGPointInfoModel.init()
    
    // 左/右手腕
    var left_wrist: WGPointInfoModel = WGPointInfoModel.init()
    var right_wrist: WGPointInfoModel = WGPointInfoModel.init()
    
    // 左/右手肘
    var left_elbow: WGPointInfoModel = WGPointInfoModel.init()
    var right_elbow: WGPointInfoModel = WGPointInfoModel.init()
    
    // 左/右肩
    var left_shoulder: WGPointInfoModel = WGPointInfoModel.init()
    var right_shoulder: WGPointInfoModel = WGPointInfoModel.init()
    
    // 左/右髋部
    var left_hip: WGPointInfoModel = WGPointInfoModel.init()
    var right_hip: WGPointInfoModel = WGPointInfoModel.init()
    
    // 左/右膝盖
    var left_knee: WGPointInfoModel = WGPointInfoModel.init()
    var right_knee: WGPointInfoModel = WGPointInfoModel.init()
    
    // 左/右脚踝
    var left_ankle: WGPointInfoModel = WGPointInfoModel.init()
    var right_ankle: WGPointInfoModel = WGPointInfoModel.init()
    
    // 侧身照是左侧还是右侧
    var isLeftBody: Bool {
        return left_ear.score >= right_ear.score
    }
    
    class func modelContainerPropertyGenericClass() -> [String: Any]? {
        return ["top_head": WGPointInfoModel.classForCoder(),
                "nose": WGPointInfoModel.classForCoder(),
                "neck": WGPointInfoModel.classForCoder(),
                "left_ear": WGPointInfoModel.classForCoder(),
                "right_ear": WGPointInfoModel.classForCoder(),
                "left_eye": WGPointInfoModel.classForCoder(),
                "right_eye": WGPointInfoModel.classForCoder(),
                "left_mouth_corner": WGPointInfoModel.classForCoder(),
                "right_mouth_corner": WGPointInfoModel.classForCoder(),
                "left_wrist": WGPointInfoModel.classForCoder(),
                "right_wrist": WGPointInfoModel.classForCoder(),
                "left_elbow": WGPointInfoModel.classForCoder(),
                "right_elbow": WGPointInfoModel.classForCoder(),
                "left_shoulder": WGPointInfoModel.classForCoder(),
                "right_shoulder": WGPointInfoModel.classForCoder(),
                "left_hip": WGPointInfoModel.classForCoder(),
                "right_hip": WGPointInfoModel.classForCoder(),
                "left_knee": WGPointInfoModel.classForCoder(),
                "right_knee": WGPointInfoModel.classForCoder(),
                "left_ankle": WGPointInfoModel.classForCoder(),
                "right_ankle": WGPointInfoModel.classForCoder()]
    }
    
    // 获取中心点
    func getBodyCenter(size: CGSize, isFront: Bool = false) -> UIView {
        let lineWidth: CGFloat = 5.0
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        var point1: CGPoint = CGPoint.init(x: self.right_ankle.x, y: self.right_ankle.y)
        var point2: CGPoint = CGPoint.init(x: self.left_ankle.x, y: self.left_ankle.y)
        if left_ankle.x < right_ankle.x {
            point1 = CGPoint.init(x: self.left_ankle.x, y: self.left_ankle.y)
            point2 = CGPoint.init(x: self.right_ankle.x, y: self.right_ankle.y)
        }
        let centerX = (point2.x+point1.x)/2.0
        let centerY = (point2.y+point1.y)/2.0
        let startPointX: CGFloat = centerX
        let startPointY: CGFloat = 0
        let endPointX: CGFloat = centerX
        let endPointY: CGFloat = size.height
        var startPoint = CGPoint.init(x: startPointX, y: startPointY)
        var endPoint = CGPoint.init(x: endPointX, y: endPointY)
        
        let pointShapeLayer = CAShapeLayer.init()
        pointShapeLayer.fillColor = UIColor.clear.cgColor
        pointShapeLayer.strokeColor = UIColor.init(hexString: "#6FE36F").cgColor
        pointShapeLayer.lineWidth = lineWidth
        if point1.y != point2.y, isFront {
            // 逆时针旋转
            let maxWidth: CGFloat = hypot(size.width, size.height)
            // 原始宽高
            let originWidth = CGFloat(fabsf(Float(point1.x - point2.x)))
            let originHeight = CGFloat(fabsf(Float(point1.y - point2.y)))
            let scale = originWidth/originHeight
    
            var bigWidth = maxWidth
            var bigHeight = maxWidth
            if originWidth > originHeight {
                bigWidth = scale * maxWidth
            } else {
                bigHeight = maxWidth/scale
            }
            let bigView = UIView.init(frame: .zero)
            bigView.center = CGPoint.init(x: centerX, y: centerY)
            bigView.bounds = CGRect.init(x: 0, y: 0, width: bigWidth, height: bigHeight)
            let bigLinePath = UIBezierPath.init()
            if point1.y < point2.y {
                bigLinePath.move(to: CGPoint.init(x: 0, y: 0))
                bigLinePath.addLine(to: CGPoint.init(x: bigView.bounds.width, y: bigView.bounds.height))
            } else {
                bigLinePath.move(to: CGPoint.init(x: 0, y: bigView.bounds.height))
                bigLinePath.addLine(to: CGPoint.init(x: bigView.bounds.width, y: 0))
            }
            pointShapeLayer.path = bigLinePath.cgPath
            bigView.layer.addSublayer(pointShapeLayer)
            
            // 图片旋转90实现垂直
            let resultImage = wg_getImageFromView(view: bigView).imageRotated(on: 90)
            let imageView = UIImageView.init(frame: .zero)
            imageView.center = bigView.center
            imageView.bounds = CGRect.init(x: 0, y: 0, width: bigView.bounds.height, height: bigView.bounds.width)
            imageView.image = resultImage
            view.addSubview(imageView)
        } else {
            if isFront == false {
                if self.isLeftBody {
                    startPoint = CGPoint.init(x: self.left_ankle.x, y: 0)
                    endPoint = CGPoint.init(x: self.left_ankle.x, y: size.height)
                } else {
                    startPoint = CGPoint.init(x: self.right_ankle.x, y: 0)
                    endPoint = CGPoint.init(x: self.right_ankle.x, y: size.height)
                }
            }
            let centerPath = UIBezierPath.init()
            centerPath.move(to: startPoint)
            centerPath.addLine(to: endPoint)
            pointShapeLayer.path = centerPath.cgPath
            view.layer.addSublayer(pointShapeLayer)
        }
        
        return view
        
    }
    
}

@objcMembers
class WGPointInfoModel: WGBaseDataModel {
    /**
     接口除了返回人体框和每个关键点的坐标信息外，还会输出人体框和关键点的概率分数，实际应用中可以基于概率分数进行过滤，排除掉分数低的误识别“无效人体”，推荐的过滤方案：当关键点得分大于0.2的个数大于3，且人体框的得分大于0.03时，才认为是有效人体。
     
     实际应用中，可根据对误识别、漏识别的容忍程度，调整阈值过滤方案，灵活应用，比如对误识别容忍低的应用场景，人体框的得分阈值可以提到0.06甚至更高。
     */
    var score: CGFloat = 0  // 概率分数
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
}

// MARK: - 人的位置信息
@objcMembers
class WGPersionLocationInfoModel: WGBaseDataModel {
    var score: CGFloat = 0  // 概率分数
    var left: CGFloat = 0.0
    var top: CGFloat = 0.0
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
}
