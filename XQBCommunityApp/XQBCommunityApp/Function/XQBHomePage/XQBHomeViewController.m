//
//  XQBHomeViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBHomeViewController.h"
#import "Global.h"
#import "Pepar.h"
#import "CityMappingTable.h"
#import "UserModel.h"
#import "XQBSSHomeMenuCell.h"
#import "HomeFeedsModel.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "AdModel.h"
#import "XQBHomeAdsControl.h"
#import "XQBConvenienceMenu.h"
#import "XQBHomeIconItem.h"
#import "XQBHomeInformationListViewController.h"
#import "XQBFeedTypeMacros.h"
#import "XQBHomeIconMenu.h"
#import "XQBMeMyBillViewController.h"
#import "XQBMeMyNoticeViewController.h"
#import "XQBHomeIconWebViewController.h"
#import "XQBConDPCategoryListViewController.h"
#import "XQBHomeAroundShopViewController.h"
#import "XQBCustomServiceModel.h"
#import "MakePhoneCall.h"
#import "XQBMeSelectCityViewController.h"
#import "XQBLginViewController.h"
#import "NSFileManager+Community.h"
#import "XQBElectricalCemmerceViewController.h"
#import "XQBHomeFeedListViewController.h"
#import "HomeFeedsTableViewCell.h"
#import "XQBHomeAdWebViewController.h"
#import "MaskView.h"
#import "AMTumblrHudRefreshTopView.h"
#import "XQBLoginNavigationController.h"

//#define HOME_USER_INFO

#define XQB_HOME_MENU_CELL_HEIGHT   60

#define FEEDTYPE_COMMUNITY_NEWS     @"community_news"       //小区头条
#define FEEDTYPE_CITY_ACTIVITY      @"city_activity"        //同城活动
#define FEEDTYPE_HOT_TOPIC          @"hot_topic"            //热门话题
#define FEEDTYPE_CHATTING           @"chatting"             //侃大山
#define FEEDTYPE_ENCYCLOPEDIA       @"encyclopedia"         //生活百科
#define FEEDTYPE_EC                 @"ec"                   //特惠商品
#define FEEDTYPE_FLEA_MARKET        @"flea_market"          //跳蚤市场
#define FEEDTYPE_CAR_POOL           @"carpool"              //邻里拼车

#define HOMEICON_TYPE_WEB           @"web"
#define HOMEICON_TYPE_CLIENT        @"client"


static const CGFloat kHomeFeedsCellHeigth = 70.0f;

@interface XQBHomeViewController () <UITableViewDataSource,UITableViewDelegate,PeparActionDelegate,RefreshControlDelegate,UIActionSheetDelegate>{
    BOOL openFolderMenu;
    NSArray *buttonArray;
}
#ifdef HOME_USER_INFO
@property (nonatomic, strong) UIView *iconBackgroundView;
@property (nonatomic, strong) UIImageView *userIconImageView;
@property (nonatomic, strong) UILabel *communityAndCityLabel;
@property (nonatomic, strong) UILabel *timeAndTempLabel;
#endif
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Pepar *paperFolder;
@property (nonatomic, strong) UIView *paperFolderHolder;

@property (nonatomic, strong) UIView *tableViewHeaderView;

@property (nonatomic, strong) UIView *bottomBackgroundView;

@property (nonatomic, strong) NSMutableArray *homeFeedsArray;
@property (nonatomic, strong) NSMutableArray *homeIconArray;

//ads
@property (nonatomic, strong) NSMutableArray *adModels;
@property (nonatomic, strong) CycleScrollView *homeAdControl;
@property (nonatomic, strong) NSMutableArray *ads;

@property (nonatomic, strong) RefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) XQBHomeIconMenu *conMenu;

@property (nonatomic, strong) NSMutableArray *customServicePhoneArray;
@property (nonatomic, strong) XQBCustomServiceModel *propertyPhoneModel;

@property (nonatomic, strong) XQBLoginNavigationController *loginNavViewController;

@property (nonatomic, strong) NSMutableDictionary *homePageDic;

@property (nonatomic, strong) MaskView *maskView;

@end


@implementation XQBHomeViewController

- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = @"小区宝";
        _homeFeedsArray = [[NSMutableArray alloc] initWithCapacity:0];
        _adModels = [[NSMutableArray alloc] init];
        _homeIconArray = [[NSMutableArray alloc] init];
        _ads = [[NSMutableArray alloc] init];
        
        _customServicePhoneArray = [[NSMutableArray alloc] init];

        XQBCustomServiceModel *xqbCMModel = [[XQBCustomServiceModel alloc] init];
        xqbCMModel.title = XQB_CUSTOME_SERVICE;
        xqbCMModel.phoneNum = XQB_CUSTOME_SERVICE_PHONE_NUMBER;
        [_customServicePhoneArray addObject:xqbCMModel];

        _propertyPhoneModel = [[XQBCustomServiceModel alloc] init];
        _propertyPhoneModel.title = XQB_PROPERTY_CUSTOME_SERVICE;
        [_customServicePhoneArray addObject:_propertyPhoneModel];
        
        _loginNavViewController = [[XQBLoginNavigationController alloc] init];
        [self.navigationController addChildViewController:_loginNavViewController];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //如果折纸打开，页面消失关闭
    if (!openFolderMenu) {
        [self openMenu];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucceedNotice:) name:kXQBLoginSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCertificationSucceedNotice:) name:kXQBUserCertificationSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutSucceedNotice:) name:kXQBLogoutSucceedNotification object:nil];
    
    self.view.backgroundColor = [UIColor blackColor];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self refreshTitle];
    
    //右按钮
    UIButton *phoneCallButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [phoneCallButton setImage:[UIImage imageNamed:@"home_phone_icon.png"] forState:UIControlStateNormal];
    [phoneCallButton addTarget:self action:@selector(makePhoneHanle:) forControlEvents:UIControlEventTouchUpInside];
    phoneCallButton.frame = CGRectMake(0,0,60,44);
    [self setRightBarButtonItem:phoneCallButton];
    
    buttonArray = @[@"玩转小区宝",@"跳蚤市场",@"邻里拼车",@"邻居圈"];
    openFolderMenu = YES;
    [self.view addSubview:self.paperFolder];
    
    //paper folder menu的容器
    _paperFolderHolder = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_paperFolderHolder];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 60, 40);
    [menuButton setImage:[UIImage imageNamed:@"home_menu_play.png"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"home_menu_play.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(openMenuHandle:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setExclusiveTouch:YES];
    [self setBackBarButtonItem:menuButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    [self.paperFolder addGestureRecognizer:tapGesture];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - TABBAR_HEIGHT-STATUS_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = self.bottomBackgroundView;
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    //_tableView.tableHeaderView = self.tableViewHeaderView;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_paperFolderHolder addSubview:_tableView];
    
    NSArray *t1=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView":self.tableView}];
    NSArray *t2=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView":self.tableView}];
    
    [_paperFolderHolder addConstraints:t1];
    [_paperFolderHolder addConstraints:t2];
    
    ///初始化
    _refreshControl=[[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    _refreshControl.autoRefreshTop = YES;
    ///注册自定义的下拉刷新view
    [_refreshControl registerClassForTopView:[AMTumblrHudRefreshTopView class]];
    ///设置显示下拉刷新
    _refreshControl.topEnabled=YES;
    
    
    //先读取缓存
    NSString *cachePath = [self homePageCacheFilePath];
    self.homePageDic = [[NSMutableDictionary alloc] initWithContentsOfFile:cachePath];
    
    if (self.homePageDic && [self.homePageDic isKindOfClass:[NSDictionary class]]) {
        [self transformDataType];
    }

    [self requestHomePage];
}

- (void)refreshTitle{
    if ([UserModel shareUser].communityName.length > 0) {
        [self setNavigationTitle:[UserModel shareUser].communityName];
    }else{
        [self setNavigationTitle:@"小区宝"];
    }
}

#pragma mark --- UI
- (UIView *)tableViewHeaderView{
    if (_tableViewHeaderView == nil) {
        _tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 150)];
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 150)];
        [backgroundImage setImage:[UIImage imageNamed:@"home_background.png"]];
        [_tableViewHeaderView addSubview:backgroundImage];
        
#ifdef HOME_USER_INFO
        _iconBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(40, 150-110/2 + iconOffsetTop, 55, 55)];
        _iconBackgroundView.backgroundColor = [UIColor whiteColor];
        _iconBackgroundView.hidden = YES;
        [_tableViewHeaderView addSubview:_iconBackgroundView];
    
        _userIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 50, 50)];
        _userIconImageView.layer.cornerRadius = 3.0f;
        [_iconBackgroundView addSubview:_userIconImageView];
        
        _communityAndCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconBackgroundView.frame.origin.x+_iconBackgroundView.frame.size.width+7.5, _tableViewHeaderView.frame.size.height-XQBHeightLabelExplain*2-35/2+labelOffsetTop, MainWidth-XQBMarginHorizontal-_iconBackgroundView.frame.origin.x-_iconBackgroundView.frame.size.width-7.5, XQBHeightLabelExplain)];
        _communityAndCityLabel.font = XQBFontExplain;
        _communityAndCityLabel.textColor = [UIColor whiteColor];
        [_tableViewHeaderView addSubview:_communityAndCityLabel];
        
        _timeAndTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(_communityAndCityLabel.frame.origin.x, _communityAndCityLabel.frame.origin.y+_communityAndCityLabel.frame.size.height, _communityAndCityLabel.frame.size.width, XQBHeightLabelExplain)];
        _timeAndTempLabel.font = XQBFontExplain;
        _timeAndTempLabel.textColor = [UIColor whiteColor];
        [_tableViewHeaderView addSubview:_timeAndTempLabel];
