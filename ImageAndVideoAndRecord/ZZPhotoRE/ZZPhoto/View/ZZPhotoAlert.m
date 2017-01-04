//
//  ZZPhotoAlert.m
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/8/28.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "ZZPhotoAlert.h"
#import "ZZResourceConfig.h"
@implementation ZZPhotoAlert

+(ZZPhotoAlert *)sharedAlert
{
    static ZZPhotoAlert *photoAlert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoAlert = [[ZZPhotoAlert alloc]init];
    });
    return photoAlert;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, ZZ_SCREEN_WIDTH, ZZ_SCREEN_HEIGHT);
        

        
    }
    return self;
}

-(void) showPhotoAlert
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    UILabel *alertlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    
    alertlabel.textColor = [UIColor whiteColor];
    
    alertlabel.textAlignment = NSTextAlignmentCenter;
    
    [alertlabel setNumberOfLines:0];
    
    NSString *alertText = @"温馨提示\n该图片尚未从iCloud中下载\n下载到本地后重试";
    
    alertlabel.text = alertText;
    
    alertlabel.textAlignment = NSTextAlignmentCenter;
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    alertlabel.font = font;
    
    CGSize labelsize = [alertText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    
    
    [alertlabel setFrame:CGRectMake(8, 8, labelsize.width, labelsize.height)];
    
    UIView * alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelsize.width + 16, labelsize.height +16)];
    
    alertView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    
    alertView.backgroundColor = [UIColor blackColor];
    
    alertView.alpha = 1;
    
    alertView.layer.masksToBounds = YES;
    
    alertView.layer.cornerRadius = 4;
    
    [alertView addSubview:alertlabel];
    
    [self addSubview:alertView];
    
    [UIView animateWithDuration:3.0f
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         alertView.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         if(alertView.alpha == 0) {
                             
                             [self removeFromSuperview];
                             
                         }
                     }];

}

@end
