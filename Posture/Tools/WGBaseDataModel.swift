//
//  WGBaseDataModel.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/21.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit
import YYModel

class WGBaseDataModel: NSObject, NSCopying, NSCoding, YYModel, Codable {
    func encode(with aCoder: NSCoder) {
        self.yy_modelEncode(with: aCoder)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.yy_modelInit(with: aDecoder)
    }

    override var description: String {
        return yy_modelDescription()
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        return self.yy_modelCopy() as Any
    }

    override public func copy() -> Any {
        return self.yy_modelCopy() as Any
    }
}
