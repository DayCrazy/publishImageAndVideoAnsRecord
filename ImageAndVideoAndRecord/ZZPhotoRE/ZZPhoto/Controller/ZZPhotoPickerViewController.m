//
//  ZZPhotoPickerViewController.m
//  ZZFramework
//
//  Created by Yuan on 15/7/7.
//  Copyright (c) 2015年 zzl. All rights reserved.
//



#import "ZZPhotoPickerViewController.h"
#import "ZZPhotoDatas.h"
#import "ZZPhotoPickerCell.h"
#import "ZZPhotoBrowerViewController.h"
#import "ZZPhotoHud.h"
#import "ZZPhotoAlert.h"
#import "ZZAlumAnimation.h"
#import "ZZPhoto.h"

@interface ZZPhotoPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZZPhotoBrowerDataSource>

@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSMutableArray *selectArray;

@property (strong, nonatomic) UICollectionView *picsCollection;

@property (strong, nonatomic) UIBarButtonItem *backBtn;
@property (strong, nonatomic) UIBarButtonItem *cancelBtn;

@property (strong, nonatomic) UIButton *doneBtn;                       //完成按钮
@property (strong, nonatomic) UIButton *previewBtn;                    //预览按钮

@property (strong, nonatomic) UILabel *totalNumLabel;
@property (strong, nonatomic) UILabel *totalRound;                     //小红点
@property (strong, nonatomic) ZZPhotoDatas *datas;
@property (strong, nonatomic) ZZPhotoBrowerViewController *browserController;
@property (strong, nonatomic) UILabel *numSelectLabel;
@end

@implementation ZZPhotoPickerViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma SETUP backButtonUI Method
- (UIBarButtonItem *)backBtn{
    if (!_backBtn) {

        UIButton *back_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 44)];
        [back_btn setImage:[UIImage imageNamed:@"back_button_normal.png"] forState:UIControlStateNormal];
        [back_btn setImage:[UIImage imageNamed:@"back_button_high.png"] forState:UIControlStateHighlighted];
        back_btn.frame = CGRectMake(0, 0, 45, 44);
        [back_btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

        _backBtn = [[UIBarButtonItem alloc] initWithCustomView:back_btn];
        
    }
    return _backBtn;
}

#pragma SETUP cancelButtonUI Method
- (UIBarButtonItem *)cancelBtn{
    if (!_cancelBtn) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }
    return _cancelBtn;
}

#pragma mark SETUP doneButtonUI Method

-(UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZZ_VW - 60, 0, 50, 44)];
        [_doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    }
    return _doneBtn;
}

#pragma merk SETUP previewButtonUI Method

