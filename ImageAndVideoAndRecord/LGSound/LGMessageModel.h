//
//  LGMessageModel.h
//  下载地址：https://github.com/gang544043963/LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGMessageModel : NSObject

@property (nonatomic, copy) NSString *soundFilePath;
@property (nonatomic, assign) NSTimeInterval seconds;
@property (nonatomic, copy) NSString *mp3FilePath;
@end
