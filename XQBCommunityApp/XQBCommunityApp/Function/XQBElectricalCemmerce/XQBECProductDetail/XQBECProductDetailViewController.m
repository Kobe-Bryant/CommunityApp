//
//  XQBECProductDetailViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/13.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBECProductDetailViewController.h"
#import "Global.h"
#import "UIImage+extra.h"
#import "NSObject+Time.h"
#import "WEPopoverController.h"
#import "UIBarButtonItem+WEPopover.h"
#import "ECProductModel.h"
#import "CMSSCountTimer.h"
#import "XQBBaseTableView.h"
#import "CMSSTimerView.h"
#import "UICustomLineLabel.h"
#import "XQBImageModel.h"
#import "XQBCommonButton.h"
#import "PricesShown.h"
#import "CycleScrollView.h"
#import "AdModel.h"
#import "ECProductItemModel.h"
#import "SGGoodsStandardView.h"
#import "XQBLginViewController.h"
#import "ECPopMenuItem.h"
#import "MallPopListViewController.h"
#import "XQBECShoppingCartViewController.h"
#import "XQBECProductDetailWebViewController.h"
#import "XQBECShippingAddressViewController.h"
#import "XQBMeMyOrderViewController.h"
#import "BlankPageView.h"
#import "XQBECBuyingOrderViewController.h"
#import "UIView+CustomBadge.h"
#import "XQBLoginNavigationController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

static NSString *CMPProductId   = @"id";
static NSString *CMPName        = @"name";
static NSString *CMPCover       = @"cover";
static NSString *CMPMeasure     = @"measure";
static NSString *CMPUnit        = @"unit";
static NSString *CMPPrice       = @"price";
static NSString *CMPOldPrice    = @"oldPrice";
static NSString *CMPStockCount  = @"stockCount";
static NSString *CMPIsPostFree  = @"isPostFree";
static NSString *CMPProductTag  = @"tag";
static NSString *CMPCreateTime  = @"createTime";
static NSString *CMPSortOrder   = @"sortOrder";
static NSString *CMPFavorNumber = @"favorNumber";
static NSString *CMPSummary     = @"summary";
static NSString *CMPDiscount    = @"discount";

static NSString *CMPShippingFee = @"shippingFee";
static NSString *CMPCityName = @"cityName";

static NSString *CMPRushByStart = @"rushBuyStart";
static NSString *CMPRushByEnd = @"rushBuyEnd";
static NSString *CMPRushBuyStatus = @"rushBuyStatus";
static NSString *CMPRushBuyCountDown = @"rushBuyCountdown";
static NSString *CMPLimitedBuyNumber = @"limitedBuyNumber";
static NSString *CMPItemTotalCount  = @"itemTotalCount";



CGFloat textOffsetX = 14;
CGFloat adHeight = 320;
static NSString *identify = @"identify";

@interface XQBECProductDetailViewController () <UITableViewDelegate,UITableViewDataSource,WEPopoverControllerDelegate>

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSString* currentProductItemId;
@property (nonatomic)   NSInteger productCount;
@property (nonatomic, strong) NSMutableArray *productItems;
@property (nonatomic, strong) NSMutableArray *guessProducts;
@property (nonatomic, strong) ECProductModel *productModel;
@property (nonatomic) NSInteger addToCartNumber;
@property (nonatomic, strong) UIScrollView *maybeYouloveScrollView;

//UI
@property (nonatomic, strong) XQBBaseTableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *limitedLabel;
@property (nonatomic, strong) UIButton *buyNowButton;
@property (nonatomic, strong) UIButton *addShopingCartButton;
@property (nonatomic, strong) UIView *shoppingCartView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) CycleScrollView *cycleScrollView;
@property (nonatomic, strong) UIButton *shoppingCartButton;
@property (nonatomic, strong) UILabel *guessYouLoveLabel;

//cell
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *expressLabel;
@property (nonatomic, strong) UILabel *goodsPriceLabel;
@property (nonatomic, strong) UILabel *goodsStandardLabel;
@property (nonatomic, strong) UILabel *oldPriceTitleLabel;
@property (nonatomic, strong) UICustomLineLabel *oldPriceLabel;
@property (nonatomic, strong) UILabel *shippingFeeLabel;
@property (nonatomic, strong) UILabel *favorNumLabel;
@property (nonatomic, strong) UILabel *discountLabel;

@property (nonatomic, strong) WEPopoverController *mallPopoverController;

@property (nonatomic, strong) CMSSCountTimer *countTimer;
@property (nonatomic, strong) UIImageView *timeIconImageView;
@property (nonatomic, strong) CMSSTimerView *timeView;
@property (nonatomic, strong) UILabel *rushDateLabel;

@property (nonatomic, strong) XQBLoginNavigationController *loginNavViewController;

@property (nonatomic, strong) BlankPageView *blankPageView;

@end

@implementation XQBECProductDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _productModel = [[ECProductModel alloc] init];
        _imageArray = [[NSMutableArray alloc] init];
        _productItems = [[NSMutableArray alloc] init];
        _guessProducts = [[NSMutableArray alloc] init];
        _currentProductItemId = nil;
        _productCount = 0;
        _addToCartNumber = 0;
        
        _loginNavViewController = [[XQBLoginNavigationController alloc] init];
        [self.navigationController addChildViewController:_loginNavViewController];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = XQBColorBackground;
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"宝贝详情"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    UIButton *mallMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mallMoreButton addTarget:self action:@selector(popMallMoreView:) forControlEvents:UIControlEventTouchUpInside];
    mallMoreButton.frame = CGRectMake(0, 0, 30, 30);
    [mallMoreButton setImage:[UIImage imageNamed:@"shoppingmall_more_green.png"] forState:UIControlStateNormal];
    [self setRightBarButtonItems:@[mallMoreButton,self.shoppingCartButton]];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomView];
    
    [self initalize];
    
    //[self addHeader];
    
    [self requestProductInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestProductGuess];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- ui
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - STATUS_NAV_BAR_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = XQBColorBackground;
        _tableView.sectionFooterHeight = 10.0f;
        _tableView.tableHeaderView = self.tableHeaderView;
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        _tableView.separatorColor = XQBColorInternalSeparationLine;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestCartsItemCount];
    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)initalize{
    _productCount = 0;
}

