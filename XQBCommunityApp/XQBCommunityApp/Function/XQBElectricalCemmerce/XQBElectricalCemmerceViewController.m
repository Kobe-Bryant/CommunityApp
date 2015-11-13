//
//  XQBElectricalCemmerceViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBElectricalCemmerceViewController.h"
#import "Global.h"
#import "ECProductListViewLayout.h"
#import "ECPLVGeneralGoodsCVCell.h"
#import "ECPLVSpecialtyGoodsCVCell.h"
#import "ECPLVHeaderRushBuyReusableView.h"
#import "ECPLVHeaderLimitedBuyReusableView.h"
#import "ECPLVHeaderSpaceReusableView.h"
#import "CycleScrollView.h"
#import "XQBECProductDetailViewController.h"
#import "UILabel+DiscountShow.h"
#import "PricesShown.h"
#import "NSObject+Time.h"
#import "XQBECShoppingCartViewController.h"
#import "ECProductModel.h"
#import "AdModel.h"
#import "UIView+CustomBadge.h"
#import "XQBLginViewController.h"
#import "ECPopMenuItem.h"
#import "MallPopListViewController.h"
#import "WEPopoverController.h"
#import "XQBMeMyOrderViewController.h"
#import "XQBECShippingAddressViewController.h"
#import "BlankPageView.h"
#import "AMTumblrHudRefreshTopView.h"
#import "XQBLoginNavigationController.h"

static const CGFloat kGeneralItemHight      = 198.0f;
static const CGFloat kSpecialtyItemHight    = 110.0f;
static const CGFloat kHeaderSpaceHight      = 15.0f;
static const CGFloat kHeaderAdHight         = 150.0f;
static const CGFloat kHeaderItemHight       = 35.0f;


@interface XQBElectricalCemmerceViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RefreshControlDelegate, WEPopoverControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CycleScrollView *headerAdsView;
@property (nonatomic, strong) UIButton *shoppingCartButton;

@property (nonatomic, strong) UIView *bottomBackgroundView;

@property (nonatomic, strong) NSMutableArray *headerAdsArray;
@property (nonatomic, strong) NSMutableArray *adsViewArray;

@property (nonatomic, strong) NSMutableArray *allProductsArray;

@property (nonatomic, strong) RefreshControl *refreshControl;

@property (nonatomic, strong) XQBLoginNavigationController *loginNavViewController;

@property (nonatomic, strong) WEPopoverController *mallPopoverController;

@property (nonatomic, strong) BlankPageView *blankPageView;

@end


@implementation XQBElectricalCemmerceViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_loginNavViewController removeFromParentViewController];
    [_headerAdsView pauserTimer];
    
    for (UIView *tempView in _collectionView.subviews) {
        if ([[NSString stringWithFormat:@"%@", [tempView class]] isEqualToString:@"ECPLVHeaderRushBuyReusableView"]) {
            ECPLVHeaderRushBuyReusableView *headerView = (ECPLVHeaderRushBuyReusableView *)tempView;
            [headerView.countTimer free];
        }
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _hiddenBackBarItem = YES;
        _headerAdsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _allProductsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _adsViewArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        
        
        _loginNavViewController = [[XQBLoginNavigationController alloc] init];
        [self.navigationController addChildViewController:_loginNavViewController];
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucceedNotice:) name:kXQBLoginSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCertificationSucceedNotice:) name:kXQBUserCertificationSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutSucceedNotice:) name:kXQBLogoutSucceedNotification object:nil];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"闪购"];
    
    UIButton *mallMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mallMoreButton addTarget:self action:@selector(popMallMoreView:) forControlEvents:UIControlEventTouchUpInside];
    mallMoreButton.frame = CGRectMake(0, 0, 30, 30);
    [mallMoreButton setImage:[UIImage imageNamed:@"shoppingmall_more_green.png"] forState:UIControlStateNormal];
    [self setRightBarButtonItems:@[mallMoreButton, self.shoppingCartButton]];
    
    
    if (!_hiddenBackBarItem) {
        //自定义返回按钮
        UIButton *backButton = [self setBackBarButton];
        [backButton setExclusiveTouch:YES];
        [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self setBackBarButtonItem:backButton];
    }
    
    [self.view addSubview:self.collectionView];
    
    ///初始化
    _refreshControl=[[RefreshControl alloc] initWithScrollView:self.collectionView delegate:self];
    _refreshControl.autoRefreshTop = YES;
    ///注册自定义的下拉刷新view
    [_refreshControl registerClassForTopView:[AMTumblrHudRefreshTopView class]];
    ///设置显示下拉刷新
    _refreshControl.topEnabled=YES;
    
    [self requestEcHomePage];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestCartsItemCount];
}

