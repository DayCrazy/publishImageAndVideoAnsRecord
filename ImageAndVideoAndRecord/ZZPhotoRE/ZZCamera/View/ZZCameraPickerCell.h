//
//  ZZCameraPickerCell.h
//  ZZFramework
//
//  Created by Yuan on 15/12/18.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"
@interface ZZCameraPickerCell : UICollectionViewCell

@property(strong,nonatomic) UIImageView *pics;
@property(strong,nonatomic) UIButton *removeBtn;

-(void)loadPhotoDatas:(UIImage *)image;

@end
