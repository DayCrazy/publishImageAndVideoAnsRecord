//
//  ZZPhoto.h
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/25.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"
@interface ZZPhoto : NSObject

/**
   资源
 */
@property (nonatomic, strong) PHAsset *asset;
/**
   原尺寸图片
 */
@property (nonatomic, strong) UIImage *originImage;
/**
   照片在手机中的路径
 */
@property (nonatomic, strong) NSURL *imageUrl;
/**
   照片保存到相册中的时间
 */
@property (nonatomic, copy)   NSDate *createDate;
/**
   判断该图片是否选中
 */
@property (nonatomic, assign) BOOL isSelect;

+(UIImage *) fetchThumbImageWithAsset:(PHAsset *)asset;

@end
