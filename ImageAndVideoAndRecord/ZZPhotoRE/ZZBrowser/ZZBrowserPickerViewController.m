//
//  ZZBrowserPickerViewController.m
//  ZZFramework
//
//  Created by Yuan on 15/12/23.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZBrowserPickerViewController.h"
#import "ZZBrowserPickerCell.h"
#import "ZZPageControl.h"
#import "ZZPhoto.h"
#import "ZZCamera.h"

@interface ZZBrowserPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UICollectionView *picBrowse;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *photoDataArray;

@property (nonatomic, strong) ZZPageControl *pageControl;

//照片的总数
@property (nonatomic, assign) NSInteger numberOfItems;

@end

@implementation ZZBrowserPickerViewController

-(void)setupBackItemUI
{
    UIButton *back_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 44)];
    [back_btn setImage:[UIImage imageNamed:@"back_button_normal.png"] forState:UIControlStateNormal];
    [back_btn setImage:[UIImage imageNamed:@"back_button_high.png"] forState:UIControlStateHighlighted];
    back_btn.frame = CGRectMake(0, 0, 45, 44);
    [back_btn addTarget:self action:@selector(backItemMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:back_btn];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)backItemMethod
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setupCollectionViewUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /*
     *   创建核心内容 UICollectionView
     */
    self.view.backgroundColor = [UIColor blackColor];
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.itemSize = (CGSize){self.view.frame.size.width,self.view.frame.size.height};
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _picBrowse = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _picBrowse.backgroundColor = [UIColor clearColor];
    _picBrowse.pagingEnabled = YES;

    _picBrowse.showsHorizontalScrollIndicator = NO;
    _picBrowse.showsVerticalScrollIndicator = NO;
    [_picBrowse registerClass:[ZZBrowserPickerCell class] forCellWithReuseIdentifier:@"Cell"];
    _picBrowse.dataSource = self;
    _picBrowse.delegate = self;
    _picBrowse.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self.view addSubview:_picBrowse];
    
    NSLayoutConstraint *list_top = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_picBrowse attribute:NSLayoutAttributeTop multiplier:1 constant:64.0f];
    
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
    _pageControl = [[ZZPageControl alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.pageControl.textColor = [UIColor whiteColor];
//    [self.navigationItem.titleView addSubview:_pageControl];
    self.navigationItem.titleView = _pageControl;
    
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
    
    [self setupBackItemUI];
    
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

    if ([[_photoDataArray objectAtIndex:indexPath.row] isKindOfClass:[ZZPhoto class]]) {
        //加载相册中的数据时实用
        ZZPhoto *photo = [_photoDataArray objectAtIndex:indexPath.row];
        [cell loadPHAssetItemForPics:photo.asset];
    }else if ([[_photoDataArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        //加载网络中的图片数据，图片地址使用
        [cell.pics sd_setImageWithURL:[NSURL URLWithString:[_photoDataArray objectAtIndex:indexPath.row]]];
    
    }else if ([[_photoDataArray objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]){
        //加载 UIImage 类型的数据
        cell.pics.image = [_photoDataArray objectAtIndex:indexPath.row];
    }else if ([[_photoDataArray objectAtIndex:indexPath.row] isKindOfClass:[ZZCamera class]]){
        
        ZZCamera *photo = [_photoDataArray objectAtIndex:indexPath.row];
        cell.pics.image = photo.image;
    }
    
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)index
{
    if (self.showAnimation == ShowAnimationOfPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int itemIndex = (scrollView.contentOffset.x + self.picBrowse.frame.size.width * 0.5) / self.picBrowse.frame.size.width;
    if (!self.numberOfItems) return;
    int indexOnPageControl = itemIndex % self.numberOfItems;
    
    _pageControl.pageControl.text = [NSString stringWithFormat:@"%d / %ld",indexOnPageControl+1,(long)_numberOfItems];
    self.pageControl.currentPage = indexOnPageControl;
    
}

-(void)showIn:(UIViewController *)controller animation:(ShowAnimation)animation
{
    if (animation == ShowAnimationOfPush) {
        
        if (_isOpenAnimation == NO) {
            [controller.navigationController pushViewController:self animated:YES];
        }else{
            controller.navigationController.delegate = self;
            
            [controller.navigationController pushViewController:self animated:YES];
        }
        
    }else if (animation == ShowAnimationOfPresent){
        if (_isOpenAnimation == NO) {
            self.showAnimation = ShowAnimationOfPresent;
            [controller presentViewController:self animated:YES completion:nil];
        }else{
            self.showAnimation = ShowAnimationOfPresent;
            //设置动画效果
            self.transitioningDelegate = self;

            
            [controller presentViewController:self animated:YES completion:nil];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