-(UIButton *)previewBtn{
    if (!_previewBtn) {
        _previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 44)];
        [_previewBtn addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_previewBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_previewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    }
    return _previewBtn;
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 完成然后回调
-(void)done{

    if ([self.selectArray count] == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [ZZPhotoHud showActiveHud];
        __block NSMutableArray<ZZPhoto *> *photos = [NSMutableArray array];
        __unsafe_unretained __typeof(self) weakSelf = self;
        for (int i = 0; i < self.selectArray.count; i++) {
            ZZPhoto *photo = [self.selectArray objectAtIndex:i];
            [self.datas GetImageObject:photo.asset complection:^(UIImage *image,NSURL *imageUrl) {
                
                if (image){
                    ZZPhoto *model = [[ZZPhoto alloc]init];
                    model.asset = photo.asset;
                    model.originImage = image;
                    model.imageUrl = imageUrl;
                    model.createDate = photo.asset.creationDate;
                    [photos addObject:model];
                }
                if (photos.count < weakSelf.selectArray.count){
                    return;
                }
                if (weakSelf.PhotoResult) {
                    weakSelf.PhotoResult(photos);
                }
                
                [ZZPhotoHud hideActiveHud];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
        }
 
    }
}

//预览按钮，弹出图片浏览器
-(void)preview{
    
    if (self.selectArray.count == 0) {
        [self showPhotoPickerAlertView:@"提醒" message:@"您还没有选中图片，不需要预览"];
    }else{
        self.browserController = [[ZZPhotoBrowerViewController alloc]init];
        self.browserController.delegate = self;
        [self.browserController reloadData];
        [self.browserController showIn:self];
    }

}

#pragma Declaration Array
-(NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

-(NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

#pragma mark ---  懒加载图片数据
-(ZZPhotoDatas *)datas{
    if (!_datas) {
        _datas = [[ZZPhotoDatas alloc]init];

    }
    return _datas;
}

#pragma mark ---  总共多少张照片Label

-(UILabel *)totalNumLabel{
    if (!_totalNumLabel) {
        _totalNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ZZ_VW, 20)];
        _totalNumLabel.textColor = [UIColor blackColor];
        _totalNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalNumLabel;
}

#pragma mark ---  红色小圆点
-(UILabel *)totalRound{
    if (!_totalRound) {
        _totalRound = [[UILabel alloc]initWithFrame:CGRectMake(ZZ_VW - 90, 10, 22, 22)];
        if (self.roundColor == nil) {
            _totalRound.backgroundColor = [UIColor redColor];
        }else{
            _totalRound.backgroundColor = self.roundColor;
        }
        _totalRound.layer.masksToBounds = YES;
        _totalRound.textAlignment = NSTextAlignmentCenter;
        _totalRound.textColor = [UIColor whiteColor];
        _totalRound.text = @"0";
        [_totalRound.layer setCornerRadius:CGRectGetHeight([_totalRound bounds]) / 2];
    }
    return _totalRound;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInterUI];
    
    [self loadPhotoData];
    // 更新UI
    [self setupCollectionViewUI];
    //创建底部工具栏
    [self setUpTabbar];
    

}

- (void)initInterUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.backBtn;
    self.navigationItem.rightBarButtonItem = self.cancelBtn;
}

-(void)setUpTabbar
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = ZZ_RGB(245, 245, 245);
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self.doneBtn];
    [view addSubview:self.previewBtn];
    [view addSubview:self.totalRound];
    [self.view addSubview:view];
    NSLayoutConstraint *tab_left = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *tab_right = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *tab_bottom = [NSLayoutConstraint constraintWithItem:_picsCollection attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *tab_height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    
    [self.view addConstraints:@[tab_left,tab_right,tab_bottom,tab_height]];
    
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZZ_VW, 1)];
    viewLine.backgroundColor = ZZ_RGB(230, 230, 230);
    viewLine.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:viewLine];
    
    
}

