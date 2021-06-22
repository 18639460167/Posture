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
    
    class func modelContainerPropertyGenericClass() -> [String: Any]? {
        return ["person_info": [WGPersonInfoModel.classForCoder()]]
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
