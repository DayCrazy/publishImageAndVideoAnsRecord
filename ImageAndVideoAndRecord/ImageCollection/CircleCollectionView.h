//
//  CircleCollectionView.h
//  小莱
//
//  Created by 林颖 on 16/5/9.
//  Copyright © 2016年 李丹阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleCellModel.h"
#import "CircleCollectionViewCell.h"

@protocol CirCollectionViewDelegate <NSObject>

@required

@optional

-(void)addDataSourceItem;


@end


@interface CircleCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CirCollectionViewCellDelegate>

@property(strong,nonatomic) NSMutableArray *photoArray;
@property(strong,nonatomic) NSMutableArray *modelArray;


-(void)addItemsWithModels:(NSArray <__kindof CircleCellModel *> *)models;
@end
