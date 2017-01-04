//
//  ZZPhotoController.h
//  ZZFramework
//
//  Created by Yuan on 15/12/16.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZResourceConfig.h"
/*
 *    设置Block
 */
typedef void (^ZZPhotoResult)(id responseObject);


@interface ZZPhotoController : NSObject

/*
 *    设置圆点颜色
 */
@property(strong,nonatomic) UIColor *roundColor;
/*
 *    选择照片的最多张数
 */
@property(assign,nonatomic) NSInteger selectPhotoOfMax;

/*
 *    设置回调方法
 */
-(void)showIn:(UIViewController *)controller result:(ZZPhotoResult)result;

@end
