//
//  ZZCameraBrowerViewController.m
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/27.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "ZZCameraBrowerViewController.h"
#import "ZZBrowserPickerCell.h"
#import "ZZPageControl.h"
#import "ZZCamera.h"

@interface ZZCameraBrowerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *picBrowse;

@property (nonatomic, strong) NSMutableArray *photoDataArray;

@property (nonatomic, strong) ZZPageControl *pageControl;

//照片的总数
@property (nonatomic, assign) NSInteger numberOfItems;

@end

@implementation ZZCameraBrowerViewController


-(void)setupCollectionViewUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /*
     *   创建核心内容 UICollectionView
     */
    self.view.backgroundColor = [UIColor blackColor];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = (CGSize){self.view.frame.size.width,self.view.frame.size.height};
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _picBrowse = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _picBrowse.backgroundColor = [UIColor clearColor];
    _picBrowse.pagingEnabled = YES;
    
    _picBrowse.showsHorizontalScrollIndicator = NO;
    _picBrowse.showsVerticalScrollIndicator = NO;
    [_picBrowse registerClass:[ZZBrowserPickerCell class] forCellWithReuseIdentifier:@"Cell"];
    _picBrowse.dataSource = self;
    _picBrowse.delegate = self;
    _picBrowse.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self.view addSubview:_picBrowse];
    
    NSLayoutConstraint *list_top = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_picBrowse attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_picBrowse attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_left = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_picBrowse attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_right = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_picBrowse attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f];
    
    [self.view addConstraints:@[list_top,list_bottom,list_left,list_right]];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.indexPath != nil) {
        [_picBrowse scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

-(void)setPageControlUI
{
    /*
     *   创建底部PageControl（自定义）
     */
    _pageControl = [[ZZPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 30)];
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.pageControl.textColor = [UIColor whiteColor];
    [self.view addSubview:_pageControl];
    
    //照片总数通过delegate获取
    _numberOfItems = [self.delegate zzbrowserPickerPhotoNum:self];
    
    //判断是否需要滚动到指定图片
    if (self.indexPath != nil) {
        _pageControl.pageControl.text = [NSString stringWithFormat:@"%ld / %ld",(long)self.indexPath.row + 1,(long)_numberOfItems];
    }else{
        _pageControl.pageControl.text = [NSString stringWithFormat:@"%d / %ld",1,(long)_numberOfItems];
    }
    
}

-(NSMutableArray *)photoDataArray{
    if (!_photoDataArray) {
        _photoDataArray = [NSMutableArray array];
    }
    return _photoDataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCollectionViewUI];
    
    [self setPageControlUI];
    
    [self loadPhotoData];
    
    if ([self.delegate respondsToSelector:@selector(zzbrowserPickerPhotoContent:)]) {
        [self.photoDataArray addObjectsFromArray:[self.delegate zzbrowserPickerPhotoContent:self]];
    }
}

-(void)loadPhotoData
{
    if ([self.delegate respondsToSelector:@selector(zzbrowserPickerPhotoContent:)]) {
        [self.photoDataArray addObjectsFromArray:[self.delegate zzbrowserPickerPhotoContent:self]];
    }
}

/*
 *   更新数据刷新方法
 */

-(void)reloadData
{
    
    [_picBrowse reloadData];
    //照片总数通过delegate获取
    if ([self.delegate respondsToSelector:@selector(zzbrowserPickerPhotoNum:)]) {
        _numberOfItems = [self.delegate zzbrowserPickerPhotoNum:self];
    }
    
    //判断是否需要滚动到指定图片
    if (self.indexPath != nil) {
        _pageControl.pageControl.text = [NSString stringWithFormat:@"%ld / %ld",(long)self.indexPath.row + 1,(long)_numberOfItems];
    }else{
        _pageControl.pageControl.text = [NSString stringWithFormat:@"%d / %ld",1,(long)_numberOfItems];
    }
}

#pragma mark --- UICollectionviewDelegate or dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.delegate zzbrowserPickerPhotoNum:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZBrowserPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ZZBrowserPickerCell alloc]init];
    }
    
    if ([[_photoDataArray objectAtIndex:indexPath.row] isKindOfClass:[ZZCamera class]]){
        
        ZZCamera *photo = [_photoDataArray objectAtIndex:indexPath.row];
        cell.pics.image = photo.image;
    }
    
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)index
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int itemIndex = (scrollView.contentOffset.x + self.picBrowse.frame.size.width * 0.5) / self.picBrowse.frame.size.width;
    if (!self.numberOfItems) return;
    int indexOnPageControl = itemIndex % self.numberOfItems;
    
    _pageControl.pageControl.text = [NSString stringWithFormat:@"%d / %ld",indexOnPageControl+1,(long)_numberOfItems];
    self.pageControl.currentPage = indexOnPageControl;
    
}



-(void)showIn:(UIViewController *)controller
{
    [controller presentViewController:self animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