#pragma mark  ----UI

#pragma mark  ----UI


- (UIImageView *)timeIconImageView{
    if (!_timeIconImageView) {
        _timeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(185, 65, 18, 20)];
        _timeIconImageView.image = [UIImage imageNamed:@"mall_time_icon"];
    }
    
    return _timeIconImageView;
}

- (CMSSTimerView *)timeView{
    if (!_timeView) {
        _timeView = [[CMSSTimerView alloc] initWithFrame:CGRectMake(210, 69, 150, 15)];
    }
    
    return _timeView;
    
}

- (UILabel *)rushDateLabel{
    if (_rushDateLabel == nil) {
        _rushDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 42, 100, 20)];
        _rushDateLabel.font = [UIFont systemFontOfSize:12.0f];
        _rushDateLabel.backgroundColor = [UIColor clearColor];
        _rushDateLabel.textColor = RGB(153, 153, 153);
    }
    
    return _rushDateLabel;
}

- (CMSSCountTimer *)countTimer{
    if (!_countTimer) {
        _countTimer = [[CMSSCountTimer alloc] init];
        
    }
    
    return _countTimer;
}

- (void)refreshAds{
    
    NSMutableArray *_ads = [[NSMutableArray alloc] init];
    
    for (NSDictionary *adDic in self.productModel.images) {
        NSString *imageUrl = [adDic objectForKey:@"url"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adHeight)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:imageView.frame.size]];
        [_ads addObject:imageView];
        
    }
    
    //WEAKSELF
    self.cycleScrollView.totalPagesCount = ^NSInteger(void){
        return _ads.count;
    };
    self.cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return _ads[pageIndex];
    };
    __weak typeof(self) weakSelf = self;
    self.cycleScrollView.TapActionBlock = ^(NSInteger pageIndex){
        //小区图片
        NSMutableArray *imgArr = [[NSMutableArray alloc] init];
        for (NSDictionary *adDic in weakSelf.productModel.images) {
            [imgArr addObject:[adDic objectForKey:@"url"]];
        }
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imgArr.count];
        for (int i = 0; i<imgArr.count; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            NSString *strUrl = [imgArr objectAtIndex:i];
            photo.url = [NSURL URLWithString:strUrl]; // 图片路径
            photo.srcImageView = weakSelf.cycleScrollView.scrollView.subviews[(imgArr.count-1)/2]; // 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        for (UIView *view in weakSelf.cycleScrollView.scrollView.subviews) {
            NSLog(@"%@", view);
        }
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = pageIndex; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    };
}
/**
 *  商品名的label
 *
 *  @return 商品名的label
 */
- (UILabel *)goodsNameLabel{
    if (_goodsNameLabel == nil) {
        _goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 160, 45)];
        _goodsNameLabel.numberOfLines = 0;
        _goodsNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _goodsNameLabel.textColor = RGB(109, 109, 109);
        _goodsNameLabel.font = [UIFont systemFontOfSize:15];
        _goodsNameLabel.backgroundColor = [UIColor clearColor];
        
    }
    return _goodsNameLabel;
}

- (UILabel *)expressLabel{
    if (!_expressLabel) {
        _expressLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 5, 120, 45)];
        _expressLabel.numberOfLines = 1;
        _expressLabel.textColor = XQBColorOrange;
        _expressLabel.font = XQBFontExplain;
        _expressLabel.text = @"该商品只支持同城配送";
        _expressLabel.backgroundColor = [UIColor clearColor];
    }
    return _expressLabel;
}

/**
 *  商品价格的label
 *
 *  @return 商品价格的label
 */
- (UILabel *)goodsPriceLabel{
    if (_goodsPriceLabel == nil) {
        _goodsPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 100, 30)];
        _goodsPriceLabel.textColor = RGB(224 ,121 ,29);
        _goodsPriceLabel.font = [UIFont systemFontOfSize:17];
        _goodsPriceLabel.backgroundColor = [UIColor clearColor];
        
    }
    return _goodsPriceLabel;
}

- (UILabel *)discountLabel{
    
    if (_discountLabel == nil) {
        _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 50, 36, 14)];
        [_discountLabel setBackgroundColor:RGB(255,200,175)];
        _discountLabel.layer.cornerRadius = 3.0f;
        _discountLabel.layer.masksToBounds = YES;
        [_discountLabel setTextColor:[UIColor whiteColor]];
        [_discountLabel setFont:[UIFont systemFontOfSize:10]];
        [_discountLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _discountLabel;
    
}

- (UILabel *)goodsStandardLabel{
    
    if (_goodsStandardLabel == nil) {
        _goodsStandardLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 12, 150, 20)];
        _goodsStandardLabel.textColor = RGB(103, 103, 103);
        _goodsStandardLabel.backgroundColor = [UIColor clearColor];
        _goodsStandardLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _goodsStandardLabel;
}

