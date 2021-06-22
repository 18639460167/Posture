//
//  WGImageTool.h
//  Posture
//
//  Created by 窝瓜 on 2021/6/18.
//  Copyright © 2021 LOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGImageTool : NSObject

+ (void)compressedImageFiles:(UIImage *)image
                  imageBlock:(void(^)(NSData *imageData))block;

@end

NS_ASSUME_NONNULL_END
