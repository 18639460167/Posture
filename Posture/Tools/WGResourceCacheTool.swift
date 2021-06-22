//
//  WGResourceCacheTool.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/21.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit
import YYModel
import YYCache

class WGResourceCacheTool: NSObject {
    private let resourceCacheKey: String = "wg_cacheResourceKey"
    private var cache = YYCache.init(path: wg_documentPath().me_appendingPath(path: "DownLoadCache"))
    public static let sharedInstance: WGResourceCacheTool = {
        let instance = WGResourceCacheTool.init()
        instance.cache?.diskCache.errorLogsEnabled = true
        return instance
    }()
    
    // MARK: - 新增或更新数据
    func addOrUpdateDownLoadCache(_ messageModel: WGCacheModel) {
        var cacheList: [WGCacheModel] = self.cacheResourceList()
        if let index = cacheList.firstIndex(where: { (model) -> Bool in
            return messageModel.identifier == model.identifier
        }) {
            cacheList[index] = messageModel.copy() as! WGCacheModel
        } else {
            cacheList.append(messageModel.copy() as! WGCacheModel)
        }
        self.cache?.setObject((cacheList as NSArray) as NSCoding, forKey: resourceCacheKey)
    }
    
    /// 获取缓存列表
    func cacheResourceList() -> [WGCacheModel] {
        var cacheList: [WGCacheModel] = []
        cacheList = (self.cache?.object(forKey: resourceCacheKey) as? [WGCacheModel]) ?? cacheList
        return cacheList
    }
}

@objcMembers
class WGCacheModel: NSObject {
    var filePath: String = ""       // 文件缓存路径
    var createTime: String = ""     // 保存时间
    var maxIndex: NSInteger = 0     // 最新保存图的索引
    var saveImages: [WGCahceImageModel] = []  // 保存的图片信息
    var identifier: String = ""     // 唯一辨识(时间戳)
    
    // 最新保存图的名字
    private var newImageName: String {
        return "saveImage" + "\(self.maxIndex)"
    }
    
    @objc class func modelContainerPropertyGenericClass() -> [String: Any]? {
        return ["saveImages": [WGCahceImageModel.classForCoder()]]
    }
    
    func saveResultInfo() {
        DispatchQueue.global().async {
            for imgInfo in self.saveImages {
                if !FileManager.default.fileExists(atPath: imgInfo.imagePath) {
                    
                }
            }
        }
    }
}

@objcMembers
class WGCahceImageModel: NSObject {
    var imageName: String = ""    // 保存的图片名
    var saveTime: String = ""     // 保存时间
    var imagePath: String {
        return "image_" + saveTime
    }
}