- (UIView *)tableHeaderView{
    if (_tableHeaderView == nil) {
        
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adHeight)];
        
        [_tableHeaderView addSubview:self.cycleScrollView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, adHeight, SCREEN_WIDTH, .3f)];
        lineView.backgroundColor = RGB(226, 226, 226);
        [_tableHeaderView addSubview:lineView];
        
    }
    
    return _tableHeaderView;
}

- (CycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, adHeight) animationDuration:-1];
    }
    
    return _cycleScrollView;
}

- (UIButton *)shoppingCartButton{
    if (_shoppingCartButton == nil) {
        _shoppingCartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_shoppingCartButton setImage:[UIImage imageNamed:@"shoppingmall_cart.png"] forState:UIControlStateNormal];
        [_shoppingCartButton addTarget:self action:@selector(entryShoppingCartVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shoppingCartButton;
}

- (UIView *)bottomView{
    
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(-1,SCREEN_HEIGHT - STATUS_NAV_BAR_HEIGHT -65, SCREEN_WIDTH+2, 65)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.borderColor = XQBColorElementSeparationLine.CGColor;
        _bottomView.layer.borderWidth = 0.5;
        
        _limitedLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 15, 80, 35)];
        _limitedLabel.textColor = RGB(250, 150, 0);
        _limitedLabel.textAlignment = NSTextAlignmentCenter;
        _limitedLabel.font = [UIFont systemFontOfSize:12.0f];
        _limitedLabel.numberOfLines = 2;
        _limitedLabel.hidden = YES;
        _limitedLabel.backgroundColor = [UIColor clearColor];
        _limitedLabel.layer.borderColor = RGB(250, 150, 0).CGColor;
        _limitedLabel.layer.borderWidth = 0.5;
        _limitedLabel.layer.cornerRadius = 3.0f;
        [_bottomView addSubview:_limitedLabel];
        
        _buyNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyNowButton addTarget:self action:@selector(buyNowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _buyNowButton.frame = CGRectMake( 214, 10, 93, 45);
        [_buyNowButton setExclusiveTouch:YES];
        [_buyNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyNowButton setTitle:@"立即购买" forState:UIControlStateNormal];
        _buyNowButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_buyNowButton.layer setMasksToBounds:YES];
        [_buyNowButton setBackgroundImage:[UIImage imageWithColor:RGB(250, 0, 0) size:_buyNowButton.bounds.size] forState:UIControlStateNormal];
        [_buyNowButton setBackgroundImage:[UIImage imageWithColor:RGB(153, 153, 153) size:_buyNowButton.bounds.size] forState:UIControlStateDisabled];
        [_buyNowButton.layer setCornerRadius:3];
        [_bottomView addSubview:_buyNowButton];
        
        _addShopingCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addShopingCartButton addTarget:self action:@selector(addToShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
        _addShopingCartButton.frame = CGRectMake( 110, 10, 93, 45);
        [_addShopingCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addShopingCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addShopingCartButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_addShopingCartButton setBackgroundImage:[UIImage imageWithColor:RGB(250, 150, 0) size:_addShopingCartButton.bounds.size] forState:UIControlStateNormal];
        [_addShopingCartButton setBackgroundImage:[UIImage imageWithColor:RGB(153, 153, 153) size:_addShopingCartButton.bounds.size] forState:UIControlStateDisabled];
        [_addShopingCartButton.layer setMasksToBounds:YES];
        [_addShopingCartButton.layer setCornerRadius:3];
        [_bottomView addSubview:_addShopingCartButton];
    }
    return _bottomView;
}

- (UILabel *)guessYouLoveLabel{
    if (_guessYouLoveLabel == nil) {
        _guessYouLoveLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 200, 20)];
        _guessYouLoveLabel.backgroundColor = [UIColor clearColor];
        _guessYouLoveLabel.font = [UIFont systemFontOfSize:15.0f];
        _guessYouLoveLabel.textColor = RGB(102, 102, 102);
    }
    
    return _guessYouLoveLabel;
}

- (UIScrollView *)maybeYouloveScrollView{
    if (_maybeYouloveScrollView == nil) {
        _maybeYouloveScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 75)];
        _maybeYouloveScrollView.showsHorizontalScrollIndicator = NO;
        _maybeYouloveScrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _maybeYouloveScrollView;
}




- (void)refreshLoveScrollView{
    for (UIView *view in self.maybeYouloveScrollView.subviews) {
        [view removeFromSuperview];
    }
    UIEdgeInsets margin = UIEdgeInsetsMake(5, 20, 5, 20);
    CGFloat space = 5.0f;
    CGSize itemSize = CGSizeMake(65 , 65);
    CGFloat maxWidth = MAX(self.maybeYouloveScrollView.bounds.size.width, [_guessProducts count] * (itemSize.height+space)+margin.left+margin.right);
    self.maybeYouloveScrollView.contentSize = CGSizeMake(maxWidth, self.maybeYouloveScrollView.bounds.size.height);
    
    for (XQBImageModel *model in _guessProducts) {
        
        NSInteger index = [_guessProducts indexOfObject:model];
        CGRect rect = CGRectMake(margin.left + (itemSize.width+space)*index, margin.top, itemSize.width, itemSize.height);
        XQBCommonButton *btn = [[XQBCommonButton alloc] initWithFrame:rect];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_square_placeholder_image.png"]];
        btn.tag = index;
        btn.actionHandleBlock = ^(NSInteger index){
            XQBECProductDetailViewController *viewController = [[XQBECProductDetailViewController alloc] init];
            viewController.productId = model.imageId;
            viewController.productIamgeUrl = model.imageUrl;
            [self.navigationController pushViewController:viewController animated:YES];
        };
        [self.maybeYouloveScrollView addSubview:btn];
    }
    
    self.maybeYouloveScrollView.frame = CGRectMake(LEFT(self.maybeYouloveScrollView),TOP(self.maybeYouloveScrollView), 320,self.maybeYouloveScrollView.contentSize.height);
    
}

