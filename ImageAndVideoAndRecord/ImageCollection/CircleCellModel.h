
//
//  CircleCellModel.h
//  小莱
//
//  Created by 林颖 on 16/6/13.
//  Copyright © 2016年 李丹阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger{
    CirModelStateNormal = 0,
    CirModelStateAdd = 1,
    CirModelStateVideo = 2,
}cirModelState;


@interface CircleCellModel : NSObject

@property (nonatomic, retain) UIImage *photoImage;
@property (nonatomic,)cirModelState state;

@property (nonatomic, assign) NSInteger tag;

@end
