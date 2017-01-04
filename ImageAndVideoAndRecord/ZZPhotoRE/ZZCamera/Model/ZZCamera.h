//
//  ZZCamera.h
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/25.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZCamera : NSObject

/**
 照片
 */
@property (nonatomic, strong) UIImage *image;

/**
 照片保存到相册中的时间
 */
@property (nonatomic, copy)   NSDate *createDate;


@end
