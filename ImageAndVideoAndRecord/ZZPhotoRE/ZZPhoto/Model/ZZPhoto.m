//
//  ZZPhoto.m
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/25.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "ZZPhoto.h"

@implementation ZZPhoto

+(UIImage *) fetchThumbImageWithAsset:(PHAsset *)asset
{
    __block UIImage *thumbImage;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info){
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        
        //设置BOOL判断，确定返回高清照片
        if (downloadFinined) {

            thumbImage = result;
        }
        
    }];
    
    return thumbImage;
}

@end
