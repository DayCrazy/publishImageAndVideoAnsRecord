//
//  showVideoView.h
//  BaseFramework
//
//  Created by 李丹阳 on 2016/11/22.
//  Copyright © 2016年 李丹阳. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KZVideoViewController.h"
#import "KZVideoPlayer.h"
#import "KZVideoConfig.h"
#import "LGMessageModel.h"


@interface showVideoView : UIView


@property (nonatomic,strong)NSMutableArray* imgeArray;

@property (nonatomic,strong)KZVideoModel*  videoModel;

@property (nonatomic,strong)KZVideoPlayer *player;

@property (nonatomic,strong)LGMessageModel *messageModel;



@property (nonatomic, strong) UIButton* addImageButton;
@property (nonatomic, strong) UIButton* addVideoButton;
@property (nonatomic, strong) UIButton* addRecordButton;

@end
