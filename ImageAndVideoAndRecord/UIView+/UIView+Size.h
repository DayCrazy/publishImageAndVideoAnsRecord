//
//  UIView+Size.h
//  ImageAndVideoAndRecord
//
//  Created by 李丹阳 on 2017/1/4.
//  Copyright © 2017年 李丹阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Size)

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

//获得视图的父控制器
- (UIViewController *)getParentviewController;
//设置push后的界面的leftItem只是箭头，且title为白色
- (void)setPushToViewLeftItemNil;
- (void)setTabBarPushToViewLeftItemNil;

//把颜色转为图片
+ (UIImage *)createImageWithColor: (UIColor *) color;

+ (UIImage *)createImageWithColor: (UIColor *) color size:(CGSize)size;

@end
