//
//  ZZPhotoBrowerViewController.h
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/27.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"

@class ZZPhotoBrowerViewController;

@protocol ZZPhotoBrowerDataSource <NSObject>

@required
-(NSInteger)zzbrowserPickerPhotoNum:(ZZPhotoBrowerViewController *)controller;
-(NSArray *)zzbrowserPickerPhotoContent:(ZZPhotoBrowerViewController *)controller;

@end


@interface ZZPhotoBrowerViewController : UIViewController

@property (assign, nonatomic) id <ZZPhotoBrowerDataSource> delegate;


-(void)reloadData;

-(void)showIn:(UIViewController *)controller;

@end
