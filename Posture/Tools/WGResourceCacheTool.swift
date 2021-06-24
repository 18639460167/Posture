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

let frontImgName: String = "front.png"
let sideImgName: String = "side.png"
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
class WGCacheModel: WGBaseDataModel {
    var filePath: String = ""       // 文件缓存路径
    var createTime: String = ""     // 保存时间
    var maxIndex: NSInteger = 0     // 最新保存图的索引
    var identifier: String = ""     // 唯一辨识(时间戳)
    
    var timeInfo: [String] = []     // 分割的时间信息
    var frontPartsInfo: WGBodyPartsInfoModel?    // 信息
    var sidePartsInfo: WGBodyPartsInfoModel?    // 侧身信息
    
    // 最新保存图的名字
    func floderPath() -> String {
        return FileManager.cacheResultRootPath().me_appendingPath(path: filePath)
    }
    
    // 保存图片
    func saveImages(frontImage: UIImage,
                    sideImage: UIImage,
                    handel:(() -> Void)?) {
        DispatchQueue.global().async {
            let time = wg_getCurrentTime().0
            let timeInfos = wg_getCurrentTime().1
            self.createTime = time
            self.identifier = time
            self.filePath = "img_\(time)"
            self.timeInfo = timeInfos
            FileManager.wg_createDirectory(self.floderPath())
            FileManager.wg_createDirectory(self.floderPath())
            FileManager.saveImage(to: self.floderPath().me_appendingPath(path: frontImgName), UIImage.init(named: "demo"))
            FileManager.saveImage(to: self.floderPath().me_appendingPath(path: sideImgName), UIImage.init(named: "demo1"))
            WGResourceCacheTool.sharedInstance.addOrUpdateDownLoadCache(self)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: SaveSuccessNotifiName, object: nil)
                handel?()
            }
        }
    }
    
    @objc class func modelContainerPropertyGenericClass() -> [String: Any]? {
        return ["partsInfo": WGBodyPartsInfoModel.classForCoder(),
                "sidePartsInfo": WGBodyPartsInfoModel.classForCoder()]
    }
}
