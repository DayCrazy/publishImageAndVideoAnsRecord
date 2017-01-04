//
//  ZZCameraPickerCell.m
//  ZZFramework
//
//  Created by Yuan on 15/12/18.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZCameraPickerCell.h"



@implementation ZZCameraPickerCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _pics = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (ZZ_SCREEN_WIDTH - 60) / 5, (ZZ_SCREEN_WIDTH - 60) / 5)];
        
        _pics.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_pics];
        
        
        _removeBtn = [[UIButton alloc]initWithFrame:CGRectMake((ZZ_SCREEN_WIDTH - 60) / 5 -20, 0, 20, 20)];
        [_removeBtn setImage:Remove_Btn_Pic forState:UIControlStateNormal];
        
        [self.contentView addSubview:_removeBtn];
        
    }
    return self;
    
}

//载入数据
-(void)loadPhotoDatas:(UIImage *)image
{
    _pics.image = image;

}
@end