#endif
        [_tableViewHeaderView addSubview:self.homeAdControl];
        
    }
    
    if ([self.homeIconArray count] > 0 ) {
        _tableViewHeaderView.frame = CGRectMake(0, 0, MainWidth, 150+180);
        [_tableViewHeaderView addSubview:self.conMenu];
    }else{
        _tableViewHeaderView.frame = CGRectMake(0, 0, MainWidth, 150);
        [self.conMenu removeFromSuperview];
    }
    
    return _tableViewHeaderView;
}

- (XQBHomeIconMenu *)conMenu{
    if (!_conMenu) {
        _conMenu = [[XQBHomeIconMenu alloc] initWithFrame:CGRectMake(0, 150, 320, 180)];
        WEAKSELF
        _conMenu.menuItemHandleBlock = ^(NSInteger index, XQBHomeIconItem *item){
            if ([item.type isEqualToString:HOMEICON_TYPE_WEB]) {
                XQBHomeIconWebViewController *viewController = [[XQBHomeIconWebViewController alloc] init];
                viewController.url = item.linkUrl;
                viewController.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
                
            }else if ([item.type isEqualToString:HOMEICON_TYPE_CLIENT]){
                
                [weakSelf homeIconHandleOnClient:item];
            }
            
        };
    }
    
    return _conMenu;
}

- (CycleScrollView *)homeAdControl{
    
    if (!_homeAdControl) {
        _homeAdControl = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 150) animationDuration:8.0];
    }
    
    return _homeAdControl;
}

#pragma mark --- blurView
- (MaskView *)maskView{
    if (!_maskView) {
        
         _maskView = [[MaskView alloc] initWithFrame:self.paperFolderHolder.bounds];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _maskView.bounds;
        [button addTarget:self action:@selector(closeFolderMenuHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:button];
    }
    
    return _maskView;
}

- (UIView *)bottomBackgroundView
{
    if (!_bottomBackgroundView) {
        _bottomBackgroundView = [[UIView alloc] initWithFrame:_tableView.frame];
        _bottomBackgroundView.backgroundColor = XQBColorBackground;
        UIImage *image = [UIImage imageNamed:@"bottom_background.png"];
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(_bottomBackgroundView)/2 - image.size.width/2, HEIGHT(_bottomBackgroundView)-image.size.height-10, image.size.width, image.size.height)];
        bottomImageView.image = image;
        [_bottomBackgroundView addSubview:bottomImageView];
    }
    return _bottomBackgroundView;
}

