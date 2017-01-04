//
//  ZZPhotoController.m
//  ZZFramework
//
//  Created by Yuan on 15/12/16.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZPhotoController.h"
#import "ZZPhotoListViewController.h"
#import "ZZPhotoPickerViewController.h"

@interface ZZPhotoController()

@property(strong,nonatomic) ZZPhotoListViewController *photoListController;
@property(strong,nonatomic) UINavigationController *photoListNavigationController;
@property(strong,nonatomic) ZZPhotoPickerViewController *photoPickerController;

@end

@implementation ZZPhotoController

#pragma mark ---- 懒加载控制器
-(ZZPhotoListViewController *)photoListController{
    if (!_photoListController) {
        _photoListController = [[ZZPhotoListViewController alloc]init];
    }
    return _photoListController;
}

-(UINavigationController *)photoListNavigationController{
    if (!_photoListNavigationController) {
        _photoListNavigationController = [[UINavigationController alloc]initWithRootViewController:self.photoListController];
    }
    [_photoListNavigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    return _photoListNavigationController;
}

-(ZZPhotoPickerViewController *)photoPickerController{
    if (!_photoPickerController) {
        _photoPickerController = [[ZZPhotoPickerViewController alloc]init];
    }
    return _photoPickerController;
}


#pragma mark ---- 弹出控制器
-(void)showIn:(UIViewController *)controller result:(ZZPhotoResult)result{
    
    //相册权限判断
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        //相册权限未开启
        [self showAlertViewToController:controller];
        
    }else if(status == PHAuthorizationStatusNotDetermined){
        //相册进行授权
        /* * * 第一次安装应用时直接进行这个判断进行授权 * * */
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            //授权后直接打开照片库
            if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showController:controller result:result];
                });
 
            }
        }];
    }else if (status == PHAuthorizationStatusAuthorized){
        [self showController:controller result:result];
    }

}

-(void)showController:(UIViewController *)controller result:(ZZPhotoResult)result
{
    //授权完成，打开相册
    
    //Block传值
    self.photoListController.photoResult = result;
    //先向presentViewController控制器ZZPhotoListViewController，此控制器为全部相册控制器
    
    /* * *   同时设定最多选择照片的张数  * * */
    self.photoListController.selectNum = _selectPhotoOfMax;
    
    [self showPhotoList:controller];
    
    
    //Block传值
    self.photoPickerController.PhotoResult = result;
    self.photoPickerController.isAlubSeclect = NO;
    self.photoPickerController.roundColor = self.roundColor;
    /* * *   同时设定最多选择照片的张数  * * */
    self.photoPickerController.selectNum = _selectPhotoOfMax;
    
    //然后再执行pushViewController控制器ZZPhotoPickerViewController
    //此控制器为详情相册，显示某个相册中的详细照片
    [self showPhotoPicker:self.photoListController.navigationController];
}



-(void)showPhotoList:(UIViewController *)controller
{
    [controller presentViewController:self.photoListNavigationController animated:YES completion:nil];
}

-(void)showPhotoPicker:(UINavigationController *)navigationController
{
    //此处注意Animated == NO，关闭动画效果。则直接进入了详细页面。
    [navigationController pushViewController:self.photoPickerController animated:NO];
}

-(void)showAlertViewToController:(UIViewController *)controller
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的手机相册",app_Name] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
