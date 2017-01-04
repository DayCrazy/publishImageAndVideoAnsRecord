//
//  ZZPageControl.m
//  ZZFramework
//
//  Created by Yuan on 15/12/31.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZPageControl.h"

@implementation ZZPageControl

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _pageControl = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, self.frame.size.width - 10, self.frame.size.height - 6)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_pageControl];
    }
    return self;
}

@end
