//
//  ZZCameraFocusView.m
//  ZZFramework
//
//  Created by Yuan on 15/12/21.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZCameraFocusView.h"

@interface ZZCameraFocusView()

@property (strong, nonatomic) UIImageView *focus;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ZZCameraFocusView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _focus = [[UIImageView alloc]init];
        _focus.image = [UIImage imageNamed:@"camera_focus_pic.png"];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    _focus.frame = CGRectMake(0, 0, 80, 80);
    _focus.center = point;
    [self addSubview:_focus];
    
    [self shakeToShow:_focus];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideFocusView) userInfo:nil repeats:YES];
    if ([self.delegate respondsToSelector:@selector(cameraFocusOptions:)]) {
        [self.delegate cameraFocusOptions:self];
    }
}

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

-(void) hideFocusView
{
    [_focus removeFromSuperview];
    [_timer invalidate];
}

@end
