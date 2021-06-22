//
//  WGFileTool.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/21.
//  Copyright © 2021 LOL. All rights reserved.
//

import Foundation

func wg_documentPath() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first ?? ""
}

/// NSTemporaryDirectory
func wg_tempPath() -> String {
    return NSTemporaryDirectory()
}

extension FileManager {
    
    /// 多段视频分段视频文件
    class func cacheResultRootPath() -> String {
        let rootDirPath = wg_documentPath().me_appendingPath(path: "wg_cacheResult")
        guard  FileManager.wg_directoryIsExists(path: rootDirPath) == false  else {
            return rootDirPath
        }
        FileManager.wg_createDirectory(rootDirPath)
        return rootDirPath
    }
    
    /// 判定文件夹是否存在
    /// - Parameter path: 文件夹路径
    /// - Returns: true 存在，false 不存在
    static func wg_directoryIsExists(path :String) ->Bool {
        var Sfx_directoryExists = ObjCBool.init(false)
        let Sfx_fileExists = FileManager.default.fileExists(atPath: path, isDirectory: &Sfx_directoryExists)
        return Sfx_fileExists && Sfx_directoryExists.boolValue
    }
    
    //创建文件夹
    public class func wg_createDirectory(_ directoryPath: String) {
        print("createDirectory :\(directoryPath)")
        if self.default.fileExists(atPath: directoryPath) {
            print("文件夹已存在")
            return;
        }
        do {
            try self.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
            print("文件夹创建成功")
        } catch let error  {
            print(error.localizedDescription)
            print("文件夹创建失败")
        }
    }
    
    //保存图片
    public class func saveImage(to toPath: String, _ image: UIImage?)  {
        print("saveImage :\(toPath)")
        do {
            if image != nil {
                let url = URL(fileURLWithPath: toPath)
                try image?.pngData()?.write(to:url)
            }
        } catch  {
            print("saveImage error:\(error.localizedDescription)")
        }
    }
}
