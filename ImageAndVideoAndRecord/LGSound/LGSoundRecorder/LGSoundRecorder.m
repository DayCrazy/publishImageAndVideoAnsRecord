//
//  LGSoundRecorder.m
//  下载地址：https://github.com/gang544043963/LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import "LGSoundRecorder.h"
#import "MBProgressHUD.h"

#pragma clang diagnostic ignored "-Wdeprecated"

#define GetImage(imageName)  [UIImage imageNamed:imageName]

@interface LGSoundRecorder()

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSString *recordPath;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *levelTimer;
//Views
@property (nonatomic, strong) UIImageView *imageViewAnimation;
@property (nonatomic, strong) UIImageView *talkPhone;
@property (nonatomic, strong) UIImageView *cancelTalk;
@property (nonatomic, strong) UIImageView *shotTime;
@property (nonatomic, strong) UILabel *textLable;
@property (nonatomic, strong) UILabel *countDownLabel;

@end

@implementation LGSoundRecorder


+ (LGSoundRecorder *)shareInstance {
    static LGSoundRecorder *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[LGSoundRecorder alloc] init];
        }
    });
    return sharedInstance;
}

#pragma mark - Public Methods

- (void)startSoundRecord:(UIView *)view recordPath:(NSString *)path {
    self.recordPath = path;
    [self initHUBViewWithView:view];
    [self startRecord];
}

- (void)stopSoundRecord:(UIView *)view {
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
    }
    
    NSString *str = [NSString stringWithFormat:@"%f",_recorder.currentTime];
    
    int times = [str intValue];
    if (self.recorder) {
        [self.recorder stop];
    }
    if (times >= 1) {
        if (view == nil) {
            view = [[[UIApplication sharedApplication] windows] lastObject];
        }
        
        if ([view isKindOfClass:[UIWindow class]]) {
            [view addSubview:_HUD];
        } else {
            [view.window addSubview:_HUD];
        }
        if (_delegate&&[_delegate respondsToSelector:@selector(didStopSoundRecord)]) {
            [_delegate didStopSoundRecord];
        }
    } else {
        [self deleteRecord];
        [self.recorder stop];
        if ([_delegate respondsToSelector:@selector(showSoundRecordFailed)]) {
            [_delegate showSoundRecordFailed];
        }
    }
    [self removeHUD];
}

- (void)soundRecordFailed:(UIView *)view {
    [self.recorder stop];
    [self removeHUD];
}

- (void)readyCancelSound {
    _imageViewAnimation.hidden = YES;
    _talkPhone.hidden = YES;
    _cancelTalk.hidden = NO;
    _shotTime.hidden = YES;
    _countDownLabel.hidden = YES;
    
    _textLable.frame = CGRectMake(0, CGRectGetMaxY(_imageViewAnimation.frame) + 20, 130, 25);
    _textLable.text = @"手指松开，取消发送";
    _textLable.backgroundColor = [UIColor redColor];
    _textLable.layer.masksToBounds = YES;
    _textLable.layer.cornerRadius = 3;
}

- (void)resetNormalRecord {
    _imageViewAnimation.hidden = NO;
    _talkPhone.hidden = NO;
    _cancelTalk.hidden = YES;
    _shotTime.hidden = YES;
    _countDownLabel.hidden = YES;
    _textLable.frame = CGRectMake(0, CGRectGetMaxY(_imageViewAnimation.frame) + 20, 130, 25);
    _textLable.text = @"手指上滑，取消发送";
    _textLable.backgroundColor = [UIColor clearColor];
}

- (void)showShotTimeSign:(UIView *)view {
    _imageViewAnimation.hidden = YES;
    _talkPhone.hidden = YES;
    _cancelTalk.hidden = YES;
    _shotTime.hidden = NO;
    _countDownLabel.hidden = YES;
    [_textLable setFrame:CGRectMake(0, 100, 130, 25)];
    _textLable.text = @"说话时间太短";
    _textLable.backgroundColor = [UIColor clearColor];
    
    [self performSelector:@selector(stopSoundRecord:) withObject:view afterDelay:1.5f];
}

- (void)showCountdown:(int)countDown{
    _textLable.text = [NSString stringWithFormat:@"还可以说%d秒",countDown];
}

- (NSTimeInterval)soundRecordTime {
    return _recorder.currentTime;
}

#pragma mark - Private Methods