- (void)refreshMeasure{
    NSString *string = [NSString stringWithFormat:@"%@ %ld%@",_productModel.measure,self.productCount,_productModel.unit];
    if (self.productCount == 0) {
        self.goodsStandardLabel.hidden = YES;
    }else{
        self.goodsStandardLabel.hidden = NO;
    }
    self.goodsStandardLabel.text = [NSString stringWithFormat:@"\"%@\"",string];
    
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"%@", [PricesShown priceOfShorthand:[_productModel.price doubleValue]]];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"%@",[PricesShown priceOfShorthand:[_productModel.oldPrice doubleValue]]];
    CGFloat strWidth = [[PricesShown priceOfShorthand:[_productModel.price doubleValue]] sizeWithFont:[self.goodsPriceLabel font]].width;
    self.discountLabel.frame = CGRectMake(CGRectGetMinX(self.goodsPriceLabel.frame)+strWidth+20, CGRectGetMinY(self.discountLabel.frame), CGRectGetWidth(self.discountLabel.frame), CGRectGetHeight(self.discountLabel.frame));
    if ([_productModel.discount doubleValue] < 1) {
        self.discountLabel.text = @"<1折";
    } else {
        self.discountLabel.text = [NSString stringWithFormat:@"%@折",_productModel.discount];
    }
    
    if ([_productModel.oldPrice isEqualToString:_productModel.price]) {
        _discountLabel.hidden = YES;
        _oldPriceLabel.hidden = YES;
        _oldPriceTitleLabel.hidden = YES;
    }else{
        _discountLabel.hidden = NO;
        _oldPriceLabel.hidden = NO;
        _oldPriceTitleLabel.hidden = NO;
    }
    
    if ([_productModel.discount doubleValue] < 10) {
        _discountLabel.hidden = NO;
    }else{
        _discountLabel.hidden = YES;
    }
    
}

- (void)refreshLimited{
    NSInteger limtedCount = ([_productModel.limitedBuyNumber integerValue] > 0)?[_productModel.limitedBuyNumber integerValue]:0;
    if (limtedCount > 0) {
        self.limitedLabel.hidden = NO;
        
        self.limitedLabel.text = [NSString stringWithFormat:@"只限抢购\n%ld件商品哟~",limtedCount];
    }else{
        self.limitedLabel.hidden = YES;
    }
}


- (void)refreshTableView{
    [self refreshAds];
    if (_productModel.cityName.length != 0) {
        _expressLabel.text = [NSString stringWithFormat:@"该商品只支持%@配送", _productModel.cityName];
    }
    [self.tableView reloadData];
}


- (UILabel *)oldPriceTitleLabel{
    if (_oldPriceTitleLabel == nil) {
        _oldPriceTitleLabel = [[UICustomLineLabel alloc] initWithFrame:CGRectMake(textOffsetX, 70, 30, 15)];
        _oldPriceTitleLabel.font = [UIFont systemFontOfSize:11.0f];
        _oldPriceTitleLabel.textColor = RGB(153, 153, 153);
        _oldPriceTitleLabel.backgroundColor = [UIColor clearColor];
        _oldPriceTitleLabel.text = @"价格:";
        
    }
    
    return _oldPriceTitleLabel;
}

- (UICustomLineLabel *)oldPriceLabel{
    if (_oldPriceLabel == nil) {
        _oldPriceLabel = [[UICustomLineLabel alloc] initWithFrame:CGRectMake(textOffsetX+30, 70, 90, 15)];
        _oldPriceLabel.font = [UIFont systemFontOfSize:11.0f];
        _oldPriceLabel.textColor = [UIColor grayColor];//RGB(153, 153, 153);
        [_oldPriceLabel setLineType:LineTypeMiddle];
        [_oldPriceLabel setLineColor:[UIColor grayColor]];
        _oldPriceLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    return _oldPriceLabel;
}

- (UILabel *)shippingFeeLabel{
    if (_shippingFeeLabel == nil) {
        _shippingFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(textOffsetX, 90, 120, 12)];
        _shippingFeeLabel.font = [UIFont systemFontOfSize:11.0f];
        _shippingFeeLabel.textColor = RGB(153, 153, 153);
        _shippingFeeLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _shippingFeeLabel;
}


- (UILabel *)favorNumLabel{
    if (_favorNumLabel == nil) {
        _favorNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 90, 100, 12)];
        _favorNumLabel.font = [UIFont systemFontOfSize:11.0f];
        _favorNumLabel.textColor = RGB(153, 153, 153);
        _favorNumLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _favorNumLabel;
}

//空白界面
- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        WEAKSELF
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MainHeight)];
        _blankPageView.blankPageDidClickedBlock = ^(){
            [weakSelf requestCartsItemCount];
            [weakSelf requestProductInfo];
        };
    }
    return _blankPageView;
}


