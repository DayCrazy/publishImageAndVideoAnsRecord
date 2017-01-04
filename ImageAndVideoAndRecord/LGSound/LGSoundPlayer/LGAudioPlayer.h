//
//  LGAudioPlayer.h
//  下载地址：https://github.com/gang544043963/LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSUInteger, LGAudioPlayerState){
	LGAudioPlayerStateNormal = 0,/**< 未播放状态 */
	LGAudioPlayerStatePlaying = 2,/**< 正在播放 */
	LGAudioPlayerStateCancel = 3,/**< 播放被取消 */
};

@protocol LGAudioPlayerDelegate <NSObject>

- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index;

@end

@interface LGAudioPlayer : NSObject

@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, weak) id<LGAudioPlayerDelegate>delegate;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIButton* playerButton;

+ (instancetype)sharePlayer;

- (void)playAudioWithURLString:(NSString *)URLString atIndex:(NSUInteger)index withParentButton:(UIButton*)playerButton;

- (void)stopAudioPlayer;

@end
