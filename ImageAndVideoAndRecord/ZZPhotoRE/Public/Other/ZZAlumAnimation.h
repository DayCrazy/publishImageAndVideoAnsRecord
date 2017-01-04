//
//  ZZAlumAnimation.h
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/19.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZResourceConfig.h"
@interface ZZAlumAnimation : NSObject

+(ZZAlumAnimation *)sharedAnimation;

-(void) roundAnimation:(UILabel *)label;

-(void) selectAnimation:(UIButton *)button;

@end