#pragma mark ---network
- (void)requestProductInfo{    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters addSignatureKey];
    

    [manager GET:EC_PRODUCT_INFO_DYNAMIC_URL(self.productId)
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                 
                 
                 _productModel.images = [responseObject objectForKey:@"images"];
                 _productModel.detailUrl = [responseObject objectForKey:@"detailUrl"];
                 if (![[responseObject objectForKey:CMPProductId] isKindOfClass:[NSNull class]]){
                     NSInteger productId = DealWithJSONIntValue([responseObject objectForKey:CMPProductId]);
                     _productModel.productId = [[NSNumber numberWithInteger:productId] stringValue];;
                     self.productId = _productModel.productId;
                 }
                 if (![[responseObject objectForKey:CMPCover] isKindOfClass:[NSNull class]]){
                     _productModel.cover = [responseObject objectForKey:CMPCover];
                 }
                 if (![[responseObject objectForKey:CMPOldPrice] isKindOfClass:[NSNull class]]){
                     _productModel.oldPrice = [[responseObject objectForKey:CMPOldPrice] stringValue];
                 }else{
                     _productModel.oldPrice = @"";
                 }
                 
                 if (![[responseObject objectForKey:CMPCreateTime] isKindOfClass:[NSNull class]]){
                     _productModel.createTime = [responseObject objectForKey:CMPCreateTime];
                 }
                 _productModel.sortOrder = DealWithJSONValue([responseObject objectForKey:CMPSortOrder]);
                 if (![[responseObject objectForKey:CMPFavorNumber] isKindOfClass:[NSNull class]]){
                     _productModel.favorNumber = [responseObject objectForKey:CMPFavorNumber];
                 }
                 if (![[responseObject objectForKey:CMPSummary] isKindOfClass:[NSNull class]]){
                     _productModel.summary = [responseObject objectForKey:CMPSummary];
                 }
                 
                 _productModel.stockCount = DealWithJSONValue([responseObject objectForKey:CMPStockCount]);
                 _productModel.isPostFree = DealWithJSONValue([responseObject objectForKey:CMPIsPostFree]);
                 _productModel.price = DealWithJSONValue([responseObject objectForKey:CMPPrice]);
                 _productModel.measure = DealWithJSONValue([responseObject objectForKey:CMPMeasure]);
                 _productModel.unit = DealWithJSONValue([responseObject objectForKey:CMPUnit]);
                 _productModel.name = DealWithJSONValue([responseObject objectForKey:CMPName]);
                 _productModel.discount = DealWithJSONValue([responseObject objectForKey:CMPDiscount]);
                 _productModel.cityName = DealWithJSONValue([responseObject objectForKey:CMPCityName]);
                 
                 _productModel.shippingFee = DealWithJSONValue([responseObject objectForKey:CMPShippingFee]);
                 _productModel.tagType = DealWithJSONValue([responseObject objectForKey:CMPProductTag]);
                 _productModel.measureItemTotalCount = DealWithJSONValue([responseObject objectForKey:CMPItemTotalCount]);
                 
                 if ([_productModel.measureItemTotalCount integerValue] == 1) {
                     if ([_productModel.stockCount integerValue] > 0) {
                         _productCount = 0;     //1
                         _addShopingCartButton.enabled = YES;
                         _buyNowButton.enabled = YES;
                     }else{
                         _productCount = 0;
                         //_addShopingCartButton.enabled = NO;
                         //_buyNowButton.enabled = NO;
                     }
                 }else{
                     _productCount = 0;
                     _addShopingCartButton.enabled = YES;
                     _buyNowButton.enabled = YES;
                 }
    
                 
                 if ([_productModel.tagType isEqualToString:kXQBProductTagTypeRushBuy]) { //限时抢购
                     
                     _productModel.rushBuyStart = DealWithJSONValue([responseObject objectForKey:CMPRushByStart]);
                     _productModel.rushBuyEnd = DealWithJSONValue([responseObject objectForKey:CMPRushByEnd]);
                     _productModel.rushBuyStatus = [[responseObject objectForKey:CMPRushBuyStatus] integerValue];
                     _productModel.rushBuyCountDown = [[responseObject objectForKey:CMPRushBuyCountDown] stringValue];
                     NSInteger limitedBuyNumber = DealWithJSONIntValue([responseObject objectForKey:CMPLimitedBuyNumber]);
                     _productModel.limitedBuyNumber = [[NSNumber numberWithInteger:limitedBuyNumber] stringValue];
                     
                     [self refreshLimited];
                     
                     if (_productModel.rushBuyStatus == XQBECProductRushByStatusUnBuying) {
                         _buyNowButton.enabled = NO;
                         _addShopingCartButton.enabled = NO;
                         NSDateComponents *dateComponent = [NSObject dateComponentsStr:_productModel.rushBuyStart];
                         NSString *weekDay = [NSString getYear:dateComponent.year month:dateComponent.month day:dateComponent.day];
                         NSString *rushDateText = [NSString stringWithFormat:@"%ld月%ld日 %@",dateComponent.month,dateComponent.day,weekDay];
                         self.rushDateLabel.text = rushDateText;
                         
                         self.timeView.hours = dateComponent.hour;
                         self.timeView.minutes = dateComponent.minute;
                         self.timeView.seconds = dateComponent.second;
                         
                     }else if(_productModel.rushBuyStatus == XQBECProductRushByStatusBuying){
                         [self.countTimer setCountDownTime:[_productModel.rushBuyCountDown integerValue] ];
                         [self.countTimer startWithCountingBlock:^(NSInteger hour, NSInteger minute, NSInteger second) {
                             //刷新读秒
                             self.timeView.hours = hour;
                             self.timeView.minutes = minute;
                             self.timeView.seconds = second;
                             /*
                              _buyNowButton.enabled = YES;
                              _addShopingCartButton.enabled = YES;
                              */
                         }];
                         [self.countTimer startWithEndingBlock:^(NSTimeInterval time) {
                             self.timeView.hours = 0;
                             self.timeView.minutes = 0;
                             self.timeView.seconds = 0;
                             _buyNowButton.enabled = NO;
                             _addShopingCartButton.enabled = NO;
                         }];
                         [self.countTimer start];
                         
                     }else if (_productModel.rushBuyStatus == XQBECProductRushByStatusEnd){
                         self.timeView.hours = 0;
                         self.timeView.minutes = 0;
                         self.timeView.seconds = 0;
                         _buyNowButton.enabled = NO;
                         _addShopingCartButton.enabled = NO;
                     }
                     
                 }else if ([_productModel.tagType isEqualToString:kXQBProductTagTypeLimitedBuy]){
                     
                     NSInteger limitedBuyNumber = DealWithJSONIntValue([responseObject objectForKey:CMPLimitedBuyNumber]);
                     _productModel.limitedBuyNumber = [[NSNumber numberWithInteger:limitedBuyNumber] stringValue];
                     [self refreshLimited];
                     
                 }else if ([_productModel.tagType isEqualToString:kXQBProductTagTypeNew]){
                     
                 }else if ([_productModel.tagType isEqualToString:kXQBProductTagTypeHot]){
                     
                 }else if ([_productModel.tagType isEqualToString:kXQBProductTagNormal]){
                     
                 }
                 /*
                 if (_header.isRefreshing) {
                     [_header endRefreshing];
                 }
                  */
                 [self refreshTableView];
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     [self requestProductMeasure];
                     
                     [self requestReportProductFavor];
                 });
             }else if([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_EMPTY_PRODUCT]){
                 [self.view addSubview:[self blankPageView]];
                 [_blankPageView resetImage:[UIImage imageNamed:@"no_collection.png"]];
                 [_blankPageView resetTitle:@"商品不存在或已下架" andDescribe:@""];
             }else{
                 //加载服务器异常界面
                 XQBLog(@"服务器异常");
#warning 新老接口返回错误码字段不同      errorCode code
                 [self.view addSubview:[self blankPageView]];
                 [_blankPageView resetImage:[UIImage imageNamed:@"server_error.png"]];
                 [_blankPageView resetTitle:SERVER_ERROR andDescribe:SERVER_ERROR_DESCRIBE];
             }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view addSubview:[self blankPageView]];
        [_blankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
        [_blankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
    }];
}


