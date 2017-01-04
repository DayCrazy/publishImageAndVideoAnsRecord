//
//  ZZPhotoHud.h
//  ZZPhotoKit
//
//  Created by Yuan on 16/1/14.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZPhotoHud : UIView

+(ZZPhotoHud *)sharedHud;

+(void)showActiveHud;
+(void)hideActiveHud;

@end