#pragma mark --- UI
- (UIButton *)shoppingCartButton{
    if (_shoppingCartButton == nil) {
        _shoppingCartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_shoppingCartButton setImage:[UIImage imageNamed:@"shoppingmall_cart"] forState:UIControlStateNormal];
        [_shoppingCartButton addTarget:self action:@selector(entryShoppingCartVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shoppingCartButton;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        ECProductListViewLayout* lineLayout = [[ECProductListViewLayout alloc] init];
        if (!_hiddenBackBarItem) {
            
        }
        CGRect rect = CGRectMake(0, 0, MainWidth, MainHeight-TABBAR_HEIGHT);
        if (!_hiddenBackBarItem) {
            rect = CGRectMake(0, 0, MainWidth, MainHeight);
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:lineLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.backgroundView = self.bottomBackgroundView;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.contentSize = CGSizeMake(MainWidth, MainHeight+10);
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[ECPLVGeneralGoodsCVCell class] forCellWithReuseIdentifier:@"GENERAL_GOODS_CELL"];
        [_collectionView registerClass:[ECPLVSpecialtyGoodsCVCell class] forCellWithReuseIdentifier:@"SPECIALTY_GOODS_CELL"];
        [_collectionView registerClass:[ECPLVHeaderRushBuyReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RUSH_BUY_VIEW"];
        [_collectionView registerClass:[ECPLVHeaderLimitedBuyReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LIMITED_BUY_VIEW"];
        [_collectionView registerClass:[ECPLVHeaderSpaceReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SPACE_VIEW"];
    }
    return _collectionView;
}

- (CycleScrollView *)headerAdsView
{
    if (!_headerAdsView) {
        _headerAdsView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, kHeaderAdHight) animationDuration:3.0];
    }
    
    return _headerAdsView;
}

- (UIView *)bottomBackgroundView
{
    if (!_bottomBackgroundView) {
        _bottomBackgroundView = [[UIView alloc] initWithFrame:_collectionView.frame];
        _bottomBackgroundView.backgroundColor = XQBColorBackground;
        UIImage *image = [UIImage imageNamed:@"bottom_background.png"];
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(_bottomBackgroundView)/2 - image.size.width/2, HEIGHT(_bottomBackgroundView)-image.size.height-10, image.size.width, image.size.height)];
        bottomImageView.image = image;
        [_bottomBackgroundView addSubview:bottomImageView];
    }
    return _bottomBackgroundView;
}

- (void)refreshAds
{
    [_adsViewArray removeAllObjects];
    
    for (AdModel *tmpAdModel in self.headerAdsArray) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, kHeaderAdHight)];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:tmpAdModel.imageUrl] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:imageView.frame.size]];
        [_adsViewArray addObject:imageView];
    }
    
    __weak typeof(self) weakSelf = self;
    _headerAdsView.totalPagesCount = ^NSInteger(void){
        return weakSelf.adsViewArray.count;
    };
    _headerAdsView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return weakSelf.adsViewArray[pageIndex];
    };
    _headerAdsView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",pageIndex);
        AdModel *adModel = weakSelf.headerAdsArray.count > pageIndex ? [weakSelf.headerAdsArray objectAtIndex:pageIndex] : nil;
        XQBECProductDetailViewController *productDetailVC = [[XQBECProductDetailViewController alloc] init];
        productDetailVC.productId = adModel.productId;
        productDetailVC.productIamgeUrl = adModel.imageUrl;
        productDetailVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:productDetailVC animated:YES];
    };
}

