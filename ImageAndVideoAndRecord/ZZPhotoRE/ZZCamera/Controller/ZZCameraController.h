//
//  ZZCameraController.h
//  ZZFramework
//
//  Created by Yuan on 15/12/18.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZResourceConfig.h"

typedef void(^ZZCameraResult)(id responseObject);

@interface ZZCameraController : NSObject

/*
 *   设置是否将拍完过后的照片直接保存到相册
 */
@property (assign, nonatomic) BOOL isSaveLocal;

/*
 *   设置最多连拍张数
 */
@property (assign, nonatomic) NSInteger takePhotoOfMax;


/*
 *   设置相机页面主题颜色，默认为黑色
 */
@property (strong, nonatomic) UIColor *LLDthemeColor;

-(void)showIn:(UIViewController *)controller result:(ZZCameraResult)result;

@end
