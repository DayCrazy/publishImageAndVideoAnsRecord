# KZWeChatSmallVideo-OC
**仿微信小视频的录制  Objective-C 版**

高仿微信小视频录制, (微信6.3版本)

有两种风格 聊天界面和朋友圈界面

效果图1

![小窗口录视频](https://github.com/houkangzhu/KZWeChatSmallVideo-OC/blob/master/record3.gif)

效果图2

![全屏录视频](https://github.com/houkangzhu/KZWeChatSmallVideo-OC/blob/master/record1.gif)

**cocoapod 地址:**

```
pod 'KZSmallVideoRecorder', '~> 1.0.4'
```

**导入**

```
 #import "KZVideoViewController.h"
```

**调用方法**

```
KZVideoViewController *videoVC = [[KZVideoViewController alloc] init];
videoVC.delegate = self;
[videoVC startAnimationWithType:KZVideoViewShowTypeSmall];
```

**显示风格**

```
KZVideoViewShowTypeSmall,  // 小屏幕 ...聊天界面的
KZVideoViewShowTypeSingle, // 全屏 ... 朋友圈界面的
```
**实现代理方法**

```
- (void)videoViewController:(KZVideoViewController *)videoController didRecordVideo:(KZVideoModel *)videoModel;
```

视频model属性

```
@interface KZVideoModel : NSObject
@property (nonatomic, copy) NSString *videoAbsolutePath;  // 完整视频 本地路径
@property (nonatomic, copy) NSString *thumAbsolutePath;  // 缩略图 路径
@property (nonatomic, assign) NSDate *recordTime; // 录制时间
@end
```
压缩视频, 录制分辨率可配置

在 (宽 : 高=320px) = 4:3  情况下 录制视频 10秒大小 2M左右

全部按钮图片等使用 CALayer 或者Context 绘制

####修改视频分辨率,保存路径等直接改KZVideoConfig.h文件的定义

