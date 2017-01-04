//
//  ZZPhotoDatas.m
//  ZZFramework
//
//  Created by Yuan on 15/12/17.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZPhotoDatas.h"
#import "ZZPhotoListModel.h"
#import "ZZPhoto.h"
@implementation ZZPhotoDatas

-(NSMutableArray *)GetPhotoListDatas
{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
    //遍历相机胶卷
    [smartAlbumsFetchResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {

        if (![collection.localizedTitle isEqualToString:@"Videos"]) {
            NSArray<PHAsset *> *assets = [self GetAssetsInAssetCollection:collection];
            ZZPhotoListModel *listModel = [[ZZPhotoListModel alloc]init];
            listModel.count = assets.count;
            listModel.title = [self FormatPhotoAlumTitle:collection.localizedTitle];
            listModel.lastObject = assets.lastObject;
            listModel.assetCollection = collection;
            [dataArray addObject:listModel];
        }
    }];
    //遍历自定义相册
    PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:fetchOptions];
    [smartAlbumsFetchResult1 enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {

        NSArray<PHAsset *> *assets = [self GetAssetsInAssetCollection:collection];
        ZZPhotoListModel *listModel = [[ZZPhotoListModel alloc]init];
        listModel.count = assets.count;
        listModel.title = collection.localizedTitle;
        listModel.lastObject = assets.lastObject;
        listModel.assetCollection = collection;
        [dataArray addObject:listModel];
    }];
    
    return dataArray;
}
-(NSString *) FormatPhotoAlumTitle:(NSString *)title
{
    if ([title isEqualToString:@"All Photos"] || [title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }
    return nil;
}

- (NSArray *)GetAssetsInAssetCollection:(PHAssetCollection *)assetCollection
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [self GetFetchResult:assetCollection];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [arr addObject:obj];
        }
    }];
    return arr;
}

-(PHFetchResult *)GetFetchResult:(PHAssetCollection *)assetCollection
{
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    return fetchResult;
    
}

-(NSMutableArray *)GetPhotoAssets:(PHFetchResult *)fetchResult
{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult) {
        //只添加图片类型资源，过滤除视频类型资源
        if (asset.mediaType == PHAssetMediaTypeImage) {
            ZZPhoto *photo = [[ZZPhoto alloc]init];
            photo.asset = asset;
            [dataArray addObject:photo];
        }
        
    }
    
    return dataArray;
}

-(PHFetchResult *)GetCameraRollFetchResul
{
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
    
    
    PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:[smartAlbumsFetchResult objectAtIndex:0] options:nil];
    return fetch;
}

-(void) GetImageObject:(id)asset complection:(void (^)(UIImage *,NSURL *))complection
{
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        
        CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            
            //设置BOOL判断，确定返回高清照片
            if (downloadFinined) {
                NSURL *imageUrl = (NSURL *)[info objectForKey:@"PHImageFileURLKey"];
                complection(result,imageUrl);
                
            }
 
        }];

    }
    
}

-(BOOL) CheckIsiCloudAsset:(PHAsset *)asset
{
    CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat aspectRatio = asset.pixelWidth / (CGFloat)asset.pixelHeight;
    CGFloat multiple = [UIScreen mainScreen].scale;
    CGFloat pixelWidth = photoWidth * multiple;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = YES;
    __block BOOL isICloudAsset = NO;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        if([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
            isICloudAsset = YES;
        }
    }];
    
    return isICloudAsset;
}
@end