- (void)requestProductMeasure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters addSignatureKey];
    
    [manager GET:EC_PRODUCT_ITEM_DYNAMIC_URL(self.productId)
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                 
                 [self.productItems removeAllObjects];
                 NSArray *items = [responseObject objectForKey:@"productItems"];
                 for (NSDictionary *item in items) {
                     ECProductItemModel *itemModel = [[ECProductItemModel alloc] init];
                     itemModel.productItemId = [[item objectForKey:@"id"] stringValue];
                     itemModel.measure = [item objectForKey:@"measure"];
                     itemModel.unit = [item objectForKey:@"unit"];
                     itemModel.price = [[item objectForKey:@"price"] stringValue];
                     itemModel.oldPrice = [[item objectForKey:@"oldPrice"] stringValue];
                     itemModel.stockCount = [[item objectForKey:@"stockCount"] stringValue];
                     itemModel.favorNumber = [[item objectForKey:@"favorNumber"] stringValue];
                     itemModel.isProductDefault = [[item objectForKey:@"isProductDefault"] boolValue];
                     itemModel.isSelected = NO;
                     itemModel.discount = [item objectForKey:@"discount"];
                     if (itemModel.isProductDefault) {
                         self.currentProductItemId = itemModel.productItemId;
                         itemModel.isSelected = YES;
                     }
                     [self.productItems addObject:itemModel];
                 }
                 
             }else{
                 //加载服务器异常界面
                 XQBLog(@"服务器异常");
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //加载网络异常界面
             XQBLog(@"网络异常Error:%@", error);
         }];
}

- (void)requestProductGuess{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    [manager GET:EC_PRODUCT_GUESS_DYNAMIC_URL(self.productId)
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                 
                 NSArray *array = [responseObject objectForKey:@"products"];
                 for (NSDictionary *product in array) {
                     XQBImageModel *imageModel = [[XQBImageModel alloc] init];
                     imageModel.imageId = [[product objectForKey:@"id"] stringValue];
                     imageModel.imageUrl = DealWithJSONValue([product objectForKey:@"url"]);
                     imageModel.strPrice = DealWithJSONValue([product objectForKey:@"price"]);
                     [self.guessProducts addObject:imageModel];
                 }
                 [self refreshLoveScrollView];
                 
             }else{
                 //加载服务器异常界面
                 XQBLog(@"猜你喜欢服务器异常");
                 
                 //[self.view.window makeCustomToast:[responseObject objectForKey:NETWORK_RETURN_ERROR_MSG]];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //加载网络异常界面
             XQBLog(@"网络异常Error:%@", error);
         }];

}

- (void)requestAddShoppingCart{
    if (![UserModel isLogin]) { //未登录弹出登录页面
        [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
        return;
    }
    
    if (self.currentProductItemId == nil || self.productCount == 0) {
        NSLog(@"数量不能为0,或者没有currentProductItemId");
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:self.currentProductItemId forKey:@"productItemId"];
    [parameters setObject:self.productModel.productId forKey:@"productId"];
    NSString *itemNumber = [[NSNumber numberWithInteger:self.productCount] stringValue];
    [parameters setObject:itemNumber forKey:@"itemNumber"];
    [parameters addSignatureKey];
    
    [manager GET:EC_CART_ADD_URL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.currentProductItemId = nil;
             self.productCount = 0;
             if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                 

                 NSString *message = [NSString stringWithFormat:@"恭喜,添加购物车成功!"];
                 [self.view.window makeCustomToast:message];
                 [self requestCartsItemCount];
                 
             }else{
                 //加载服务器异常界面
                 XQBLog(@"服务器异常");
                 NSString *msg = [responseObject objectForKey:NETWORK_RETURN_ERROR_MSG];
                 if (msg.length > 0) {
                      [self.view.window makeCustomToast:[responseObject objectForKey:NETWORK_RETURN_ERROR_MSG]];
                 }
                
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             self.currentProductItemId = nil;
             self.productCount = 0;
             //加载网络异常界面
             XQBLog(@"网络异常Error:%@", error);
             [self.view.window makeCustomToast:TOAST_NO_NETWORK];
         }];

}

