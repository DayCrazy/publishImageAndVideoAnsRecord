//
//  showVideoView.m
//  BaseFramework
//
//  Created by 李丹阳 on 2016/11/22.
//  Copyright © 2016年 李丹阳. All rights reserved.
//

#import "showVideoView.h"

#import "ViewController.h"
#import "Masonry.h"

#import "ZZCameraController.h"
#import "ZZBrowserPickerViewController.h"
#import "ZZPhotoController.h"
#import "ZZPhoto.h"
#import "ZZCamera.h"

#import "CircleCollectionView.h"
#import "CircleCollectionViewCell.h"
#import "CircleCellModel.h"
#import "lame.h"
#import "UIView+Size.h"

#import "LGAudioKit.h"



#define collectionViewHeight 60
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define MAXIMAGENUMBER   6

#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height

@interface showVideoView () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,KZVideoViewControllerDelegate>

@property (nonatomic, weak) NSTimer *timerOf60Second;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation showVideoView{
    
    ViewController* superViewController;
    CircleCollectionView* circleCollectionView;
    UIButton* playButton;
    CGFloat photoNumber;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubViews];
    }
    
    return self;
    
}

- (void)setIsPhoto:(BOOL)isPhoto{
    
    if (_isPhoto != isPhoto) {
        
        _isPhoto = isPhoto;
        
        if (isPhoto) {
            
            [_addVideoButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_addImageButton.mas_left);
            }];
            
            _addImageButton.hidden = YES;
            
            if (_isRecord) {
                
                [playButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(circleCollectionView.mas_top).offset(-10);
                }];
                
            }else if(_isVideo){
                
                [circleCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(_player.mas_bottom).offset(10);
                    
                }];
            }
            
            _addVideoButton.enabled = NO;
            
            [_addVideoButton setImage:[UIImage imageNamed:@"second_video_s"] forState:UIControlStateNormal];
            
        }else{
            
            self.height = self.height - circleCollectionView.height;
            
            _addImageButton.hidden = NO;
            
            _addVideoButton.enabled = YES;
            
            [_addVideoButton setImage:[UIImage imageNamed:@"second_video_d"] forState:UIControlStateNormal];
            
            //_addVideoButton 位置没变
            [_addVideoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom);
                make.left.equalTo(_addImageButton.mas_right).offset(5);
                make.width.mas_equalTo(78);
                make.height.mas_equalTo(78);
            }];
            
        }
        
    }
    
}

- (void)setIsVideo:(BOOL)isVideo{
    
    if (_isVideo != isVideo) {
        
        _isVideo = isVideo;
        
        if (isVideo) {
            
            self.height = self.height + 80;
            
            [_addRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_addVideoButton.mas_left);
            }];
            
            
            if (_isRecord) {
                
                [playButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(_player.mas_bottom).offset(10);
                }];
                
            }else{
                
                if (_isPhoto){
                    
                    [circleCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.equalTo(self.mas_left).offset(12);
                        make.right.equalTo(self.mas_right).offset(-12);
                        make.top.equalTo(_player.mas_bottom).offset(10);
                        if (circleCollectionView.photoArray.count > 4) {
                            
                            make.height.mas_equalTo(2*60);
                            
                        }else{
                            make.height.mas_equalTo(60);
                            
                        }
                        
                    }];
                    
                }
                
            }
            
            _addVideoButton.hidden = YES;
            
            _addImageButton.enabled = NO;
            [_addImageButton setImage:[UIImage imageNamed:@"second_img_s"] forState:UIControlStateNormal];
            
        }else{
            
            self.height = self.height - 80;
            
            _addVideoButton.hidden = NO;
            
            [_addRecordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self.mas_bottom);
                make.left.equalTo(_addVideoButton.mas_right).offset(5);
                make.width.mas_equalTo(78);
                make.height.mas_equalTo(78);
            }];
            
            if (_isRecord) {
                
                [playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.mas_top);
                    make.left.equalTo(self.mas_left).offset(12);
                    make.right.equalTo(self.mas_right).offset(-12);
                    make.height.mas_equalTo(52);
                }];
                
            }else{
                
                if (_isPhoto){
                    
                    [circleCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.equalTo(self.mas_left).offset(12);
                        make.right.equalTo(self.mas_right).offset(-12);
                        make.top.equalTo(self.mas_top);
                        if (circleCollectionView.photoArray.count > 4) {
                            
                            make.height.mas_equalTo(2*60);
                            
                        }else{
                            make.height.mas_equalTo(60);
                            
                        }
                    }];
                    
                }
                
            }
            
            _addImageButton.enabled = YES;
            [_addImageButton setImage:[UIImage imageNamed:@"second_img_d"] forState:UIControlStateNormal];
            
        }
    }
    
    
}