- (void)initHUBViewWithView:(UIView *)view {
    if (_HUD) {
        [_HUD removeFromSuperview];
        _HUD = nil;
    }
    if (view == nil) {
        view = [[[UIApplication sharedApplication] windows] lastObject];
    }
    if (_HUD == nil) {
        _HUD = [[MBProgressHUD alloc] initWithView:view];
        _HUD.opacity = 0.4;
        
        CGFloat left = 22;
        CGFloat top = 0;
        top = 18;
        
        UIView *cv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 120)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 37, 70)];
        _talkPhone = imageView;
        _talkPhone.image = GetImage(@"toast_microphone");
        [cv addSubview:_talkPhone];
        left += CGRectGetWidth(_talkPhone.frame) + 16;
        
        top+=7;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 29, 64)];
        _imageViewAnimation = imageView;
        [cv addSubview:_imageViewAnimation];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 24, 52, 61)];
        _cancelTalk = imageView;
        _cancelTalk.image = GetImage(@"toast_cancelsend");
        [cv addSubview:_cancelTalk];
        _cancelTalk.hidden = YES;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 24, 18, 60)];
        self.shotTime = imageView;
        _shotTime.image = GetImage(@"toast_timeshort");
        [cv addSubview:_shotTime];
        _shotTime.hidden = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 14, 70, 71)];
        self.countDownLabel = label;
        self.countDownLabel.backgroundColor = [UIColor clearColor];
        self.countDownLabel.textColor = [UIColor whiteColor];
        self.countDownLabel.textAlignment = NSTextAlignmentCenter;
        self.countDownLabel.font = [UIFont systemFontOfSize:60.0];
        [cv addSubview:self.countDownLabel];
        self.countDownLabel.hidden = YES;
        
        left = 0;
        top += CGRectGetHeight(_imageViewAnimation.frame) + 20;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 130, 14)];
        self.textLable = label;
        _textLable.backgroundColor = [UIColor clearColor];
        _textLable.textColor = [UIColor whiteColor];
        _textLable.textAlignment = NSTextAlignmentCenter;
        _textLable.font = [UIFont systemFontOfSize:14.0];
        _textLable.text = @"手指上滑，取消发送";
        [cv addSubview:_textLable];
        
        _HUD.customView = cv;
        
        // Set custom view mode
        _HUD.mode = MBProgressHUDModeCustomView;
    }
    if ([view isKindOfClass:[UIWindow class]]) {
        [view addSubview:_HUD];
    } else {
        [view.window addSubview:_HUD];
    }
    [_HUD show:YES];
}

- (void)removeHUD {
    if (_HUD) {
        [_HUD removeFromSuperview];
        _HUD = nil;
    }
}

- (void)startRecord {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    //设置AVAudioSession
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err) {
        return;
    }
    
    //设置录音输入源
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
    err = nil;
    [audioSession setActive:YES error:&err];
    if(err) {
        return;
    }
    //设置文件保存路径和名称
    NSString *fileName = [NSString stringWithFormat:@"/voice-%5.2f.caf", [[NSDate date] timeIntervalSince1970] ];
    self.recordPath = [self.recordPath stringByAppendingPathComponent:fileName];
    NSURL *recordedFile = [NSURL fileURLWithPath:self.recordPath];
    NSDictionary *dic = [self recordingSettings];
    //初始化AVAudioRecorder
    err = nil;
    _recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:dic error:&err];
    if(_recorder == nil) {
        return;
    }
    //准备和开始录音
    [_recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    [self.recorder record];
    [_recorder recordForDuration:0];
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
    }
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.0001 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
}

- (void)deleteRecord {
    if (self.recorder) {
        [self.recorder stop];
        [self.recorder deleteRecording];
    }
    
    if (self.HUD) {
        [self.HUD hide:NO];
    }
}

- (void)levelTimerCallback:(NSTimer *)timer {
    if (_recorder&&_imageViewAnimation) {
        [_recorder updateMeters];
        double ff = [_recorder averagePowerForChannel:0];
        ff = ff+60;
        if (ff>0&&ff<=10) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_0")];
        } else if (ff>10 && ff<20) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_1")];
        } else if (ff >=20 &&ff<30) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_2")];
        } else if (ff >=30 &&ff<40) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_3")];
        } else if (ff >=40 &&ff<50) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_4")];
        } else if (ff >= 50 && ff < 60) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_5")];
        } else if (ff >= 60 && ff < 70) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_6")];
        } else {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_7")];
        }
    }
}

#pragma mark - Getters

- (NSDictionary *)recordingSettings
{
    NSMutableDictionary *recordSetting =[NSMutableDictionary dictionaryWithCapacity:10];
    [recordSetting setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //2 采样率
    [recordSetting setObject:[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];
    //3 通道的数目
    [recordSetting setObject:[NSNumber numberWithInt:2]forKey:AVNumberOfChannelsKey];
    //4 采样位数  默认 16
    [recordSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];//音频质量

    return recordSetting;
}

- (NSString *)soundFilePath {
    return self.recordPath;
}

@end

