//
//  UIImageHandle.h
//  ZZFramework
//
//  Created by Yuan on 16/1/4.
//  Copyright © 2016年 zzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZResourceConfig.h"
@interface UIImageHandle : NSObject

/**
 *  等比例缩放图片
 *
 *  @param image 原始图片
 *  @param multiple  等比缩放倍数
 *
 *  @return 缩放之后的图片
 */
+(UIImage*)scaleImage:(UIImage *)image multiple:(CGFloat) multiple;

/**
 *  图片压缩
 *
 *  @param image 原始图片
 *
 *  @return 压缩后的如偏
 */
+(UIImage *)compressImage:(UIImage *)artWork;

/**
 *  裁剪图片
 *
 *  @param image 原始图片
 *  @param rect  参见矩形区域
 *
 *  @return 裁剪之后的图片
 */
+(UIImage *)cutRectangleImage:(UIImage *)image rect:(CGRect)rect;


@end