//空白界面
- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        __weak typeof(self) weakself = self;
        _blankPageView.blankPageDidClickedBlock = ^(){
            [weakself requestEcHomePage];
        };
    }
    return _blankPageView;
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender{
    if (!_hiddenBackBarItem) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)entryShoppingCartVC:(UIButton *)sender{
    if (![UserModel isLogin]) { //未登录弹出登录页面
       [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
        return;
    }
    XQBECShoppingCartViewController *shoppingCart = [[XQBECShoppingCartViewController alloc] init];
    shoppingCart.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingCart animated:YES];
}

- (void)popMallMoreView:(UIButton *)sender{
    if (!self.mallPopoverController) {
        
        NSMutableArray *items = [NSMutableArray array];
        NSArray *itemTitles = [NSArray arrayWithObjects:@"闪购订单",@"收货地址", nil];
        for (int i = 0; i < [itemTitles count]; i++) {
            ECPopMenuItem *item = [[ECPopMenuItem alloc] init];
            item.title = [itemTitles objectAtIndex:i];
            [items addObject:item];
        }
        
        MallPopListViewController *contentViewController = [[MallPopListViewController alloc] initWithMenuItems:items];
        self.mallPopoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.mallPopoverController.delegate = self;
        self.mallPopoverController.passthroughViews = nil;//[NSArray arrayWithObject:self.view];
        
        [self.mallPopoverController presentPopoverFromRect:CGRectMake(sender.frame.origin.x+30,sender.frame.origin.y, sender.frame.size.width+30, sender.frame.size.height+11)
                                                    inView:self.navigationController.view
                                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                                  animated:YES];
        
        contentViewController.popMenuDidSlectedCompled = ^(NSInteger index){
            switch (index) {
                case 0:
                {
                    [self.mallPopoverController dismissPopoverAnimated:YES];
                    self.mallPopoverController.delegate = nil;
                    self.mallPopoverController = nil;
                    if (![UserModel isLogin]) { //未登录弹出登录页面
                        [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
                        
                        return;
                    }
                    
                    XQBMeMyOrderViewController *orderVC = [[XQBMeMyOrderViewController alloc]init];
                    orderVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:orderVC animated:YES];
                    
                    
                }
                    break;
                case 1:
                {
                    [self.mallPopoverController dismissPopoverAnimated:YES];
                    self.mallPopoverController.delegate = nil;
                    self.mallPopoverController = nil;
                    
                    if (![UserModel isLogin]) { //未登录弹出登录页面
                       [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
                        return;
                    }
                    
                    XQBECShippingAddressViewController *deliveryAddressVC = [[XQBECShippingAddressViewController alloc] init];
                    deliveryAddressVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:deliveryAddressVC animated:YES];
                }
                    
                    break;
                default:
                    break;
            }
        };
        
    } else {
        [self.mallPopoverController dismissPopoverAnimated:YES];
        self.mallPopoverController.delegate = nil;
        self.mallPopoverController = nil;
    }
}

