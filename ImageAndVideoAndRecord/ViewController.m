//
//  ViewController.m
//  ImageAndVideoAndRecord
//
//  Created by 李丹阳 on 2017/1/4.
//  Copyright © 2017年 李丹阳. All rights reserved.
//

#import "ViewController.h"
#import "showVideoView.h"
#import "PlaceholderTextView.h"
#import "ZZPhoto.h"
#import "ZZCamera.h"
#import "MBProgressHUD+MJ.h"

#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextViewDelegate>{
    
    UIScrollView* showScrollView;
    PlaceholderTextView* titleTexView;
    PlaceholderTextView* contentTextView;
    showVideoView* showVideo;
}

@property (nonatomic, copy) NSMutableArray* imageUrlArray;



@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationItem];
    
    [self addSubViews];
    // Do any additional setup after loading the view.
}

- (void)setNavigationItem{
    
    self.title = @"发布";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(deletePublishButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finishPublishButtonAction:)];
    
}


- (void)addSubViews{
    
    showScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-100)];
    showScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    showScrollView.showsVerticalScrollIndicator = NO;
    showScrollView.keyboardDismissMode = YES;
    [self.view addSubview:showScrollView];
    
    
    titleTexView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(12, 10, kScreenWidth-24, 35)];
    titleTexView.delegate = self;
    titleTexView.font = [UIFont systemFontOfSize:15.f];
    titleTexView.textColor = [UIColor blackColor];
    titleTexView.textAlignment = NSTextAlignmentLeft;
    titleTexView.editable = YES;
    titleTexView.placeholderColor = [UIColor darkTextColor];
    titleTexView.placeholder = @"标题（必填）";
    [showScrollView addSubview:titleTexView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(12, titleTexView.frame.origin.y+titleTexView.frame.size.height+10, kScreenWidth-12, 0.5)];
    lineView.backgroundColor = [UIColor darkTextColor];
    [showScrollView addSubview:lineView];
    
    contentTextView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(12, lineView.frame.origin.y+lineView.frame.size.height+10, kScreenWidth-24, 114)];
    contentTextView.delegate = self;
    contentTextView.font = [UIFont systemFontOfSize:14.f];
    contentTextView.textColor = [UIColor blackColor];
    contentTextView.textAlignment = NSTextAlignmentLeft;
    contentTextView.editable = YES;
    contentTextView.placeholderColor = [UIColor darkTextColor];
    contentTextView.placeholder = @"话说语言和文字不能共存...";
    [showScrollView addSubview:contentTextView];
    
    showVideo = [[showVideoView alloc]initWithFrame:CGRectMake(0, contentTextView.frame.origin.y+contentTextView.frame.size.height+5, kScreenWidth, 78)];
    [showScrollView addSubview:showVideo];
    
    if (_imageUrlArray == nil) {
        
        _imageUrlArray = [[NSMutableArray alloc]init];
        
    }
    
}

#pragma mark 🎱 点击发布按钮

- (void)finishPublishButtonAction:(UIButton*)sender{
    
    
    [MBProgressHUD showMessage:@"上传中..." toView:self.view];
    
    if (_imageUrlArray == nil) {
        
        _imageUrlArray = [[NSMutableArray alloc]init];
        
    }
    
    if ([self collectModelInformation]) {
        
        // 上传数据
        
    }
    
    
    
}

#pragma mark 🎱 退出发布界面按钮

- (void)deletePublishButtonAction:(UIButton *)btn{
    
    if (showVideo.player) {
        
        [showVideo.player stop];
    }
    
    [showVideo.player removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 🎱 发布前检查数据

- (BOOL)collectModelInformation{
    
    if (titleTexView.text.length == 0) {
        
        [MBProgressHUD showError:@"请填写标题"];
        
        return  NO;
        
    }else if (contentTextView.text.length == 0){
        
        [MBProgressHUD showError:@"请填写商品价格"];
        
        return NO;
        
    }else if (showVideo.imgeArray.count == 0 ){
        
        [MBProgressHUD showError:@"请至少上传一张照片"];
        
        return NO;
        
    }else{
        
        
        //处理准备上传照片
        for (int i = 0; i< showVideo.imgeArray.count; i++) {
            
            UIImage* image;
            
            NSString* fileName;
            
            NSString* name;
            
            if ([showVideo.imgeArray[i] isKindOfClass:[ZZPhoto class]]) {
                
                ZZPhoto* model = showVideo.imgeArray[i];
                
                image = model.originImage;
                
                NSDateFormatter* dateFor = [[NSDateFormatter alloc]init];
                dateFor.dateFormat = @"yyyyMMddHHmmssSSS";
                
                fileName = [NSString stringWithFormat:@"%@.jpg",[dateFor stringFromDate:model.createDate]];
                
            }else if([showVideo.imgeArray[i] isKindOfClass:[ZZCamera class]]){
                
                ZZCamera* model = showVideo.imgeArray[i];
                
                image = model.image;
                
                NSDateFormatter* dateFor = [[NSDateFormatter alloc]init];
                dateFor.dateFormat = @"yyyyMMddHHmmssSSS";
                
                fileName = [NSString stringWithFormat:@"%@.jpg",[dateFor stringFromDate:model.createDate]];
                
            }else{
                
                UIImage* tempImage = showVideo.imgeArray[i];
                
                image = tempImage;
                
                fileName = [NSString stringWithFormat:@"goodsImageFielName%d.jpg",i];
                
            }
            
            name = [NSString stringWithFormat:@"GoodsImage%d.jpg",i];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.7);
            
            NSDictionary* dic = @{@"fileData":imageData,@"name":name,@"fileName":fileName,@"mimeType":@"image/jpg"};
            [_imageUrlArray addObject:dic];
            
        }
        
        if(showVideo.videoModel){
            
            //处理准备上传视频
            NSURL* url = [NSURL fileURLWithPath:showVideo.videoModel.videoAbsolutePath];
            NSData* videoData = [NSData dataWithContentsOfURL:url];
            
            if (videoData) {
                
                NSDictionary* dic = @{@"fileData":videoData,@"name":@"GoodsVideo",@"fileName":@"GoodsVideo.mp4",@"mimeType":@"video/mp4"};
                [_imageUrlArray addObject:dic];
            }
        }
        
        
        return YES;
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([textView isEqual:contentTextView]) {
        
        if (showVideo.addRecordButton.hidden) {
            
            
            return NO;
        }else{
            return YES;
        }
    }else{
        
        return YES;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView isEqual:titleTexView]) {
        
        if (textView.text.length > 20){
            // 删除
            textView.text = [textView.text substringToIndex:20];
            [MBProgressHUD showError:@"最多输入20个字符"];
        }
    }else if ([textView isEqual:contentTextView]){
        
        if (textView.text.length>0) {
            
            [showVideo.addRecordButton setImage:[UIImage imageNamed:@"second_sounding_s"] forState:UIControlStateNormal];
            
            if (textView.text.length > 140){
                // 删除
                textView.text = [textView.text substringToIndex:140];
                [MBProgressHUD showError:@"最多输入140个字符"];
                
            }
        }
        
        
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