- (void)setIsRecord:(BOOL)isRecord{
    
    if (_isRecord != isRecord) {
        
        _isRecord = isRecord;
        
        if (isRecord) {
            
            self.height = self.height + 62;
            
            _addRecordButton.hidden = YES;
            
            if (_isVideo) {
                
                [playButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_player.mas_bottom).offset(10);
                }];
                
            }
            
            if (_isPhoto) {
                
                [circleCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(playButton.mas_bottom).offset(10);
                    make.left.equalTo(self.mas_left).offset(12);
                    make.right.equalTo(self.mas_right).offset(-12);
                    
                    if (circleCollectionView.photoArray.count > 4) {
                        
                        make.height.mas_equalTo(2*60);
                        
                    }else{
                        make.height.mas_equalTo(60);
                        
                    }
                }];
                
            }
            
        }else{
            
            self.height = self.height - 62;
            
            _addRecordButton.hidden = NO;
            
            if (_isPhoto) {
                
                if (_isVideo) {
                    
                    [circleCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.equalTo(_player.mas_bottom).offset(10);
                        make.left.equalTo(self.mas_left).offset(12);
                        make.right.equalTo(self.mas_right).offset(-12);
                        
                        if (circleCollectionView.photoArray.count > 4) {
                            
                            make.height.mas_equalTo(2*60);
                            
                        }else{
                            make.height.mas_equalTo(60);
                            
                        }
                    }];
                    
                }else{
                    
                    [circleCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.equalTo(self.mas_left).offset(12);
                        make.right.equalTo(self.mas_right).offset(-12);
                        make.top.equalTo(self.mas_top);
                        if (circleCollectionView.photoArray.count > 4) {
                            
                            make.height.mas_equalTo(2*60);
                            
                        }else{
                            make.height.mas_equalTo(60);
                            
                        }
                    }];
                }
                
            }
            
            
        }
        
    }
    
    
}



