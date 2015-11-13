//
//  XQBConvenienceViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBConvenienceViewController.h"
#import "Global.h"
#import "XQBConCategoryTableViewCell.h"
#import "XQBBaseTableView.h"
#import "XQBConvenienceMenu.h"
#import "XQBConDetailWebViewController.h"
#import "ConvenienceListModel.h"
#import "XQBDZDPUrl.h"
#import "XQBConDPCategoryListViewController.h"

static NSString *identify = @"identify";

@interface XQBConvenienceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) XQBConvenienceMenu *conMenu;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) UIView *bottomBackgroundView;


@property (nonatomic, strong) NSMutableArray *menuItems;

@property (nonatomic, strong) NSMutableArray *convenienceListArray;

@end

@implementation XQBConvenienceViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self initalize];
    }
    
    return self;
}

- (void)initalize{
    XQBConvenienceMenuItem *foodItem = [[XQBConvenienceMenuItem alloc] init];
    foodItem.image = @"con_menu_food_icon.png";
    foodItem.title = @"美食";
    
    XQBConvenienceMenuItem *hotelItem = [[XQBConvenienceMenuItem alloc] init];
    hotelItem.image = @"con_menu_hotel_icon.png";
    hotelItem.title = @"酒店";
    
    XQBConvenienceMenuItem *parentChildItem = [[XQBConvenienceMenuItem alloc] init];
    parentChildItem.image = @"con_menu_parentchild_icon.png";
    parentChildItem.title = @"亲子";
    
    XQBConvenienceMenuItem *entertainmentItem = [[XQBConvenienceMenuItem alloc] init];
    entertainmentItem.image = @"con_menu_entertainment_icon.png";
    entertainmentItem.title = @"休闲娱乐";
 
    XQBConvenienceMenuItem *houseKeepingItem = [[XQBConvenienceMenuItem alloc] init];
    houseKeepingItem.image = @"con_menu_housekeeping_icon.png";
    houseKeepingItem.title = @"家政";
    
    XQBConvenienceMenuItem *expressItem = [[XQBConvenienceMenuItem alloc] init];
    expressItem.image = @"con_menu_express_icon.png";
    expressItem.title = @"物流快递";
    
    XQBConvenienceMenuItem *unlockItem = [[XQBConvenienceMenuItem alloc] init];
    unlockItem.image = @"con_menu_sports_icon.png";
    unlockItem.title = @"运动健身";

    XQBConvenienceMenuItem *medicalItem = [[XQBConvenienceMenuItem alloc] init];
    medicalItem.image = @"con_menu_medical_icon.png";
    medicalItem.title = @"医院";
    
    //初始化便民类别菜单
    _menuItems = [[NSMutableArray alloc] initWithObjects:foodItem,hotelItem,parentChildItem,
    entertainmentItem,houseKeepingItem,expressItem,unlockItem,medicalItem,nil];
    _convenienceListArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"便民"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucceedNotice:) name:kXQBLoginSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCertificationSucceedNotice:) name:kXQBUserCertificationSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutSucceedNotice:) name:kXQBLogoutSucceedNotification object:nil];
    
    self.view.backgroundColor = XQBColorBackground;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[XQBConCategoryTableViewCell class] forCellReuseIdentifier:identify];
    
    [self requestConvenienceList];
}

#pragma makr --- ui
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-TABBAR_HEIGHT-STATUS_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = self.bottomBackgroundView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}


- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 190)];
        
        _conMenu = [[XQBConvenienceMenu alloc] initWithItmes:self.menuItems];
        WEAKSELF
        _conMenu.menuItemHandleBlock = ^(NSInteger index, NSString *menuItemTitle){
            [weakSelf enjoyLifeWithCategory:menuItemTitle];
        };
        
        [_tableHeaderView addSubview:_conMenu];
    }
    return _tableHeaderView;
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

#pragma mark --- AFNetwork
- (void)requestConvenienceList
{
    [XQBLoadingView showLoadingAddedToView:_tableView withOffset:UIOffsetMake(0, -HEIGHT(_tableView)/2+175+30)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    [manager GET:API_LIFE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        [XQBLoadingView hideLoadingForView:_tableView];
        [_convenienceListArray removeAllObjects];
        
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            
            NSArray *lifeArray = [dataDic objectForKey:@"life"];
            for (NSDictionary *dic in lifeArray) {
                ConvenienceListModel *model = [[ConvenienceListModel alloc] init];
                model.linkId    = [[dic objectForKey:@"linkId"] stringValue];
                model.lifeId    = [[dic objectForKey:@"id"] stringValue];
                model.isLiked   = [[dic objectForKey:@"isLiked"] stringValue];
                model.likeCount = [[dic objectForKey:@"likeCount"] stringValue];
                model.desc      = DealWithJSONValue([dic objectForKey:@"desc"]);
                model.type      = DealWithJSONValue([dic objectForKey:@"type"]);
                model.icon      = DealWithJSONValue([dic objectForKey:@"icon"]);
                model.lifeTitle = DealWithJSONValue([dic objectForKey:@"title"]);
                
                [_convenienceListArray addObject:model];
            }
            if (_convenienceListArray.count > 0) {
                [_tableView reloadData];
            }
        } else {
            //加载服务器异常界面
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [XQBLoadingView hideLoadingForView:_tableView];
    }];
}

#pragma mark --- tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _convenienceListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConvenienceListModel *model = _convenienceListArray.count > indexPath.row ? [_convenienceListArray objectAtIndex:indexPath.row] : nil;
    
    XQBConCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    if (!cell) {
        cell = [[XQBConCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSInteger categoryType = indexPath.row%2;
    if (categoryType == 0) {
        cell.categoryCellType = XQBConCategoryTableViewCellTypeValue1;
    }else if (categoryType == 1){
        cell.categoryCellType = XQBConCategoryTableViewCellTypeValue2;
    }    

    [cell.categoryImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:cell.categoryImageView.frame.size]];
    cell.categoryTitleLabel.text = model.lifeTitle;
    cell.categoryDescriptionLabel.text = model.desc;
    return cell;
}

#pragma mark --- tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConvenienceListModel *model = _convenienceListArray.count > indexPath.row ? [_convenienceListArray objectAtIndex:indexPath.row] : nil;
    
    XQBConDetailWebViewController *detailVC = [[XQBConDetailWebViewController alloc] init];
    detailVC.lifeId = model.linkId;
    detailVC.lifeTitle = model.lifeTitle;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark --- 便民菜单
- (void)enjoyLifeWithCategory:(NSString *)category
{
    XQBConDPCategoryListViewController *listVC = [[XQBConDPCategoryListViewController alloc] init];
    listVC.categoryName = category;
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark --- notification

- (void)userCertificationSucceedNotice:(NSNotification *)notice{
    [self requestConvenienceList];
}

- (void)userLoginSucceedNotice:(NSNotification *)notice{
    [self requestConvenienceList];
}

- (void)userLogoutSucceedNotice:(NSNotification *)notice{
    [self requestConvenienceList];
}

@end