- (void)refreshAd{
    
    [self.ads removeAllObjects];
    
    //NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor]];
    
    for (AdModel *adInfo in self.adModels) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:adInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"default_rect_placeholder_image.png"]];
        [_ads addObject:imageView];
    }
    __weak typeof(self) weakSelf = self;
    self.homeAdControl.totalPagesCount = ^NSInteger(void){
        return weakSelf.ads.count;
    };
    self.homeAdControl.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return weakSelf.ads[pageIndex];
    };
    self.homeAdControl.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",pageIndex);
        
        AdModel *model = (weakSelf.adModels.count>pageIndex)?[weakSelf.adModels objectAtIndex:pageIndex]:nil;        
        if (model.link.length > 0) {
            XQBHomeAdWebViewController *viewController = [[XQBHomeAdWebViewController alloc] init];
            viewController.adModel = model;
            viewController.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        }
    };

}

- (void)refreshHomeIcons{
    
    [self.conMenu setMenuItems:_homeIconArray];
}

#pragma mark --- --- life style
- (Pepar *)paperFolder{    
    if (!_paperFolder) {
        _paperFolder = [[Pepar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, XQB_HOME_MENU_CELL_HEIGHT*[buttonArray count]) WithCount:[buttonArray count] WithCellHeight:XQB_HOME_MENU_CELL_HEIGHT WithDelegate:self];
        _paperFolder.animationTiming = 0.5;
    }
    
    return _paperFolder;
}

#pragma mark --- action
- (void)openMenuHandle:(UIButton *)sender
{
    [self openMenu];
}

- (void)closeFolderMenuHandle:(UIButton *)sender{
    [self openMenu];
}

- (void)makePhoneHanle:(UIButton *)sender{
    XQBCustomServiceModel *xqbPhoneModel = [self.customServicePhoneArray objectAtIndex:0];
    UIActionSheet *sheet = nil;
    
    if (self.propertyPhoneModel.phoneNum.length == 0) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:xqbPhoneModel.title, nil];
        
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:xqbPhoneModel.title,self.propertyPhoneModel.title, nil];
    }
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self.view.window];
}

