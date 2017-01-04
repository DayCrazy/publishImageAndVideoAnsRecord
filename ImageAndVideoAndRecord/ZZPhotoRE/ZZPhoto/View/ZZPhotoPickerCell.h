//
//  ZZPhotoPickerCell.h
//  ZZFramework
//
//  Created by Yuan on 15/7/7.
//  Copyright (c) 2015年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"
#import "ZZPhoto.h"

@interface ZZPhotoPickerCell : UICollectionViewCell

@property(strong,nonatomic) UIImageView *photo;
@property(strong,nonatomic) UIButton *selectBtn;

@property(strong,nonatomic) void(^selectBlock)();

@property(assign,nonatomic) BOOL isSelect;

-(void)loadPhotoData:(ZZPhoto *)photo;

@end
