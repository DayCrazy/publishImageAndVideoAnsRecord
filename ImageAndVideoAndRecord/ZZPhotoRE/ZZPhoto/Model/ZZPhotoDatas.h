//
//  ZZPhotoDatas.h
//  ZZFramework
//
//  Created by Yuan on 15/12/17.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZResourceConfig.h"
@interface ZZPhotoDatas : NSObject


/*
 *    获取全部相册
 */
-(NSMutableArray *) GetPhotoListDatas;
/*
 *    获取某一个相册的结果集
 */
-(PHFetchResult *) GetFetchResult:(PHAssetCollection *)collection;
/*
 *    获取图片实体，并把图片结果存放到数组中，返回值数组
 */
-(NSMutableArray *) GetPhotoAssets:(PHFetchResult *)fetchResult;
/*
 *    只获取相机胶卷结果集
 */
-(PHFetchResult *) GetCameraRollFetchResul;

/*
 *    回调方法使用数组
 */
-(void) GetImageObject:(id)asset complection:(void (^)(UIImage *,NSURL *))complection;

/*
 *    检测是否为iCloud资源
 */
-(BOOL) CheckIsiCloudAsset:(PHAsset *)asset;
@end
