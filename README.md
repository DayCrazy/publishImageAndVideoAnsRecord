# publishImageAndVideoAnsRecord

showVideoView* showVideo;

显示添加照片按钮、添加视频按钮、添加语音按钮 布局用Masonry
使用方法
showVideo = [[showVideoView alloc]initWithFrame:CGRectMake(0, contentTextView.frame.origin.y+contentTextView.frame.size.height+5, kScreenWidth, 78)];
[showScrollView addSubview:showVideo];


#import "showVideoView.h"

@property (nonatomic,strong)NSMutableArray* imgeArray;  // 图片数组

@property (nonatomic,strong)KZVideoModel*  videoModel;   // 视频Model

@property (nonatomic,strong)KZVideoPlayer *player;       //视频播放Player

@property (nonatomic,strong)LGMessageModel *messageModel;  //语音录制Model

@property (nonatomic, assign)    BOOL isVideo;            //是否已添加视频
@property (nonatomic, assign)    BOOL isPhoto;            //是否已添加照片
@property (nonatomic, assign)    BOOL isRecord;           //是否已添加语音

@property (nonatomic, strong) UIButton* addImageButton;   //添加照片按钮
@property (nonatomic, strong) UIButton* addVideoButton;   //添加视频按钮
@property (nonatomic, strong) UIButton* addRecordButton;  //添加语音按钮

#import "PlaceholderTextView.h"
使用
contentTextView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(12, lineView.frame.origin.y+lineView.frame.size.height+10, kScreenWidth-24, 114)];
contentTextView.delegate = self;
contentTextView.font = [UIFont systemFontOfSize:14.f];
contentTextView.textColor = [UIColor blackColor];
contentTextView.textAlignment = NSTextAlignmentLeft;
contentTextView.editable = YES;
contentTextView.placeholderColor = [UIColor darkTextColor];
contentTextView.placeholder = @"话说语言和文字不能共存...";
[showScrollView addSubview:contentTextView];
