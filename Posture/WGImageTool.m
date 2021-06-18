//
//  WGImageTool.m
//  Posture
//
//  Created by 窝瓜 on 2021/6/18.
//  Copyright © 2021 LOL. All rights reserved.
//

#import "WGImageTool.h"

@implementation WGImageTool

+ (void)compressedImageFiles:(UIImage *)image
                  imageBlock:(void(^)(NSData *imageData))block {
    
    //二分法压缩图片
    CGFloat compression = 1;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    CGFloat maxLength = 1024*4;
    if (imageData.length / 1024 < maxLength) {
        block(imageData);
        return;
    }
    image = [self fixOrientation:image];
    NSData *imageNewData = [self compressWithMaxLength:image maxLength:maxLength];
    NSLog(@"压缩之后的大小==%.2fM ", imageNewData.length / 1024.0/1024.0);
    block(imageNewData);
}

+ (NSData *)compressWithMaxLength:(UIImage *)image
                        maxLength:(NSUInteger)maxLength{
    
    //进行图像尺寸的压缩
    CGSize imageSize = image.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于4096(宽高比不按照2来算，按照1来算)
    if (width>4096||height>4096) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 4096;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 4096;
            width = height*scale;
        }
        //2.宽大于4096高小于4096
    }else if(width>4096||height<4096){
        CGFloat scale = height/width;
        width = 4096;
        height = width*scale;
        //3.宽小于4096高大于4096
    }else if(width<4096||height>4096){
        CGFloat scale = width/height;
        height = 4096;
        width = height*scale;
        //4.宽高都小于4096
    }else{
    }
    maxLength = maxLength * 1024;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //进行图像的画面质量压缩
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(newImage, compression);
    if (data.length / 1024 < maxLength) {
        return data;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(newImage, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

+ (UIImage *)fixOrientation:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform,M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width,0);
            transform = CGAffineTransformRotate(transform,M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform,0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width,0);
            transform = CGAffineTransformScale(transform, -1,1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height,0);
            transform = CGAffineTransformScale(transform, -1,1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage),0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