- (void)homeIconHandleOnClient:(XQBHomeIconItem *)item{
    if ([item.category isEqualToString:XQB_FEED_TYPE_BILL_PAY]) {
        if (![UserModel isLogin]) { //未登录弹出登录页面
            [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
            return;
        }
        
        //完善资料
        if ([[UserModel shareUser].userType isEqualToString:XQB_USER_IDENTIFY_RESIDENT]) {
            XQBMeMyBillViewController *myBillVC = [[XQBMeMyBillViewController alloc] init];
            myBillVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myBillVC animated:YES];
        } else {
            XQBMeSelectCityViewController *viewController = [[XQBMeSelectCityViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.hiddenNavigationBarWhenPoped = NO;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }else if ([item.category isEqualToString:XQB_FEED_TYPE_NOTICE]) {
        if (![UserModel isLogin]) { //未登录弹出登录页面
            [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
            return;
        }
        
        //完善资料
        if ([[UserModel shareUser].userType isEqualToString:XQB_USER_IDENTIFY_RESIDENT]) {
            XQBMeMyNoticeViewController *myNoticeVC = [[XQBMeMyNoticeViewController alloc] init];
            myNoticeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myNoticeVC animated:YES];
        } else {
            XQBMeSelectCityViewController *viewController = [[XQBMeSelectCityViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.hiddenNavigationBarWhenPoped = NO;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }else if ([item.category isEqualToString:XQB_FEED_TYPE_FLEA_MARKET]) {  //跳蚤市场
        XQBHomeInformationListViewController *viewController = [[XQBHomeInformationListViewController alloc] init];
        viewController.homeFeedMark = XQB_FEED_MARK_ALL;
        viewController.homeFeedType = XQB_FEED_TYPE_FLEA_MARKET;
        viewController.homeFeedName = XQB_FEED_NAME_FLEA_MARKET;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if ([item.category isEqualToString:XQB_FEED_TYPE_CARPOOL]) {      //拼车
        XQBHomeInformationListViewController *viewController = [[XQBHomeInformationListViewController alloc] init];
        viewController.homeFeedMark = XQB_FEED_MARK_ALL;
        viewController.homeFeedType = XQB_FEED_TYPE_CARPOOL;
        viewController.homeFeedName = XQB_FEED_NAME_CARPOOL;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if ([item.category isEqualToString:XQB_FEED_TYPE_SHOP]) {         //周边小店
        XQBHomeAroundShopViewController *viewController = [[XQBHomeAroundShopViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else if ([item.category isEqualToString:XQB_FEED_TYPE_NEIGHBORS_HOME]) {   //邻居圈
        XQBHomeInformationListViewController *viewController = [[XQBHomeInformationListViewController alloc] init];
        viewController.homeFeedMark = XQB_FEED_MARK_ALL;
        viewController.homeFeedType = XQB_FEED_TYPE_CARPOOL;
        viewController.homeFeedName = XQB_FEED_NAME_CARPOOL;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else if ([item.category isEqualToString:XQB_FEED_TYPE_SHIPPING_SERVICE]) { //
        
        XQBConDPCategoryListViewController *listVC = [[XQBConDPCategoryListViewController alloc] init];
        listVC.categoryName = XQB_FEED_NAME_SHIPPING_SERVICE;
        listVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listVC animated:YES];
        
    }else if ([item.category isEqualToString:XQB_FEED_TYPE_KOUSE_KEEPING_CLEAN]) {
        XQBConDPCategoryListViewController *listVC = [[XQBConDPCategoryListViewController alloc] init];
        listVC.categoryName = XQB_FEED_NAME_KOUSE_KEEPING_CLEAN;
        listVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listVC animated:YES];
        
    }else if ([item.category isEqualToString:XQB_FEED_TYPE_OUTPTIENT_PHARMACY]) {
        XQBConDPCategoryListViewController *listVC = [[XQBConDPCategoryListViewController alloc] init];
        listVC.categoryName = XQB_FEED_NAME_OUTPTIENT_PHARMACY;
        listVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listVC animated:YES];
        
    }else if ([item.category isEqualToString:XQB_FEED_TYPE_BOOK_MOVIE_TICKET]) {
        XQBConDPCategoryListViewController *listVC = [[XQBConDPCategoryListViewController alloc] init];
        listVC.categoryName = XQB_FEED_NAME_BOOK_MOVIE_TICKET;
        listVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listVC animated:YES];
        
    }else if ([item.category isEqualToString:XQB_FEED_TYPE_RENT_AND_SELL_HOUSE]) {
        XQBConDPCategoryListViewController *listVC = [[XQBConDPCategoryListViewController alloc] init];
        listVC.categoryName = XQB_FEED_NAME_RENT_AND_SELL_HOUSE;
        listVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listVC animated:YES];
        
    }
    
}

#pragma mark --- AFNetworking request
- (void)requestHomePage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters addSignatureKey];
    [manager GET:API_HOME_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            NSMutableDictionary *dataDic = [responseObject objectForKey:@"data"];
            
            NSString *cacheFilePath = [self homePageCacheFilePath];
            BOOL result = [dataDic writeToFile:cacheFilePath atomically:YES];
            if (result) {
                XQBLog(@"缓存成功");
            }
            self.homePageDic = dataDic;
            [self transformDataType];
        } else {
            //加载服务器异常界面
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
    }];
}


- (void)transformDataType{
    
    [self.homeIconArray removeAllObjects];
    [self.adModels removeAllObjects];
    [self.homeFeedsArray removeAllObjects];
    

#ifdef HOME_USER_INFO
    _iconBackgroundView.hidden = NO;
    [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[[dataDic objectForKey:@"user"] objectForKey:@"icon"]] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:_userIconImageView.frame.size]];
    [_communityAndCityLabel setText:[NSString stringWithFormat:@"%@, %@", [[dataDic objectForKey:@"location"] objectForKey:@"communityName"], [[dataDic objectForKey:@"location"] objectForKey:@"cityName"]]];
    [_timeAndTempLabel setText:[NSString stringWithFormat:@"%@, %@", [[dataDic objectForKey:@"location"] objectForKey:@"currentTime"], [[dataDic objectForKey:@"location"] objectForKey:@"temperature"]]];
#endif
    NSMutableDictionary *dataDic = self.homePageDic;
    //内容列表
    NSArray *feedsDic = [dataDic objectForKey:@"feeds"];
    for (NSDictionary *feedDic in feedsDic) {
        HomeFeedsModel *model = [[HomeFeedsModel alloc] init];
        model.feedId = [[feedDic objectForKey:@"feedId"] stringValue];
        model.feedType = [feedDic objectForKey:@"feedType"];
        model.linkId = [[feedDic objectForKey:@"linkId"] stringValue];
        model.title = DealWithJSONValue([feedDic objectForKey:@"title"]);
        model.icon = DealWithJSONValue([feedDic objectForKey:@"icon"]);
        model.time = DealWithJSONValue([feedDic objectForKey:@"time"]);
        model.content = DealWithJSONValue([feedDic objectForKey:@"content"]);
        model.commentCount = DealWithJSONValue([feedDic objectForKey:@"commentCount"]);
        model.likeCount = DealWithJSONValue([feedDic objectForKey:@"likeCount"]);
        model.isLiked = DealWithJSONValue([feedDic objectForKey:@"isLiked"]);
        model.images =  [feedDic objectForKey:@"images"];
        model.feedCity = [feedDic objectForKey:@"feedCity"];
        [_homeFeedsArray addObject:model];
    }
    
    
    NSArray *adArray = [dataDic objectForKey:@"ads"];
    
    for (NSDictionary *adInfo in adArray) {
        AdModel *adModel = [[AdModel alloc] init];
        adModel.adId = [[adInfo objectForKey:@"adId"] stringValue];
        adModel.imageUrl = DealWithJSONValue([adInfo objectForKey:@"image"]);
        adModel.link = DealWithJSONValue([adInfo objectForKey:@"link"]);
        adModel.title = DealWithJSONValue([adInfo objectForKey:@"title"]);
        [self.adModels addObject:adModel];
    }
    
    NSArray *homeIcons = [dataDic objectForKey:@"homeIcons"];
    
    for (NSDictionary *homeIconDic in homeIcons) {
        XQBHomeIconItem *item = [[XQBHomeIconItem alloc] init];
        item.title = [homeIconDic objectForKey:@"title"];
        item.imageUrl = [homeIconDic objectForKey:@"icon"];
        item.linkUrl = [homeIconDic objectForKey:@"linkUrl"];
        item.type = [homeIconDic objectForKey:@"type"];
        item.createId = [[homeIconDic objectForKey:@"createId"] stringValue];
        item.itemId = [[homeIconDic objectForKey:@"id"] stringValue];
        item.category = [homeIconDic objectForKey:@"category"];
        
        [_homeIconArray addObject:item];
    }
    

    
    NSString *propertyPhone = DealWithJSONValue([dataDic objectForKey:@"telephone"]);
    if (propertyPhone.length > 0) {
        _propertyPhoneModel.phoneNum = propertyPhone;
    }else{
        _propertyPhoneModel.phoneNum = nil;
    }
    
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    [self refreshAd];
    [self refreshHomeIcons];
    
    if (_homeFeedsArray.count > 0) {
        
        [self.tableView reloadData];
        
    } else {
        //加载没有数据界面
    }

}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        //去掉UItableview的section的headerview黏性
        CGFloat sectionHeaderHeight = XQBSpaceVerticalElement;
        
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark --- UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_homeFeedsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"homeFeedsTableCell";
    HomeFeedsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[HomeFeedsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    HomeFeedsModel *model = ([self.homeFeedsArray count]>indexPath.row)?[self.homeFeedsArray objectAtIndex:indexPath.row]:nil;
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:cell.iconView.frame.size]];
    [cell.titleLabel setText:model.title];
    [cell.timeLabel setText:model.time];
    [cell.contentLabel setText:model.content];

    return cell;
}

