//
//  ZZBrowserPickerViewController.h
//  ZZFramework
//
//  Created by Yuan on 15/12/23.
//  Copyright © 2015年 zzl. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"

typedef NS_ENUM(NSInteger, ShowAnimation){
    ShowAnimationOfPush,
    ShowAnimationOfPresent
    
};
@class ZZBrowserPickerViewController;

@protocol ZZBrowserPickerDelegate <NSObject>

@required
-(NSInteger)zzbrowserPickerPhotoNum:(ZZBrowserPickerViewController *)controller;
-(NSArray *)zzbrowserPickerPhotoContent:(ZZBrowserPickerViewController *)controller;

@optional
-(void)zzbrowerPickerPhotoRemove:(NSInteger) indexPath;

@end

@interface ZZBrowserPickerViewController : UIViewController

@property (assign, nonatomic) id <ZZBrowserPickerDelegate> delegate;

//是否开启动画效果
@property (assign, nonatomic) BOOL isOpenAnimation;

@property (assign, nonatomic) NSInteger showAnimation;
//滚动到指定位置(滚动到那张图片，通过下面属性)
@property (strong, nonatomic) NSIndexPath *indexPath;

-(void)reloadData;

-(void)showIn:(UIViewController *)controller animation:(ShowAnimation)animation;

@end