#pragma mark --- AFNetwork
- (void)requestEcHomePage{
    [_blankPageView removeFromSuperview];
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+30)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    [manager GET:EC_HOME_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        [XQBLoadingView hideLoadingForView:self.view];
        [_headerAdsArray removeAllObjects];
        [_allProductsArray removeAllObjects];
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            
            NSArray *adsArray = [responseObject objectForKey:@"ads"];
            for (NSDictionary *adDic in adsArray) {
                AdModel *productAdModel = [[AdModel alloc] init];
                
                productAdModel.adId         = [adDic objectForKey:@"id"];
                productAdModel.imageUrl     = [adDic objectForKey:@"url"];
                productAdModel.productId    = [adDic objectForKey:@"productId"];
                
                [_headerAdsArray addObject:productAdModel];
            }
            
            if (_headerAdsArray.count > 0) {
                [self refreshAds];
            }
            
            NSArray *rbuyProductsArray = [responseObject objectForKey:@"rushBuyProducts"];
            NSArray *lbuyProductsArray = [responseObject objectForKey:@"limitedBuyProducts"];
            NSArray *normProductsArray = [responseObject objectForKey:@"normalProducts"];
            NSArray *productsArray = [NSArray arrayWithObjects:rbuyProductsArray, lbuyProductsArray, normProductsArray, nil];
            for (NSArray *tmpProductsArray in productsArray) {
                NSMutableArray *tmpMutableProductsArray = [[NSMutableArray alloc] init];
                for (NSDictionary *productDic in tmpProductsArray) {
                    ECProductModel *productModel = [[ECProductModel alloc] init];
                    
                    productModel.productId      = [[productDic objectForKey:@"id"] stringValue];
                    productModel.name           = DealWithJSONValue([productDic objectForKey:@"name"]);
                    productModel.cover          = DealWithJSONValue([productDic objectForKey:@"cover"]);
                    productModel.measure        = DealWithJSONValue([productDic objectForKey:@"measure"]);
                    productModel.unit           = DealWithJSONValue([productDic objectForKey:@"unit"]);
                    
                    productModel.price          = [[productDic objectForKey:@"price"] stringValue];
                    productModel.oldPrice       = [[productDic objectForKey:@"oldPrice"] stringValue];
                    productModel.stockCount     = [[productDic objectForKey:@"stockCount"] stringValue];
                    productModel.isPostFree     = [[productDic objectForKey:@"isPostFree"] stringValue];
                    productModel.createTime     = DealWithJSONValue([productDic objectForKey:@"createTime"]);
                    
                    productModel.sortOrder      = [[productDic objectForKey:@"sortOrder"] stringValue];
                    productModel.favorNumber    = [[productDic objectForKey:@"favorNumber"] stringValue];
                    productModel.summary        = DealWithJSONValue([productDic objectForKey:@"summary"]);
                    productModel.discount       = DealWithJSONValue([productDic objectForKey:@"discount"]);
                    productModel.tagType        = DealWithJSONValue([productDic objectForKey:@"tag"]);
                    
                    productModel.limitedBuyNumber   = DealWithJSONValue([productDic objectForKey:@"limitedBuyNumber"]);
                    productModel.rushBuyStatus      = [[productDic objectForKey:@"rushBuyStatus"] integerValue];
                    productModel.rushBuyCountDown   = [[productDic objectForKey:@"rushBuyCountdown"] stringValue];
                    productModel.rushBuyStart       = DealWithJSONValue([productDic objectForKey:@"rushBuyStart"]);
                    productModel.rushBuyEnd         = DealWithJSONValue([productDic objectForKey:@"rushBuyEnd"]);
                    
                    [tmpMutableProductsArray addObject:productModel];
                }
                [_allProductsArray addObject:tmpMutableProductsArray];
            }
            
            unsigned long productsCount = 0;
            for (NSMutableArray *tmpMutableProductsArray in _allProductsArray) {
                productsCount = productsCount+tmpMutableProductsArray.count;
            }
            
            if (productsCount > 0) {
                [_collectionView reloadData];
            } else {
                //加载无数据界面；
                [self.view addSubview:self.blankPageView];
                [_blankPageView resetImage:[UIImage imageNamed:@"no_collection.png"]];
                [_blankPageView resetTitle:MALL_NO_LIST_DATA andDescribe:MALL_NO_LIST_DATA_DESCRIBE];
            }
        } else if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_CITY_NOT_OPEN]) {
            [_collectionView reloadData];
            [self.view addSubview:self.blankPageView];
            [_blankPageView resetImage:[UIImage imageNamed:@"no_collection.png"]];
            [_blankPageView resetTitle:MALL_CITY_NOT_OPEN andDescribe:nil];
        } else {
            //加载服务器异常界面
            [_collectionView reloadData];
            [self.view addSubview:self.blankPageView];
            [_blankPageView resetImage:[UIImage imageNamed:@"server_error.png"]];
            [_blankPageView resetTitle:SERVER_ERROR andDescribe:SERVER_ERROR_DESCRIBE];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [_collectionView reloadData];
        [XQBLoadingView hideLoadingForView:self.view];
        [self.view addSubview:self.blankPageView];
        [_blankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
        [_blankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
    }];
}

