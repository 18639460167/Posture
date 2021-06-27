//
//  YYBaseTool.swift
//  RongyueNewSalerClient
//
//  Created by 窝瓜 on 2021/5/10.
//  Copyright © 2021 tree. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    // 裁剪图片制定区域
    public func cropImageWithArea(_ areaRect: CGRect) -> UIImage? {
        
        guard let sourceImageRef = self.cgImage else { return nil }
        // 1.判定是否超出裁剪区域
        let originSize = self.size
        var cropRect = areaRect
        let originScale = areaRect.size.width / areaRect.size.height
        if originSize.width < areaRect.size.width {
            cropRect.size.width = originSize.width
            cropRect.size.height = originSize.width / originScale
        }
        if originSize.height < areaRect.size.height {
            cropRect.size.height = originSize.height
            cropRect.size.width = originSize.height * originScale
        }
        print("cropRect:\(cropRect)")
        
        
        // 2.进行裁剪
        guard let cropImageRef = sourceImageRef.cropping(to: cropRect) else { return nil }
        return UIImage.init(cgImage: cropImageRef)
            //UIImage.init(cgImage: cropImageRef, scale: UIScreen.main.scale, orientation: .up)
        
    }
    // 图片方向纠正
    func zs_fixedImageToUpOrientation() -> UIImage {
        guard self.imageOrientation != .up, let cgImage = self.cgImage else {
            return self
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2)//-90.0
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        
        let ctx = CGContext.init(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)
        
        ctx?.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        
        guard let fiexedCGImage = ctx?.makeImage() else {return self}
        return UIImage(cgImage: fiexedCGImage)
    }
    
    /// 纠正旋转方向
    func zs_translateImage(direction: NSInteger) -> UIImage {
        var rotation = 0
        if direction == 1 {
            rotation = 90
        } else if direction == 2 {
            rotation = 180
        } else if direction == 3 {
            rotation = 270
        } else {
            return self
        }
        let resultImg = self.imageRotated(on: CGFloat(rotation))
        return resultImg
    }
    
    func imageRotated(on degrees: CGFloat) -> UIImage {
       // Following code can only rotate images on 90, 180, 270.. degrees.
       let degrees = round(degrees / 90) * 90
       let sameOrientationType = Int(degrees) % 180 == 0
       let radians = CGFloat.pi * degrees / CGFloat(180)
       let newSize = sameOrientationType ? size : CGSize(width: size.height, height: size.width)

       UIGraphicsBeginImageContext(newSize)
       defer {
         UIGraphicsEndImageContext()
       }

       guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
         return self
       }

       ctx.translateBy(x: newSize.width / 2, y: newSize.height / 2)
       ctx.rotate(by: radians)
       ctx.scaleBy(x: 1, y: -1)
       let origin = CGPoint(x: -(size.width / 2), y: -(size.height / 2))
       let rect = CGRect(origin: origin, size: size)
       ctx.draw(cgImage, in: rect)
       let image = UIGraphicsGetImageFromCurrentImageContext()
       return image ?? self
     }
}