- (void)requestCartsItemCount{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters addSignatureKey];
    WEAKSELF
    [manager GET:EC_CARTS_ITEMCOUNT_URL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.addToCartNumber = [[responseObject objectForKey:@"cartItemCount"] integerValue];
             if (self.addToCartNumber > 0) {
                 [weakSelf.shoppingCartButton setCustomBadgeValue:[NSString stringWithFormat:@"%ld",self.addToCartNumber] withFrame:CGRectMake(22, 2, 10, 10) withBackgroundColor:[UIColor orangeColor]];
             }else{
                 [self.shoppingCartButton deleteCustomBadge];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //加载网络异常界面
             XQBLog(@"网络异常Error:%@", error);
             
         }];
}

//关注度上报
- (void)requestReportProductFavor{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    [manager GET:EC_PRODUCT_FAVOR_URL(self.productId)
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                 
                 XQBLog(@"上报关注度成功");
                 
             }else{
                 //加载服务器异常界面
                 XQBLog(@"上报关注度失败");
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //加载网络异常界面
             XQBLog(@"网络异常Error:%@", error);
             
         }];
}
#pragma mark ---
- (void)popMallMoreView:(UIButton *)sender{
    if (!self.mallPopoverController) {
        
        NSMutableArray *items = [NSMutableArray array];
        NSArray *itemTitles = [NSArray arrayWithObjects:@"回到首页",@"闪购订单",@"收货地址", nil];
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
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self.mallPopoverController dismissPopoverAnimated:YES];
                    self.mallPopoverController.delegate = nil;
                    self.mallPopoverController = nil;
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
                    
                    XQBMeMyOrderViewController *orderVC = [[XQBMeMyOrderViewController alloc]init];
                    [self.navigationController pushViewController:orderVC animated:YES];
                     
                }
                    break;
                case 2:
                {
                    [self.mallPopoverController dismissPopoverAnimated:YES];
                    self.mallPopoverController.delegate = nil;
                    self.mallPopoverController = nil;
                    
                    if (![UserModel isLogin]) { //未登录弹出登录页面
                        [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
                        return;
                    }
                    
                    XQBECShippingAddressViewController *deliveryAddressVC = [[XQBECShippingAddressViewController alloc] init];
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

#pragma mark


- (void)buyNowButtonAction:(UIButton *)sender{
    
    [UIButton cancelPreviousPerformRequestsWithTarget:self selector:@selector(buyNowButtonAction:) object:sender];
    if (self.currentProductItemId.length == 0 || self.productCount == 0) {
        [self popProductMeasureView];
        return;
    }
    
    if (self.currentProductItemId == nil) {
        
    } else if (self.productCount == 0) {
        
    } else {
        if (![UserModel isLogin]) { //未登录弹出登录页面
            [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
            return;
        }
        
        XQBECBuyingOrderViewController *orderFormVC = [[XQBECBuyingOrderViewController alloc] init];
        orderFormVC.productItemID = self.currentProductItemId;
        orderFormVC.itemNumber = [NSString stringWithFormat:@"%ld", self.productCount];
        orderFormVC.entance = EntanceFromProductDetail;
        [self.navigationController pushViewController:orderFormVC animated:YES];
        
        self.currentProductItemId = nil;
        self.productCount = 0;
    }
    
}

- (void)addToShoppingCart:(UIButton *)sender{
    NSLog(@"加入购物车");
    if (self.currentProductItemId.length == 0 || self.productCount == 0) {
        [self popProductMeasureView];
        return;
    }
    [self requestAddShoppingCart];
}



#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)entryShoppingCartVC:(UIButton *)sender{
    if (![UserModel isLogin]) { //未登录弹出登录页面
        [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
        return;
    }
    
    XQBECShoppingCartViewController *shoppingCart = [[XQBECShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCart animated:YES];
}


#pragma mark ---tableView datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld-%ld-%@",indexPath.section,indexPath.row,identify]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (section == 0) {
            if (row == 0) {
                [cell addSubview:self.goodsNameLabel];
                [cell addSubview:self.goodsPriceLabel];
                [cell addSubview:self.oldPriceTitleLabel];
                [self.oldPriceLabel removeFromSuperview];
                [cell addSubview:self.oldPriceLabel];
                [cell addSubview:self.shippingFeeLabel];
                [cell addSubview:self.favorNumLabel];
                [cell addSubview:self.discountLabel];
                [cell addSubview:self.timeIconImageView];
                [cell addSubview:self.timeView];
                [cell addSubview:self.rushDateLabel];
                [cell addSubview:self.expressLabel];
                self.timeView.hidden = YES;
                self.timeIconImageView.hidden = YES;
                self.rushDateLabel.hidden = YES;
                if ([_productModel.tagType isEqualToString:kXQBProductTagTypeRushBuy]) { //限时抢购
                    
                    self.timeView.hidden = NO;
                    self.timeIconImageView.hidden = NO;
                    self.rushDateLabel.hidden = NO;
                    
                }else if ([_productModel.tagType isEqualToString:kXQBProductTagTypeLimitedBuy]){
                    
                }else if ([_productModel.tagType isEqualToString:kXQBProductTagTypeNew]){
                    
                }else if ([_productModel.tagType isEqualToString:kXQBProductTagTypeHot]){
                    
                }else if ([_productModel.tagType isEqualToString:kXQBProductTagNormal]){
                    
                }
                self.oldPriceLabel.text = [NSString stringWithFormat:@"%@",[PricesShown priceOfShorthand:[_productModel.oldPrice doubleValue]]];
                //[self.oldPriceLabel setNeedsDisplay];
                NSString *shippingFeeText = [NSString stringWithFormat:@"快递至 %@ : %@",_productModel.cityName,[PricesShown priceOfShorthand:[_productModel.shippingFee doubleValue]]];
                if([_productModel.isPostFree boolValue]){
                    shippingFeeText = [NSString stringWithFormat:@"快递至 %@ : %@",_productModel.cityName,@"免费"];
                }
                
                self.shippingFeeLabel.text = shippingFeeText;
                self.goodsNameLabel.text = _productModel.name;
                self.goodsPriceLabel.text = [NSString stringWithFormat:@"%@", [PricesShown priceOfShorthand:[_productModel.price doubleValue]]];
                self.favorNumLabel.text = [NSString stringWithFormat:@"关注度:%@",_productModel.favorNumber];
            }else if (row == 1) {
                [cell addSubview:self.goodsStandardLabel];
                cell.textLabel.textColor = RGB(102, 102, 102);
                cell.textLabel.text = @"已选:";
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [self refreshMeasure];
            }
        }else if (section == 1){
            if (row == 0) {
                cell.textLabel.textColor = RGB(102, 102, 102);
                cell.textLabel.text = @"商品详情";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }else if (section == 2){
            if (row == 0) {
                [cell addSubview:self.guessYouLoveLabel];
                self.guessYouLoveLabel.text = @"猜你喜欢的其它产品";
                
                [cell addSubview:self.maybeYouloveScrollView];
            }
            
        }else if (section == 3){
            
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 112.0f;
        }
    }else if (indexPath.section == 2){
        return 125.0f;
    }
    return 44.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    if (section >= 2) {
        
        __view.backgroundColor = tableView.backgroundColor;
        
    }else{
        __view.backgroundColor = RGB(244, 244, 244);
    }
    
    return __view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) { //商品规格
        [self popProductMeasureView];        
    }else if (indexPath.section == 1 && indexPath.row == 0){    //商品详情的web
        XQBECProductDetailWebViewController *viewController = [[XQBECProductDetailWebViewController alloc] init];
        viewController.detailUrl = _productModel.detailUrl;
        viewController.productName = _productModel.name;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


- (void)popProductMeasureView{
    SGGoodsStandardView *view = [[SGGoodsStandardView alloc] initWithTitle:_productModel.name image:self.productIamgeUrl itemTitles:self.productItems];
    view.productModel = self.productModel;
    view.buyNowHandle = ^(ECProductItemModel *productItem,NSInteger count){
        self.currentProductItemId = productItem.productItemId;
        self.productModel.measure = productItem.measure;
        self.productModel.price = productItem.price;
        self.productModel.oldPrice = productItem.oldPrice;
        self.productModel.discount = productItem.discount;
        self.productModel.stockCount = productItem.stockCount;
        self.productCount = count;
        [self refreshMeasure];
        [self buyNowButtonAction:nil];
    };
    view.addShoppingCartHanlde = ^(ECProductItemModel *productItem,NSInteger count){
        self.currentProductItemId = productItem.productItemId;
        self.productModel.measure = productItem.measure;
        self.productModel.price = productItem.price;
        self.productModel.oldPrice = productItem.oldPrice;
        self.productModel.discount = productItem.discount;
        self.productModel.stockCount = productItem.stockCount;
        self.productCount = count;
        [self refreshMeasure];
        [self requestAddShoppingCart];
    };
    view.confirmMeasureHandle = ^(ECProductItemModel *productItem,NSInteger count){
        self.currentProductItemId = productItem.productItemId;
        self.productModel.measure = productItem.measure;
        self.productModel.price = productItem.price;
        self.productModel.oldPrice = productItem.oldPrice;
        self.productModel.discount = productItem.discount;
        self.productModel.stockCount = productItem.stockCount;
        [self refreshMeasure];
    };
    [SGActionView showCustomView:view animation:YES];
    
    NSInteger maxValue;
    if ([self.productModel.tagType isEqualToString:kXQBProductTagTypeRushBuy] || [self.productModel.tagType isEqualToString:kXQBProductTagTypeLimitedBuy]) {
        maxValue = MIN([view.currentProductItem.stockCount integerValue], [self.productModel.limitedBuyNumber integerValue]);
    } else {
        maxValue = [view.currentProductItem.stockCount integerValue];
    }
    [view.changeCountComponent setMaximumValue:maxValue];
    [view.changeCountComponent setMinimumValue:0];
    view.changeCountComponent.achieveMaxValueBlock = ^(NSInteger tag, NSInteger count){
        if (count > [view.currentProductItem.stockCount integerValue]){
            
            [self.view.window makeCustomToast:@"库存量不足"];
        }else if (count > [self.productModel.limitedBuyNumber integerValue] && self.productModel.limitedBuyNumber > 0) {
            
            [self.view.window makeCustomToast:@"超出限购数量"];
        }
        
    };
    view.changeCountComponent.changeCountHandleBlock = ^(NSInteger tag, NSInteger count){
        
        if (count > [view.currentProductItem.stockCount integerValue]){
            [self.view.window makeCustomToast:@"库存量不足"];
        }else if (count > self.productModel.limitedBuyNumber  && self.productModel.limitedBuyNumber > 0) {
            [self.view.window makeCustomToast:@"超出限购数量"];
        }
    };
}

@end
