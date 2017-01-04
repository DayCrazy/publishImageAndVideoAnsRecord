//
//  ZZPhotoBrowerViewController.m
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/27.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "ZZPhotoBrowerViewController.h"
#import "ZZBrowserPickerCell.h"
#import "ZZPageControl.h"
#import "ZZPhoto.h"


@interface ZZPhotoBrowerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *picBrowse;

@property (nonatomic, strong) NSMutableArray *photoDataArray;

@property (nonatomic, strong) ZZPageControl *pageControl;

//照片的总数
@property (nonatomic, assign) NSInteger numberOfItems;

@end

@implementation ZZPhotoBrowerViewController

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
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = (CGSize){self.view.frame.size.width,self.view.frame.size.height-64};
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
    
    NSLayoutConstraint *list_top = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_bottom = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_left = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_right = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f];
    
    [self.view addConstraints:@[list_top,list_bottom,list_left,list_right]];
    
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
    
    _pageControl.pageControl.text = [NSString stringWithFormat:@"%d / %ld",1,(long)_numberOfItems];
    
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
    
    _pageControl.pageControl.text = [NSString stringWithFormat:@"%d / %ld",1,(long)_numberOfItems];
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
    }

    return cell;
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
    [controller.navigationController pushViewController:self animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