- (void)initSubViews{
    
    _addImageButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 0, 78, 78)];
    [_addImageButton setImage:[UIImage imageNamed:@"second_img_d"] forState:UIControlStateNormal];
    [_addImageButton addTarget:self action:@selector(addImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addImageButton];
    [_addImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(78);
    }];
    
    _addVideoButton = [[UIButton alloc]initWithFrame:CGRectMake(_addImageButton.right+5, _addImageButton.top, _addImageButton.width, _addImageButton.height)];
    [_addVideoButton setImage:[UIImage imageNamed:@"second_video_d"] forState:UIControlStateNormal];
    [_addVideoButton addTarget:self action:@selector(_addVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addVideoButton];
    [_addVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(_addImageButton.mas_right).offset(5);
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(78);
    }];
    
    _addRecordButton = [[UIButton alloc]initWithFrame:CGRectMake(_addVideoButton.right+5, _addVideoButton.top, _addVideoButton.width, _addVideoButton.height)];
    [_addRecordButton setImage:[UIImage imageNamed:@"second_sounding_d"] forState:UIControlStateNormal];
    [_addRecordButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
    [_addRecordButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    [_addRecordButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    [_addRecordButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
    [_addRecordButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    
    [self addSubview:_addRecordButton];
    
    [_addRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(_addVideoButton.mas_right).offset(5);
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(78);
    }];
    
    //照片Collection
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumInteritemSpacing = 5;
    flowlayout.minimumLineSpacing = 5;
    flowlayout.itemSize = CGSizeMake((kScreenWidth-24-15)/4, 52);
    circleCollectionView = [[CircleCollectionView alloc]initWithFrame:CGRectMake(12,0, kScreenWidth-24, collectionViewHeight) collectionViewLayout:flowlayout];
    circleCollectionView.photoArray = [NSMutableArray array];
    circleCollectionView.hidden = YES;
    [self addSubview:circleCollectionView];
    
    [circleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.mas_equalTo(60);
        //        make.top.equalTo(self.mas_top);
    }];
    
    if (self.imgeArray == nil) {
        
        self.imgeArray = [[NSMutableArray alloc]init];
    }
    
}

#pragma mark 🎱 添加照片
- (void)addImageButtonAction:(UIButton*)sender{
    
    superViewController = [self getViewController];
    
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction* takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ZZCameraController *cameraController = [[ZZCameraController alloc]init];
        cameraController.takePhotoOfMax = MAXIMAGENUMBER;
        
        cameraController.isSaveLocal = NO;
        [cameraController showIn:[self getParentviewController] result:^(id responseObject){
            
            NSLog(@"%@",responseObject);
            NSArray *array = (NSArray *)responseObject;
            
            [self addImageToshowCirclectionView:array];
            [circleCollectionView reloadData];
            
        }];
        
    }];
    
    UIAlertAction* choosePictureAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ZZPhotoController *photoController = [[ZZPhotoController alloc]init];
        photoController.selectPhotoOfMax = MAXIMAGENUMBER;
        //设置相册中完成按钮旁边小圆点颜色。
        photoController.roundColor = [UIColor purpleColor];
        
        [photoController showIn:[self getParentviewController]result:^(id responseObject){
            
            NSArray *array = (NSArray *)responseObject;
            [self addImageToshowCirclectionView:array];
            
            [circleCollectionView reloadData];
            
        }];
    }];
    
    [alertVC addAction:cancleAction];
    [alertVC addAction:takePhotoAction];
    [alertVC addAction:choosePictureAction];
    
    [[self getParentviewController] presentViewController:alertVC animated:YES completion:nil];
    
    
}

#pragma mark 🎱添加视频

- (void)_addVideoButtonAction:(UIButton*)sender{
    
    KZVideoViewController *videoVC = [[KZVideoViewController alloc] init];
    videoVC.delegate = self;
    [videoVC startAnimationWithType:KZVideoViewShowTypeSingle];
}


#pragma mark - Private Methods

/**
 *  开始录音
 */