#pragma mark --- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHomeFeedsCellHeigth;

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
#ifdef __IPHONE_8_0
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
#endif
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    HomeFeedsModel *model = ([self.homeFeedsArray count]>indexPath.row)?[self.homeFeedsArray objectAtIndex:indexPath.row]:nil;
    if (model) {
        
        if ([model.feedType isEqualToString:FEEDTYPE_EC]) {                 //特惠商品
            
            XQBElectricalCemmerceViewController *viewController = [[XQBElectricalCemmerceViewController alloc] init];
            viewController.hiddenBackBarItem = NO;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }else if ([model.feedType isEqualToString:FEEDTYPE_CAR_POOL]){      //邻里拼车
            
            XQBHomeInformationListViewController *infoListVC = [[XQBHomeInformationListViewController alloc] init];
            infoListVC.homeFeedMark = XQB_FEED_MARK_ALL;
            infoListVC.homeFeedType = XQB_FEED_TYPE_CARPOOL;
            infoListVC.homeFeedName = XQB_FEED_NAME_CARPOOL;
            infoListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoListVC animated:YES];
            
        }else if ([model.feedType isEqualToString:FEEDTYPE_FLEA_MARKET]){   //跳蚤市场
            
            XQBHomeInformationListViewController *infoListVC = [[XQBHomeInformationListViewController alloc] init];
            infoListVC.homeFeedMark = XQB_FEED_MARK_ALL;
            infoListVC.homeFeedType = XQB_FEED_TYPE_FLEA_MARKET;
            infoListVC.homeFeedName = XQB_FEED_NAME_FLEA_MARKET;
            infoListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoListVC animated:YES];
        
        }else if ([model.feedType isEqualToString:FEEDTYPE_COMMUNITY_NEWS] ||           //小区头条
                  [model.feedType isEqualToString:FEEDTYPE_CITY_ACTIVITY] ||            //同城活动
                  [model.feedType isEqualToString:FEEDTYPE_HOT_TOPIC] ||                //热门话题
                  [model.feedType isEqualToString:FEEDTYPE_CHATTING] ||                 //侃大山
                  [model.feedType isEqualToString:FEEDTYPE_ENCYCLOPEDIA])               //生活百科
        {
            XQBHomeFeedListViewController *viewController = [[XQBHomeFeedListViewController alloc] init];
            viewController.feedModel = model;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
}



