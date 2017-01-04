//
//  ZZPhotoPickerCell.m
//  ZZFramework
//
//  Created by Yuan on 15/7/7.
//  Copyright (c) 2015年 zzl. All rights reserved.
//

#import "ZZPhotoPickerCell.h"
#import "ZZAlumAnimation.h"
@implementation ZZPhotoPickerCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _photo = [[UIImageView alloc]initWithFrame:self.bounds];
        
        _photo.layer.masksToBounds = YES;
        
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_photo];
        
        
        CGFloat btnSize = self.frame.size.width / 4;
        
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - btnSize - 5, 5, btnSize, btnSize)];
        [_selectBtn addTarget:self action:@selector(selectPhotoButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectBtn];
        
    }
    return self;
}

-(void) selectPhotoButtonMethod:(UIButton *)sender
{
    [[ZZAlumAnimation sharedAnimation] selectAnimation:sender];
    self.selectBlock();
    
}

-(void)setIsSelect:(BOOL)isSelect
{
    if (isSelect == YES) {
        [_selectBtn setImage:Pic_Btn_Selected forState:UIControlStateNormal];
    }else{
        [_selectBtn setImage:Pic_btn_UnSelected forState:UIControlStateNormal];
    }
}


-(void)loadPhotoData:(ZZPhoto *)photo
{
    if (photo.isSelect == YES) {
        [_selectBtn setImage:Pic_Btn_Selected forState:UIControlStateNormal];
    }else{
        [_selectBtn setImage:Pic_btn_UnSelected forState:UIControlStateNormal];
    }
    
    if ([photo isKindOfClass:[ZZPhoto class]]) {

        [[PHImageManager defaultManager] requestImageForAsset:photo.asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info){
            self.photo.image = result;
            
        }];
        
    }
}
@end
