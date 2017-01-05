//
//  CircleCollectionViewCell.m
//  小莱
//
//  Created by 林颖 on 16/6/13.
//  Copyright © 2016年 李丹阳. All rights reserved.
//

#import "CircleCollectionViewCell.h"
#import "UIView+Size.h"


@implementation CircleCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 52)];
        photo.layer.masksToBounds = YES;
        photo.contentMode = UIViewContentModeScaleAspectFill;
        photo.userInteractionEnabled = YES;
        photo.layer.cornerRadius = 2.5;
        [self addSubview:photo];
        
        deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(70-14-5, 0, 20, 20)];
        deleteBtn.hidden = YES;
        [deleteBtn addTarget:[self getParentviewController] action:@selector(deleteCircleCollectionPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        
        deleteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70-14-2, 2, 14, 14)];
        deleteImageView.image =[UIImage imageNamed:@"delete28"];
        deleteImageView.hidden = YES;
        [self addSubview:deleteImageView];
        
        addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 52)];
        addBtn.hidden = YES;
        [self addSubview:addBtn];
        [addBtn addTarget:[self getParentviewController] action:@selector(chooseTableImageWay:) forControlEvents:UIControlEventTouchUpInside];
        
        videoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 52)];
        
        videoBtn.hidden = YES;
        [self addSubview:videoBtn];
        
        [videoBtn addTarget:[self getParentviewController] action:@selector(addVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}


-(void)setModel:(CircleCellModel *)model{
    _model = model;
    photo.image = model.photoImage;
    if (model.state == CirModelStateAdd) {
        
        addBtn.hidden = NO;
        videoBtn.hidden = YES;
        [deleteBtn removeFromSuperview];
        [deleteImageView removeFromSuperview];
        
    }else if(model.state == CirModelStateVideo){
        
        addBtn.hidden = YES;
        videoBtn.hidden = NO;
        [deleteBtn removeFromSuperview];
        [deleteImageView removeFromSuperview];
        
    }else{
        
        addBtn.hidden = YES;
        videoBtn.hidden = YES;
        [deleteBtn removeFromSuperview];
        [self addSubview:deleteBtn];
        [self addSubview:deleteImageView];
        
    }
}

-(void)setDeleteState:(CirDeleteState)deleteState{
    _deleteState = deleteState;
    if (_deleteState == CirModelStateNormal) {
        deleteBtn.hidden = YES;
        deleteImageView.hidden = YES;
    }else if (_deleteState == CirDeleteBtnStateEditing){
        deleteBtn.hidden = NO;
        deleteImageView.hidden = NO;
    }
}


@end
