//
//  ZZPhotoHud.m
//  ZZPhotoKit
//
//  Created by Yuan on 16/1/14.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "ZZPhotoHud.h"

@interface ZZPhotoHud()

@property (strong ,nonatomic) UIView *hudView;
@property (strong ,nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong ,nonatomic) UILabel *hudLabel;

@end

@implementation ZZPhotoHud

+(ZZPhotoHud *)sharedHud
{
    static ZZPhotoHud *_photoHud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _photoHud = [[ZZPhotoHud alloc]init];
    });
    return _photoHud;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self makeInitUI];
    
    [self makeHudUI];
}

-(void) makeInitUI
{
    //清楚整个背景颜色
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

-(void) makeHudUI
{
    _hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 90)];
    _hudView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    _hudView.layer.cornerRadius = 8;
    _hudView.clipsToBounds = YES;
    _hudView.backgroundColor = [UIColor blackColor];
    _hudView.alpha = 0.8;
    [self addSubview:_hudView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicatorView.frame = CGRectMake(45, 15, 30, 30);
    [_hudView addSubview:_indicatorView];
    [_indicatorView startAnimating];
    
    _hudLabel = [[UILabel alloc] init];
    _hudLabel.frame = CGRectMake(0,40, 120, 50);
    _hudLabel.textAlignment = NSTextAlignmentCenter;
    _hudLabel.text = @"图片处理中...";
    _hudLabel.font = [UIFont systemFontOfSize:15];
    _hudLabel.textColor = [UIColor whiteColor];
    [_hudView addSubview:_hudLabel];
}

-(void) removeHudUI;
{
    [self removeFromSuperview];
    [_indicatorView stopAnimating];
}

+(void)showActiveHud
{
    [[self sharedHud] show];
}

+(void)hideActiveHud
{
    [[self sharedHud] removeHudUI];
}

@end
