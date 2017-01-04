//
//  ZZCameraPickerViewController.h
//  ZZFramework
//
//  Created by Yuan on 15/12/18.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"

@interface ZZCameraPickerViewController : UIViewController

@property (assign, nonatomic) BOOL isSavelocal;

@property (assign, nonatomic) NSInteger takePhotoOfMax;

@property (strong, nonatomic) UIColor *LLDthemeColor;

@property (strong, nonatomic) void (^CameraResult)(id responseObject);

@end
