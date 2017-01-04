//
//  ZZPhotoListModel.h
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/19.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"
@interface ZZPhotoListModel : NSObject

@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) PHAsset *lastObject;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) PHAssetCollection *assetCollection;

@end