- (void)requestCartsItemCount{
    
    if (![UserModel isLogin]) { //未登录弹出登录页面
        [self.shoppingCartButton deleteCustomBadge];
        return;
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters addSignatureKey];
    WEAKSELF
    [manager GET:EC_CARTS_ITEMCOUNT_URL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSInteger addToCartNumber = [[responseObject objectForKey:@"cartItemCount"] integerValue];
             if (addToCartNumber > 0) {
                 [weakSelf.shoppingCartButton setCustomBadgeValue:[NSString stringWithFormat:@"%ld", addToCartNumber] withFrame:CGRectMake(22, 2, 10, 10) withBackgroundColor:[UIColor orangeColor]];
             }else{
                 [weakSelf.shoppingCartButton deleteCustomBadge];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //加载网络异常界面
             XQBLog(@"网络异常Error:%@", error);
         }];
    
}

#pragma mark --- collectionView UICollectionViewDataSource
#pragma mark --- --- optional dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _allProductsArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ECPLVHeaderRushBuyReusableView *hearderRushBuyView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RUSH_BUY_VIEW" forIndexPath:indexPath];
        [hearderRushBuyView.adsView addSubview:self.headerAdsView];
        [self refreshAds];
        
        if ([[_allProductsArray objectAtIndex:indexPath.section] count] > 0 ) {
            ECProductModel *productModel = [[_allProductsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            if (productModel.rushBuyStatus == XQBECProductRushByStatusUnBuying) {
                hearderRushBuyView.rushBuyStatusLabel.text = @"即将开始";
                hearderRushBuyView.rushBuyStatusLabel.textColor = XQBColorGreen;
                [hearderRushBuyView.countTimer pause];
                [hearderRushBuyView.countTimer setCountDownTime:0];
                
                NSDateComponents *dateComponent = [NSObject dateComponentsStr:productModel.rushBuyStart];
                NSLog(@"%@", dateComponent);
                hearderRushBuyView.timeView.hours = dateComponent.hour;
                hearderRushBuyView.timeView.minutes = dateComponent.minute;
                hearderRushBuyView.timeView.seconds = dateComponent.second;
                
                hearderRushBuyView.dateLabel.text = [NSString stringWithFormat:@"%ld月%ld日", (long)dateComponent.month, (long)dateComponent.day];
            } else if (productModel.rushBuyStatus == XQBECProductRushByStatusEnd) {
                [hearderRushBuyView.countTimer setCountDownTime:0];
                hearderRushBuyView.rushBuyStatusLabel.text = @"已结束";
                hearderRushBuyView.rushBuyStatusLabel.textColor = XQBColorExplain;
                
                hearderRushBuyView.timeView.hours = 0;
                hearderRushBuyView.timeView.minutes = 0;
                hearderRushBuyView.timeView.seconds = 0;
                
                hearderRushBuyView.dateLabel.text = @"";
            } else if(productModel.rushBuyStatus == XQBECProductRushByStatusBuying){
                hearderRushBuyView.rushBuyStatusLabel.text = @"距抢购结束";
                hearderRushBuyView.rushBuyStatusLabel.textColor = RGB(250, 80, 0);
                [hearderRushBuyView.countTimer setCountDownTime:[productModel.rushBuyCountDown integerValue]];
                [hearderRushBuyView.countTimer startWithCountingBlock:^(NSInteger hour, NSInteger minute, NSInteger second) {
                    //刷新读秒
                    hearderRushBuyView.timeView.hours = hour;
                    hearderRushBuyView.timeView.minutes = minute;
                    hearderRushBuyView.timeView.seconds = second;
                }];
                [hearderRushBuyView.countTimer startWithEndingBlock:^(NSTimeInterval timeUserValue) {
                    //刷新读秒
                    hearderRushBuyView.timeView.hours = 0;
                    hearderRushBuyView.timeView.minutes = 0;
                    hearderRushBuyView.timeView.seconds = 0;
                    
                }];
                [hearderRushBuyView.countTimer start];
                
                hearderRushBuyView.dateLabel.text = @"";
            }
        }
        
        return hearderRushBuyView;
    } else if (indexPath.section == 1){
        ECPLVHeaderLimitedBuyReusableView *hearderLimitedBuyView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LIMITED_BUY_VIEW" forIndexPath:indexPath];
        return hearderLimitedBuyView;
    } else {
        ECPLVHeaderSpaceReusableView *hearderSpaceView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SPACE_VIEW" forIndexPath:indexPath];
        return hearderSpaceView;
    }
}


