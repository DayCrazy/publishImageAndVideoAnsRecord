//
//  CircleCollectionView.m
//  小莱
//
//  Created by 林颖 on 16/5/9.
//  Copyright © 2016年 李丹阳. All rights reserved.
//

#import "CircleCollectionView.h"
#import "ZZPhotoController.h"

#import "CircleCollectionViewCell.h"
#import "CircleCellModel.h"

#import "ZZBrowserPickerViewController.h"

@interface CircleCollectionView ()<ZZBrowserPickerDelegate>{
    
    UIImageView *deleteImageView;
    UIButton *deleteBtn;
    NSMutableArray *deleteImageViewArray;
    NSUInteger _dataSourceNum;
    NSMutableArray* ShowImageArray;
}

@end

@implementation CircleCollectionView

static int deletePhotoTag;

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        deletePhotoTag = 100;
        
        deleteImageViewArray = [NSMutableArray array];
        
        [self registerClass:[CircleCollectionViewCell class] forCellWithReuseIdentifier:@"CircleCollectioniewCell"];
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.photoArray.count >= 9) {
        return 9;
    }
    else{
        return self.photoArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   CircleCollectionViewCell *cell = (CircleCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CircleCollectioniewCell" forIndexPath:indexPath];
   
    while ([cell.contentView.subviews lastObject] != nil) {
        
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    cell.delegate = self;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction)];
    [cell addGestureRecognizer:longPress];
    
    CircleCellModel *model = self.photoArray[indexPath.row];
    
    cell.deleteState = CirModelStateNormal;

    cell.model = model;

    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ZZBrowserPickerViewController *browserController = [[ZZBrowserPickerViewController alloc]init];
    browserController.delegate = self;
    [browserController showIn:[self getParentviewController] animation:ShowAnimationOfPush];
    
    ShowImageArray = [[NSMutableArray alloc]init];
    
    for (CircleCellModel *model  in _photoArray) {
        
        if (model.state == CirModelStateNormal) {
            
            UIImage* image = model.photoImage;
            
            [ShowImageArray addObject:image];
            
        }
    }
}

#pragma mark 🎱 --- ZZBrowserPickerDelegate
-(NSInteger)zzbrowserPickerPhotoNum:(ZZBrowserPickerViewController *)controller
{
    return ShowImageArray.count;
}

-(NSArray *)zzbrowserPickerPhotoContent:(ZZBrowserPickerViewController *)controller
{

    return ShowImageArray;
}





-(void)longPressAction{
//    NSLog(@"长摁");
    NSArray *cellArray = [self visibleCells];
    for (CircleCollectionViewCell *cell in cellArray) {
        cell.deleteState = CirDeleteBtnStateEditing;
    }
}

-(void)deleteCurrentItem:(CircleCollectionViewCell *)item{
    
    NSIndexPath *indexPath = [self indexPathForCell:item];
    
    _dataSourceNum = _photoArray.count;
    [self.photoArray removeObjectAtIndex:indexPath.row];
    [self deleteItemsAtIndexPaths:@[indexPath]];
    
    if (_photoArray.count == 1) {
        
        self.hidden = YES;
    }
    
    [self reloadData];
    
}

- (void)addItemsWithModels:(NSArray<__kindof CircleCellModel *> *)models{
    _dataSourceNum = _photoArray.count;
    for (CircleCellModel *model in models) {
        [_photoArray insertObject:model atIndex:_dataSourceNum-2];
    }
    [self reloadData];
}
@end
