//
//  ZZPhotoListCell.h
//  ZZFramework
//
//  Created by Yuan on 15/12/17.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"
@interface ZZPhotoListCell : UITableViewCell
/*
 *    相册图片，显示相册的最后一张图片
 */
@property(strong,nonatomic) UIImageView *coverImage;
/*
 *    相册标题，显示相册的标题
 */
@property(strong,nonatomic) UILabel *title;
/*
 *    相册副标题，显示相册中含有多少张图片
 */
@property(strong,nonatomic) UILabel *subTitle;

/*
 *    加载数据方法
 */

-(void)loadPhotoListData:(PHAssetCollection *)assetItem;
@end
