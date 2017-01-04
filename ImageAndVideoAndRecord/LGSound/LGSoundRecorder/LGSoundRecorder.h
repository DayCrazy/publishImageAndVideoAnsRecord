//
//  LGSoundRecorder.h
//  下载地址：https://github.com/gang544043963/LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol LGSoundRecorderDelegate <NSObject>

- (void)showSoundRecordFailed;
- (void)didStopSoundRecord;

@end

@interface LGSoundRecorder : NSObject

@property (nonatomic, copy) NSString *soundFilePath;
@property (nonatomic, weak) id<LGSoundRecorderDelegate>delegate;

+ (LGSoundRecorder *)shareInstance;
/**
 *  开始录音
 *
 *  @param view 展现录音指示框的父视图
 *  @param path 音频文件保存路径
 */
- (void)startSoundRecord:(UIView *)view recordPath:(NSString *)path;
/**
 *  录音结束
 */
- (void)stopSoundRecord:(UIView *)view;
/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)soundRecordFailed:(UIView *)view;
/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)readyCancelSound;
/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)resetNormalRecord;
/**
 *  录音时间过短
 */
- (void)showShotTimeSign:(UIView *)view ;
/**
 *  最后10秒，显示你还可以说X秒
 *
 *  @param countDown X秒
 */
- (void)showCountdown:(int)countDown;

- (NSTimeInterval)soundRecordTime;

@end
