//
//  ZZBrowserPickerCell.m
//  ZZFramework
//
//  Created by Yuan on 15/12/23.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZBrowserPickerCell.h"
#import "UIImageHandle.h"
@implementation ZZBrowserPickerCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _pics = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _pics.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_pics];
    }
    return self;
}

-(void)loadPHAssetItemForPics:(PHAsset *)assetItem
{
    PHAsset *phAsset = (PHAsset *)assetItem;
    
    CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
    CGFloat multiple = [UIScreen mainScreen].scale;
    CGFloat pixelWidth = photoWidth * multiple;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    
    [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        
        //设置BOOL判断，确定返回高清照片
        if (downloadFinined) {

            self.pics.image = result;
            
        }
        
    }];
}
@end