- (void)startRecordVoice{
    
    if (self.isVideo) {
        
        [_player stop];
        
    }
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        //		//停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //		//开始录音
        [[LGSoundRecorder shareInstance] startSoundRecord:[self getParentviewController].view recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopSendVodio) userInfo:nil repeats:YES];
    } else {
        
    }
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice {
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self showShotTimeSign];
        return;
    }
    
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 61) {
        [self sendSound];
        [[LGSoundRecorder shareInstance] stopSoundRecord:[self getParentviewController].view];
    }
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecordVoice {
    [[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
    [[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice {
    [[LGSoundRecorder shareInstance] soundRecordFailed:[self getParentviewController].view];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:[self getParentviewController].view];
}

- (void)sixtyTimeStopSendVodio {
    
    int countDown = 60 - [[LGSoundRecorder shareInstance] soundRecordTime];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
    if (countDown <= 10) {
        [[LGSoundRecorder shareInstance] showCountdown:countDown - 1];
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] >= 59 && [[LGSoundRecorder shareInstance] soundRecordTime] <= 60) {
        
        [_addRecordButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
    }
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

#pragma mark 🎱 显示录音
- (void)sendSound {
    
    self.messageModel = [[LGMessageModel alloc] init];
    self.messageModel.soundFilePath = [[LGSoundRecorder shareInstance] soundFilePath];
    self.messageModel.seconds = [[LGSoundRecorder shareInstance] soundRecordTime];
    
    NSLog(@"recorder sound file path %@",self.messageModel.soundFilePath);
    
    //    self.messageModel.mp3FilePath = [self formatConversionToMp3];
    self.messageModel.mp3FilePath = [self audio_PCMtoMP3];
    
    
    playButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 0, kScreenWidth-24, 52)];
    [playButton setTitle:[NSString stringWithFormat:@"%.0fs",self.messageModel.seconds]forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    playButton.backgroundColor = [UIColor lightGrayColor];
    playButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [playButton setImage:[UIImage imageNamed:@"sound"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playRecordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:playButton];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.mas_equalTo(52);
        make.top.equalTo(self.mas_top);
    }];
    
    
    UIButton* deletVideo  = [[UIButton alloc]initWithFrame:CGRectMake(playButton.width-50 , (playButton.height-25)/2, 25, 25)];
    [deletVideo setImage:[UIImage imageNamed:@"delete28"] forState:UIControlStateNormal];
    [playButton addSubview:deletVideo];
    [deletVideo addTarget:self action:@selector(deleteRecordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.isRecord = YES;
    
    //[self chanageCircleCollectonFrame];
    
    
    
}

#pragma mark 🎱 显示照片
- (void)addImageToshowCirclectionView:(NSArray*)imageArray{
    
    circleCollectionView.hidden = NO;
    
    CGFloat circleCollectionHeight = 60;
    
    
    if (photoNumber >0) { //不是第一次添加照片
        
        photoNumber = photoNumber + imageArray.count;
        
        [self deleteAddPhotoButton];
        //        [self deleteAddVideoButton];
        
        //没有视频就是3张照片，若有视频就是2张
        if (photoNumber > 3) { // circleCollection变两行，刷新tableview
            
            circleCollectionHeight = collectionViewHeight*2;
            
            if (photoNumber - imageArray.count < 4) {
                
                self.height = self.height + collectionViewHeight;
                
            }
            
            
            if (photoNumber >= MAXIMAGENUMBER) {  //多次添加照片总数超过限制，截取7-self.imgeArray.count个元素拼接
                
                NSRange range = NSMakeRange(0, MAXIMAGENUMBER - circleCollectionView.photoArray.count);
                NSArray* tempArray = [imageArray subarrayWithRange:range];
                [self.imgeArray addObjectsFromArray:tempArray];
                
                for (int i = 0; i < tempArray.count; i++) {
                    
                    CircleCellModel *circelModel = [[CircleCellModel alloc]init];
                    
                    if ([tempArray[i] isKindOfClass:[ZZPhoto class]]) {
                        
                        ZZPhoto* model = tempArray[i];
                        
                        circelModel.photoImage = model.originImage;
                        
                    }else if([tempArray[i] isKindOfClass:[ZZCamera class]]){
                        
                        
                        ZZCamera* model = tempArray[i];
                        
                        circelModel.photoImage = model.image;
                    }else{
                        
                        circelModel.photoImage = tempArray[i];
                    }
                    
                    circelModel.state = CirModelStateNormal;
                    [circleCollectionView.photoArray addObject:circelModel];
                    
                }
                
                
                photoNumber = MAXIMAGENUMBER;
                
            }else{
                
                [self.imgeArray addObjectsFromArray:imageArray];
                
                for (int i = 0; i < imageArray.count; i++) {
                    CircleCellModel *circelModel = [[CircleCellModel alloc]init];
                    
                    if ([imageArray[i] isKindOfClass:[ZZPhoto class]]) {
                        
                        ZZPhoto* model = imageArray[i];
                        
                        circelModel.photoImage = model.originImage;
                        
                    }else if([imageArray[i] isKindOfClass:[ZZCamera class]]){
                        
                        
                        ZZCamera* model = imageArray[i];
                        
                        circelModel.photoImage = model.image;
                    }else{
                        
                        circelModel.photoImage = imageArray[i];
                    }
                    circelModel.state = CirModelStateNormal;
                    [circleCollectionView.photoArray addObject:circelModel];
                }
                
                //最后放一张pluse
                CircleCellModel *cirModel = [[CircleCellModel alloc]init];
                cirModel.photoImage = [UIImage imageNamed:@"plus"];
                cirModel.state = CirModelStateAdd;
                
                [circleCollectionView.photoArray addObject:cirModel];
                
                
            }
        }else{
            
            [self.imgeArray addObjectsFromArray:imageArray];
            
            for (int i = 0; i < imageArray.count; i++) {
                
                CircleCellModel *circelModel = [[CircleCellModel alloc]init];
                
                if ([imageArray[i] isKindOfClass:[ZZPhoto class]]) {
                    
                    ZZPhoto* model = imageArray[i];
                    
                    circelModel.photoImage = model.originImage;
                    
                }else if([imageArray[i] isKindOfClass:[ZZCamera class]]){
                    
                    
                    ZZCamera* model = imageArray[i];
                    
                    circelModel.photoImage = model.image;
                }else{
                    
                    circelModel.photoImage = imageArray[i];
                }
                
                circelModel.state = CirModelStateNormal;
                [circleCollectionView.photoArray addObject:circelModel];
                
            }
            
            //最后放一张pluse
            CircleCellModel *cirModel = [[CircleCellModel alloc]init];
            cirModel.photoImage = [UIImage imageNamed:@"plus"];
            cirModel.state = CirModelStateAdd;
            
            [circleCollectionView.photoArray addObject:cirModel];
            
        }
        
    }else{  //第一次添加照片
        
        
        photoNumber = photoNumber + imageArray.count;
        
        [circleCollectionView.photoArray removeAllObjects];
        
        if(self.imgeArray.count <=0){
            
            [self.imgeArray addObjectsFromArray:imageArray];
        }
        
        //没有视频就是3张照片，若有视频就是2张
        
        if (photoNumber > 3) { // circleCollection变两行，刷新tableview
            
            //            superViewController.photoHeight = 220;
            
            circleCollectionHeight = collectionViewHeight*2;
            
            
        }
        
        for (int i = 0; i < self.imgeArray.count; i++) {
            CircleCellModel *circelModel = [[CircleCellModel alloc]init];
            if ([imageArray[i] isKindOfClass:[ZZPhoto class]]) {
                
                ZZPhoto* model = imageArray[i];
                
                circelModel.photoImage = model.originImage;
                
            }else if([imageArray[i] isKindOfClass:[ZZCamera class]]){
                
                
                ZZCamera* model = imageArray[i];
                
                circelModel.photoImage = model.image;
            }else{
                
                circelModel.photoImage = imageArray[i];
                
            }
            circelModel.state = CirModelStateNormal;
            [circleCollectionView.photoArray addObject:circelModel];
            
        }
        
        if ( photoNumber < MAXIMAGENUMBER ) {
            
            //最后放一张pluse
            CircleCellModel *cirModel = [[CircleCellModel alloc]init];
            cirModel.photoImage = [UIImage imageNamed:@"plus"];
            cirModel.state = CirModelStateAdd;
            
            [circleCollectionView.photoArray addObject:cirModel];
            
        }else{
            
            //            if (photoNumber >= 7) {  //多次添加照片总数超过限制，截取7-self.imgeArray.count个元素拼接
            
            NSRange range = NSMakeRange(0, MAXIMAGENUMBER - circleCollectionView.photoArray.count);
            NSArray* tempArray = [imageArray subarrayWithRange:range];
            [self.imgeArray addObjectsFromArray:tempArray];
            
            for (int i = 0; i < tempArray.count; i++) {
                
                CircleCellModel *circelModel = [[CircleCellModel alloc]init];
                
                if ([tempArray[i] isKindOfClass:[ZZPhoto class]]) {
                    
                    ZZPhoto* model = tempArray[i];
                    
                    circelModel.photoImage = model.originImage;
                    
                }else if([tempArray[i] isKindOfClass:[ZZCamera class]]){
                    
                    
                    ZZCamera* model = tempArray[i];
                    
                    circelModel.photoImage = model.image;
                }else{
                    
                    circelModel.photoImage = tempArray[i];
                }
                
                circelModel.state = CirModelStateNormal;
                [circleCollectionView.photoArray addObject:circelModel];
                
            }
        }
        
        self.height = self.height + circleCollectionHeight;
        
        self.isPhoto = YES;
    }
    
    //    [self chanageCircleCollectonFrame];
    
    [circleCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(circleCollectionHeight);
        
        if (_isRecord) {
            
            make.top.equalTo(playButton.mas_bottom).offset(10);
        }else{
            
            make.top.equalTo(self.mas_top);
        }
    }];
    
    [circleCollectionView reloadData];
    
    
}

#pragma mark 🎱 视频录制或选择后回调
- (void)videoViewController:(KZVideoViewController *)videoController didRecordVideo:(KZVideoModel *)videoModel{
    
    [circleCollectionView reloadData];
    
    NSURL* videoUrl = [NSURL URLWithString:videoModel.videoAbsolutePath];
    
    [self movFileTransformToMP4WithSourceUrl:videoUrl completion:^(NSString *Mp4FilePath) {
        
        videoModel.videoAbsolutePath = Mp4FilePath;
    }];
    
    _videoModel = videoModel;
    
    [self playerVideo:videoModel];
    
    
}

#pragma mark 🎱 视频播放
- (void)playerVideo:(KZVideoModel*)videoModel{
    
//    if (self.isRecord) {
//        
////        [[LGAudioPlayer sharePlayer].audioPlayer stop];
//        
//        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
////        [self playRecordButtonAction:playButton];
//    }
    
    NSURL *videoUrl = [NSURL fileURLWithPath:videoModel.videoAbsolutePath];
    
    if (_player == nil) {
        
        if (videoUrl) {
            
            _player = [[KZVideoPlayer alloc] initWithFrame:CGRectMake(12, self.top, 102, 80) videoUrl:videoUrl];
            
        }
    }
    _player.layer.masksToBounds = NO;
    _player.backgroundColor = [UIColor blackColor];
    [self.superview addSubview:_player];
    [_player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(102);
        make.height.mas_equalTo(80);
    }];
    
    UIButton* deletVideo  = [[UIButton alloc]initWithFrame:CGRectMake(_player.width-20 , 0, 20, 20)];
    [deletVideo setImage:[UIImage imageNamed:@"delete28"] forState:UIControlStateNormal];
    [_player addSubview:deletVideo];
    [deletVideo addTarget:self action:@selector(deleteVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //    [self chanageCircleCollectonFrame];
    
    self.isVideo = YES;
    
    
}

#pragma mark 🎱 mov格式转MP4
- (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl completion:(void(^)(NSString *Mp4FilePath))comepleteBlock
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
        
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        
        exportSession.outputURL = sourceUrl;
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        CMTime start = CMTimeMakeWithSeconds(1.0, 600);
        
        CMTime duration = CMTimeMakeWithSeconds(3.0, 600);
        
        CMTimeRange range = CMTimeRangeMake(start, duration);
        
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    
                    NSLog(@"Export canceled");
                    
                    break;
                    
                default:
                    
                    break;
                    
            }
            
        }];
        
    }
}

#pragma mark 🎱 隐藏视频播放控件
- (void)deleteVideoButtonAction:(UIButton*)sender{
    
    //    sender.superview.hidden = YES;
    
    sender.superview.hidden = YES;
    
    self.isVideo = NO;
    [_player stop];
    _player.hidden = YES;
    _player = nil;
    [_player removeFromSuperview];
    _videoModel = nil;
    
}

#pragma mark 🎱 语音播放
- (void)playRecordButtonAction:(UIButton*)sender{
    
    if ( self.isVideo) {
        
        [_player stop];
    }
    
    [[LGAudioPlayer sharePlayer] playAudioWithURLString:self.messageModel.soundFilePath atIndex:0 withParentButton:sender];
}

#pragma mark 🎱 删除录音
- (void)deleteRecordButtonAction:(UIButton*)sender{
    
    [playButton removeFromSuperview];
    self.isRecord = NO;
    
    NSString *mp3FilePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"] ;
    
    
    //    [[NSFileManager defaultManager] removeItemAtPath:self.messageModel.soundFilePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:mp3FilePath error:nil];
    
    [_addRecordButton setImage:[UIImage imageNamed:@"second_sounding_d"] forState:UIControlStateNormal];
    
}

#pragma mark 🎱 删除一张照片
- (void)deleteCircleCollectionPhoto:(UIButton*)sender{
    
    CGFloat circleCollectonHeight = circleCollectionView.height;
    
    CircleCollectionViewCell *cell = (CircleCollectionViewCell*)sender.superview;
    
    //不会删掉imageArray里面数据
//    [cell.delegate deleteCurrentItem:cell];
    
//    [self.imgeArray removeObject:cell.model];
    
    //新删除方法
    [self.imgeArray removeObjectAtIndex:[cell.delegate deleteCurrentItem:cell]];
    
    photoNumber--;
    
    NSLog(@"%f",photoNumber);
    
    if (photoNumber == 0) {
        
        self.isPhoto = NO;
        //        [self refreshButtonFrame];
        
        //        addImageButton.hidden = NO;
        
        circleCollectionView.hidden = YES;
        
        //        if (isVideo) { //未添加视频
        //
        //            _addVideoButton.hidden = NO;
        //        }
        //
    }else if (photoNumber == 3) {
        
        
        circleCollectonHeight =  collectionViewHeight;
        
        self.height = self.height - collectionViewHeight;
        
        //        [self changeSuperScrollViewContentSize:self.height];
        
        
        //            _lineNumber = @"1";
        
        //
        
    }else if (photoNumber == 5){
        
        circleCollectonHeight = collectionViewHeight*2;
        
        NSMutableArray* photoArray = circleCollectionView.photoArray;
        
        CircleCellModel *cirModel = [[CircleCellModel alloc]init];
        cirModel.photoImage = [UIImage imageNamed:@"plus"];
        cirModel.state = CirModelStateAdd;
        
        if (self.isVideo) {
            
            [photoArray insertObject:cirModel atIndex:6];
            
        }else{
            
            [photoArray addObject:cirModel];
            
        }
        
        circleCollectionView.photoArray = photoArray;
        
    }
    
    [circleCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(circleCollectonHeight);
    }];
    ;
    
    [circleCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
}



#pragma mark 🎱 删除添加照片按钮➕
- (void)deleteAddPhotoButton{
    
    for (CircleCellModel *circelModel in circleCollectionView.photoArray) {
        
        if (circelModel.state == CirModelStateAdd) {
            
            [circleCollectionView.photoArray removeObject:circelModel];
            
            return;
        }
    }
}




#pragma mark 🎱 获取父视图
- (ViewController*)getViewController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            //            return (issueViewController*)nextResponder;
            return (ViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}




- (NSString*)audio_PCMtoMP3
{
    
    NSString *cafFilePath = self.messageModel.soundFilePath;    //caf文件路径
    
    NSString* fileName = [NSString stringWithFormat:@"/voice-%5.2f.mp3", [[NSDate date] timeIntervalSince1970] ];//存储mp3文件的路径
    
    NSString *mp3FileName = [[DocumentPath stringByAppendingPathComponent:@"SoundFile"] stringByAppendingPathComponent:fileName];
    
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FileName cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame, 2);//设置1为单通道，默认为2双通道
        lame_set_in_samplerate(lame, 8000.0);//11025.0
        //lame_set_VBR(lame, vbr_default);
        lame_set_brate(lame, 16);
        lame_set_mode(lame, 3);
        lame_set_quality(lame, 2);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        //        self.audioFileSavePath = mp3FilePath;
        NSLog(@"MP3生成成功: %@",mp3FileName);
    }
    
    return mp3FileName;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
