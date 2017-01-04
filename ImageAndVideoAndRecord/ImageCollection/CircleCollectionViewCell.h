//
//  CircleCollectionViewCell.h
//  小莱
//
//  Created by 林颖 on 16/6/13.
//  Copyright © 2016年 李丹阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleCellModel.h"

typedef enum : NSUInteger {
    CirDeleteBtnStateNormal = 0,
    CirDeleteBtnStateEditing = 1,
} CirDeleteState;

@class CircleCollectionViewCell;
@protocol CirCollectionViewCellDelegate <NSObject>

-(void)deleteCurrentItem:(CircleCollectionViewCell *)item;
@end

@interface CircleCollectionViewCell : UICollectionViewCell{
    UIImageView *photo;
    UIButton *deleteBtn;
    UIImageView *deleteImageView;
    UIButton *addBtn;
    UIButton *videoBtn;
}

@property (nonatomic, assign) id<CirCollectionViewCellDelegate> delegate;

@property (nonatomic)CirDeleteState deleteState;
@property (nonatomic,strong)CircleCellModel *model;

@end
