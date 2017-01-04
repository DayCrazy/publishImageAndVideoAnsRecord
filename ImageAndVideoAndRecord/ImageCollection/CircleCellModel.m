//
//  CircleCellModel.m
//  小莱
//
//  Created by 林颖 on 16/6/13.
//  Copyright © 2016年 李丹阳. All rights reserved.
//

#import "CircleCellModel.h"

@implementation CircleCellModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.state = CirModelStateNormal;
    }
    return self;
}
@end