#pragma mark --- --- required dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([[_allProductsArray objectAtIndex:section] count]%2 == 1) {
        return [[_allProductsArray objectAtIndex:section] count] + 1;
    } else {
        return [[_allProductsArray objectAtIndex:section] count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ECProductModel *productModel;
    
    if ([[_allProductsArray objectAtIndex:indexPath.section] count] > indexPath.row) {
        productModel = [[_allProductsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else {
        productModel = [[ECProductModel alloc] init];
    }
    
    if (indexPath.section == 0) {
        ECPLVSpecialtyGoodsCVCell *rushBuyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SPECIALTY_GOODS_CELL" forIndexPath:indexPath];
        if ([[_allProductsArray objectAtIndex:indexPath.section] count] == indexPath.row) {
            rushBuyCell.goodsImageView.hidden = YES;
            rushBuyCell.nameLabel.hidden = YES;
            rushBuyCell.priceLabel.hidden = YES;
            rushBuyCell.discountLabel.hidden = YES;
        } else {
            rushBuyCell.goodsImageView.hidden = NO;
            rushBuyCell.nameLabel.hidden = NO;
            rushBuyCell.priceLabel.hidden = NO;
            rushBuyCell.discountLabel.hidden = NO;
        }
        
        [rushBuyCell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:rushBuyCell.goodsImageView.frame.size]];
        rushBuyCell.nameLabel.text = productModel.name;
        rushBuyCell.priceLabel.text = [PricesShown priceOfShorthand:[productModel.price doubleValue]];
        rushBuyCell.discountLabel.backgroundColor = RGB(255, 200, 175);
        
        if (productModel.rushBuyStatus == XQBECProductRushByStatusUnBuying) {
            rushBuyCell.discountLabel.text = @"将开始";
            rushBuyCell.discountLabel.backgroundColor = XQBColorGreen;
        } else if (productModel.rushBuyStatus == XQBECProductRushByStatusEnd) {
            rushBuyCell.discountLabel.text = @"抢光了";
            rushBuyCell.discountLabel.backgroundColor = XQBColorExplain;
        } else if(productModel.rushBuyStatus == XQBECProductRushByStatusBuying){
            [rushBuyCell.discountLabel setDiscount:productModel.discount];
        }
        
        [rushBuyCell getLinePositionAtIndex:indexPath.row withCellCount:[[_allProductsArray objectAtIndex:indexPath.section] count]];
        
        return rushBuyCell;
    } else if (indexPath.section == 1) {
        ECPLVSpecialtyGoodsCVCell *limitedBuyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SPECIALTY_GOODS_CELL" forIndexPath:indexPath];
        
        if ([[_allProductsArray objectAtIndex:indexPath.section] count] == indexPath.row) {
            limitedBuyCell.goodsImageView.hidden = YES;
            limitedBuyCell.nameLabel.hidden = YES;
            limitedBuyCell.priceLabel.hidden = YES;
            limitedBuyCell.discountLabel.hidden = YES;
        } else {
            limitedBuyCell.goodsImageView.hidden = NO;
            limitedBuyCell.nameLabel.hidden = NO;
            limitedBuyCell.priceLabel.hidden = NO;
            limitedBuyCell.discountLabel.hidden = NO;
        }
        
        [limitedBuyCell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:limitedBuyCell.goodsImageView.frame.size]];
        limitedBuyCell.nameLabel.text = productModel.name;
        limitedBuyCell.priceLabel.text = [PricesShown priceOfShorthand:[productModel.price doubleValue]];
        limitedBuyCell.discountLabel.backgroundColor = RGB(255, 200, 175);
        [limitedBuyCell.discountLabel setDiscount:productModel.discount];
        
        [limitedBuyCell getLinePositionAtIndex:indexPath.row withCellCount:[[_allProductsArray objectAtIndex:indexPath.section] count]];
        
        return limitedBuyCell;
    } else if (indexPath.section == 2){
        ECPLVGeneralGoodsCVCell *generalCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GENERAL_GOODS_CELL" forIndexPath:indexPath];
        if ([[_allProductsArray objectAtIndex:indexPath.section] count] == indexPath.row) {
            generalCell.goodsImageView.hidden = YES;
            generalCell.nameLabel.hidden = YES;
            generalCell.priceLabel.hidden = YES;
            generalCell.discountLabel.hidden = YES;
        } else {
            generalCell.goodsImageView.hidden = NO;
            generalCell.nameLabel.hidden = NO;
            generalCell.priceLabel.hidden = NO;
            generalCell.discountLabel.hidden = NO;
        }
        
        [generalCell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:generalCell.goodsImageView.frame.size]];
        
        generalCell.nameLabel.text = productModel.name;
        generalCell.summaryLabel.text = productModel.summary;
        generalCell.priceLabel.text = [PricesShown priceOfShorthand:[productModel.price doubleValue]];
        [generalCell.discountLabel setDiscount:productModel.discount];
        
        [generalCell getLinePositionAtIndex:indexPath.row withCellCount:[[_allProductsArray objectAtIndex:indexPath.section] count]];
        
        return generalCell;
    } else {
        return nil;
    }
}


#pragma mairk --- collectionView UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击某一个cell
    if ([[_allProductsArray objectAtIndex:indexPath.section] count] > indexPath.row) {
        ECProductModel *productModel = [[_allProductsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        XQBECProductDetailViewController *productDetailVC = [[XQBECProductDetailViewController alloc] init];
        productDetailVC.productId = productModel.productId;
        productDetailVC.productIamgeUrl = productModel.cover;
        productDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
}

#pragma mark --- collectionView UICollectionViewDelegateFlowLayout
#pragma mark ---  --- optional delegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return CGSizeMake(MainWidth/2, kSpecialtyItemHight);
    } else {
        return CGSizeMake(MainWidth/2, kGeneralItemHight);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([[_allProductsArray objectAtIndex:section] count] > 0) {
            return CGSizeMake(MainWidth, kHeaderAdHight+kHeaderSpaceHight+kHeaderItemHight);
        } else {
            return CGSizeMake(MainWidth, kHeaderAdHight);
        }
    } else if (section == 1) {
        if ([[_allProductsArray objectAtIndex:section] count] > 0) {
            return CGSizeMake(MainWidth, kHeaderSpaceHight+kHeaderItemHight);
        } else {
            return CGSizeMake(0, 0);
        }
    } else {
        if ([[_allProductsArray objectAtIndex:section] count] > 0) {
            return CGSizeMake(MainWidth, kHeaderSpaceHight);
        } else {
            return CGSizeMake(0, 0);
        }
    }
}

#pragma mark    ---RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (direction==RefreshDirectionTop)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl finishRefreshingDirection:RefreshDirectionTop];
        });
        [self requestEcHomePage];
        [XQBLoadingView hideLoadingForView:self.view];
    }
}

#pragma mark ---noticefication
- (void)userLoginSucceedNotice:(NSNotification *)notice{
    [self requestEcHomePage];
    [self requestCartsItemCount];
    
}

- (void)userCertificationSucceedNotice:(NSNotification *)notice{
    [self requestEcHomePage];
    [self requestCartsItemCount];
}

- (void)userLogoutSucceedNotice:(NSNotification *)notice{
    [self requestEcHomePage];
    [self requestCartsItemCount];
}

@end
