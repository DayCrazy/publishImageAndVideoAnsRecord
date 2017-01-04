//
//  ZZPhotoListViewController.h
//  ZZFramework
//
//  Created by Yuan on 15/12/17.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"
@interface ZZPhotoListViewController : UIViewController

@property(assign,nonatomic) NSInteger selectNum;

@property(strong,nonatomic) void (^photoResult)(id responseObject);

@end