#pragma mark --- PeparActionDelegate
- (void)openMenu
{
    [self.paperFolder startAnimationWithOpen:openFolderMenu];
    if (openFolderMenu) {
        [self.paperFolderHolder addSubview:self.maskView];
        self.maskView.alpha = 0.1;
        [self.homeAdControl pauserTimer];
        [UIView animateWithDuration:self.paperFolder.animationTiming animations:^{
            /*
            CAKeyframeAnimation *aCAKeyframeAnimationButton = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            NSMutableArray *keyAnimationButtonArray = [[NSMutableArray alloc] init];
            for (int j = 100; j>=0; j--) {
                [keyAnimationButtonArray addObject:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, XQB_HOME_MENU_CELL_HEIGHT*(self.paperFolder.count)*sin(M_PI/200*(100-j)), 0)]];
            }
            [aCAKeyframeAnimationButton setValues:keyAnimationButtonArray];
            [aCAKeyframeAnimationButton setDuration:self.paperFolder.animationTiming];
            [aCAKeyframeAnimationButton setRemovedOnCompletion:NO];
            [aCAKeyframeAnimationButton setFillMode:kCAFillModeForwards];
            [aCAKeyframeAnimationButton setDelegate:self];
            [self.paperFolderHolder.layer addAnimation:aCAKeyframeAnimationButton forKey:@"position"];
             */
            
            [self.maskView resetBackgroundColor];
            self.paperFolderHolder.frame = CGRectMake(0, CGRectGetMaxY(self.paperFolder.frame), self.paperFolderHolder.frame.size.width, self.paperFolderHolder.frame.size.height);
        }];
        
        
    }else
    {
        [UIView animateWithDuration:self.paperFolder.animationTiming
                         animations:^{
                             self.paperFolderHolder.frame = self.view.bounds;
                             self.maskView.alpha = 0.1;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [self.maskView removeFromSuperview];
                                 [self.homeAdControl resumeTimer];
                             }
                         }];
    }
    
}

- (void)openSuccess
{
    openFolderMenu = NO;
}

- (void)closeSuccess
{
    openFolderMenu = YES;
}

- (UIColor *)CellColorWith:(NSInteger)index
{
    if (index == 0) {
        return RGB(75, 200, 160);
    }else{
        if (index%2 == 0) {
            return RGB(250, 250, 250);
        }else
        {
            return RGB(235, 235, 235);
        }
    }
}


- (UIImage *)cellImageWith:(NSInteger)index{
    switch (index) {
        case 0:
            return nil;
            break;
        case 1:
            return [UIImage imageNamed:@"home_menu_fleamarket_icon.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"home_menu_carsharing_icon.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"home_menu_neighbour_icon.png"];
            break;
            
        default:
            break;
    }
    
    return nil;
}


