//
//  ZZCameraController.m
//  ZZFramework
//
//  Created by Yuan on 15/12/18.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZCameraController.h"
#import "ZZCameraPickerViewController.h"
@interface ZZCameraController()

@property (strong,nonatomic) ZZCameraPickerViewController *cameraPickerController;

@end

@implementation ZZCameraController

-(ZZCameraPickerViewController *)cameraPickerController
{
    if (!_cameraPickerController) {
        _cameraPickerController = [[ZZCameraPickerViewController alloc]init];
    }
    return _cameraPickerController;
}

-(void)showIn:(UIViewController *)controller result:(ZZCameraResult)result
{
    self.cameraPickerController.CameraResult = result;
    //设置连拍最大张数
    self.cameraPickerController.takePhotoOfMax = self.takePhotoOfMax;
    //设置返回图片类型
    self.cameraPickerController.isSavelocal = self.isSaveLocal;
    self.cameraPickerController.LLDthemeColor = self.LLDthemeColor;
    [controller presentViewController:self.cameraPickerController animated:YES completion:nil];
}

@end
