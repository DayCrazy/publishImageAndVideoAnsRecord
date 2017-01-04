//
//  ZZBrowserPickerCell.h
//  ZZFramework
//
//  Created by Yuan on 15/12/23.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"
@interface ZZBrowserPickerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *pics;

-(void)loadPHAssetItemForPics:(PHAsset *)assetItem;

@end