-(void)setupCollectionViewUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
    flowLayout.minimumInteritemSpacing = 1.0;//item 之间的行的距离
    flowLayout.minimumLineSpacing = 1.0;//item 之间竖的距离
    flowLayout.itemSize = (CGSize){photoSize,photoSize};
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _picsCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_picsCollection registerClass:[ZZPhotoPickerCell class] forCellWithReuseIdentifier:@"PhotoPickerCell"];
    [_picsCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    flowLayout.footerReferenceSize = CGSizeMake(ZZ_VW, 70);
    _picsCollection.delegate = self;
    _picsCollection.dataSource = self;
    _picsCollection.backgroundColor = [UIColor whiteColor];
    [_picsCollection setUserInteractionEnabled:YES];
    _picsCollection.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_picsCollection];
    [_picsCollection reloadData];
    
    
    NSLayoutConstraint *pic_top = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *pic_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeBottom multiplier:1 constant:44.0f];
    
    NSLayoutConstraint *pic_left = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *pic_right = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f];
    
    [self.view addConstraints:@[pic_top,pic_bottom,pic_left,pic_right]];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //滚动到底部
    if (self.photoArray.count != 0) {
        [_picsCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.photoArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}

-(void)loadPhotoData
{
    if (_isAlubSeclect == YES) {
        self.photoArray = [self.datas GetPhotoAssets:_fetch];
        [self refreshTotalNumLabelData:_photoArray.count];

    }else{
        self.navigationItem.title = @"相机胶卷";
        self.photoArray = [self.datas GetPhotoAssets:[self.datas GetCameraRollFetchResul]];
        [self refreshTotalNumLabelData:_photoArray.count];
    }
}

-(void)refreshTotalNumLabelData:(NSInteger)totalNum
{
    self.totalNumLabel.text = [NSString stringWithFormat:Total_Photo_Num,(long)totalNum];
}


#pragma mark 关键位置，选中的在数组中添加，取消的从数组中减少
-(void)selectPhotoAtIndex:(NSInteger)index
{
    ZZPhoto *photo = [self.photoArray objectAtIndex:index];
    
    if (photo != nil) {
        if (photo.isSelect == NO) {
            
            if (self.selectArray.count + 1 > _selectNum) {
                [self showSelectPhotoAlertView:_selectNum];
            }else{
                [[ZZAlumAnimation sharedAnimation] roundAnimation:self.totalRound];
                
                if ([self.datas CheckIsiCloudAsset:photo.asset] == YES) {
                    [[ZZPhotoAlert sharedAlert] showPhotoAlert];
                }else{
                    photo.isSelect = YES;
                    [self changeSelectButtonStateAtIndex:index withPhoto:photo];
                    [self.selectArray insertObject:[self.photoArray objectAtIndex:index] atIndex:self.selectArray.count];
                    self.totalRound.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.selectArray.count];
                }
            }
        }else{
            photo.isSelect = NO;
            [self changeSelectButtonStateAtIndex:index withPhoto:photo];
            [self.selectArray removeObject:[self.photoArray objectAtIndex:index]];
            [[ZZAlumAnimation sharedAnimation] roundAnimation:self.totalRound];
            self.totalRound.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.selectArray.count];
            
        }
    }
    
}

-(void)changeSelectButtonStateAtIndex:(NSInteger)index withPhoto:(ZZPhoto *)photo
{
    ZZPhotoPickerCell *cell = (ZZPhotoPickerCell *)[_picsCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    cell.isSelect = photo.isSelect;
}

#pragma UICollectionView --- Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    ZZPhotoPickerCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPickerCell" forIndexPath:indexPath];
    
    
    photoCell.selectBlock = ^(){
        [self selectPhotoAtIndex:indexPath.row];
    };
    
    [photoCell loadPhotoData:[self.photoArray objectAtIndex:indexPath.row]];
    
    return photoCell;
}
#pragma UICollectionView --- Delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    UICollectionReusableView *footerView = [[UICollectionReusableView alloc]init];
    footerView.backgroundColor = [UIColor redColor];
    if (kind == UICollectionElementKindSectionFooter){
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    }

    [footerView addSubview:self.totalNumLabel];
    return footerView;
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     *   此功能未完成，待后期完善。
     */
//    [self.browserDataArray removeAllObjects];
//    [self.browserDataArray addObjectsFromArray:self.photoArray];
//    self.browserController.indexPath = indexPath;
//    [self.browserController showIn:self animation:ShowAnimationOfPresent];
//    [self.browserController reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 60);
}
#pragma mark --- ZZBrowserPickerDelegate
-(NSInteger)zzbrowserPickerPhotoNum:(ZZPhotoBrowerViewController *)controller
{
    return self.selectArray.count;
}

-(NSArray *)zzbrowserPickerPhotoContent:(ZZPhotoBrowerViewController *)controller
{
    return self.selectArray;
}

-(void)showSelectPhotoAlertView:(NSInteger)photoNumOfMax
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:Alert_Max_Selected,(long)photoNumOfMax]preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showPhotoPickerAlertView:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