- (UIImage *)cellAccessoryImageWith:(NSInteger)index{
    switch (index) {

        case 0:
            return [UIImage imageNamed:@"home_menu_play_close.png"];
            break;
        case 1:
        case 2:
        case 3:
            return [UIImage imageNamed:@"right_arrow_whitegray.png"];
            break;
            
        default:
            break;
    }
    
    return nil;
}


- (UIView *)factoryCellWithView:(UIView *)view WithIndex:(NSInteger)index
{
    XQBSSHomeMenuCell *cell = [[XQBSSHomeMenuCell alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [cell.layer setMasksToBounds:YES];
    [cell.imageView setImage:[self cellImageWith:index]];
    [cell.textLabel setText:[buttonArray objectAtIndex:index]];
    if (index == 0) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = XQBFontHeadline;
    }
    cell.accessoryView.image = [self cellAccessoryImageWith:index];
    [view addSubview:cell];
    [cell setBackgroundColor:[self CellColorWith:index]];
    
    return view;
}


- (void)tapGestureHandle:(UITapGestureRecognizer *)sender{
    CGPoint touchPoint = [sender locationInView:self.paperFolder];
    NSInteger indexCell = touchPoint.y / XQB_HOME_MENU_CELL_HEIGHT;
    
    XQBHomeInformationListViewController *infoListVC = [[XQBHomeInformationListViewController alloc] init];
    infoListVC.homeFeedMark = XQB_FEED_MARK_ALL;
    switch (indexCell) {
        case 0: {     //玩转小区宝
            [self openMenu];
            return;
        } case 1: {     //跳蚤市场
            infoListVC.homeFeedType = XQB_FEED_TYPE_FLEA_MARKET;
            infoListVC.homeFeedName = XQB_FEED_NAME_FLEA_MARKET;
            break;
        } case 2: {    //邻里拼车
            infoListVC.homeFeedType = XQB_FEED_TYPE_CARPOOL;
            infoListVC.homeFeedName = XQB_FEED_NAME_CARPOOL;
            break;
        } case 3: {    //邻居圈
            infoListVC.homeFeedType = XQB_FEED_TYPE_NEIGHBORS_HOME;
            infoListVC.homeFeedName = XQB_FEED_NAME_NEIGHBORS_HOME;
            break;
        } default:
            break;
    }
    infoListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoListVC animated:YES];
}


- (void)clickButtonWithIndex:(NSInteger)index
{
    /*
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"alertView" message:[NSString stringWithFormat:@"touch cell With index %ld",index+1] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
     */
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

#pragma mark    ---RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (direction==RefreshDirectionTop)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl finishRefreshingDirection:RefreshDirectionTop];
        });
        [self requestHomePage];
        [XQBLoadingView hideLoadingForView:self.view];
    }
}

#pragma mark ---UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if ([actionSheet cancelButtonIndex] != buttonIndex) {
        [self makePhoneCall:buttonIndex];
    }
}

- (void)makePhoneCall:(NSInteger)index{
    
    XQBCustomServiceModel *model =  ([self.customServicePhoneArray count] > index)?[self.customServicePhoneArray objectAtIndex:index]:nil;
    MakePhoneCall *instance = [MakePhoneCall getInstance];
    BOOL call_ok = [instance makeCall:model.phoneNum];
    
    if (call_ok) {
        //上报
    }else{
        MsgBox(@"设备不支持电话功能");
    }
}


#pragma mark --- noticefication
- (void)userLoginSucceedNotice:(NSNotification *)notice{
    [self refreshTitle];
    [self requestHomePage];
}

- (void)userCertificationSucceedNotice:(NSNotification *)notice{
    [self refreshTitle];
    [self requestHomePage];
}

- (void)userLogoutSucceedNotice:(NSNotification *)notice{
    [self refreshTitle];
    [self requestHomePage];
}

#pragma mark ---file read and write

- (NSString *)homePageCacheFilePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [fileManager applicationLibraryDirectory];
    NSString *filePath = [path stringByAppendingPathComponent:XQBHomePageCacheFile];
    
    return filePath;
}

@end
