//
//  XQBConDPCategoryListViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/30.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBConDPCategoryListViewController.h"
#import "Global.h"
#import "XQBBaseTableView.h"
#import "XQBConDPCategoryDetailViewController.h"
#import "XQBDZDPUrl.h"
#import "XQBCoreLBS.h"
#import "ConvenDZDPListModel.h"
#import "XQBConDPCategoryListTableViewCell.h"
#import "BlankPageView.h"
#import "AMTumblrHudRefreshTopView.h"
#import "AMTumblrHudRefreshBottomView.h"

@interface XQBConDPCategoryListViewController () <UITableViewDelegate, UITableViewDataSource, RefreshControlDelegate>

@property (nonatomic, strong) UIView *distanceView;
@property (nonatomic, strong) XQBBaseTableView *tableView;
@property (nonatomic, strong) UIImageView *DZDPIconView;
@property (nonatomic, strong) RefreshControl *refreshControl;

@property (nonatomic, strong) BlankPageView *blankPageView;

@property (nonatomic, strong) NSMutableArray *DZDPListArray;
@property (nonatomic ,strong) NSArray *distanceArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentDistanceIndex;

@end

@implementation XQBConDPCategoryListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentPage = 1;
        _currentDistanceIndex = 2;
        _DZDPListArray = [[NSMutableArray alloc] init];
        _distanceArray = [NSArray arrayWithObjects:@"500",@"1000",@"2000", @"5000",nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:_categoryName];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = XQBColorBackground;
    
    [self.view addSubview:self.distanceView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.DZDPIconView];
    
    [self setSelectedButton:_currentDistanceIndex];
    [self requestDPCategoryList];
    
    ///初始化
    _refreshControl=[[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    _refreshControl.autoRefreshTop = YES;
    ///注册自定义的下拉刷新view
    [_refreshControl registerClassForTopView:[AMTumblrHudRefreshTopView class]];
    [_refreshControl registerClassForBottomView:[AMTumblrHudRefreshBottomView class]];
    ///设置显示下拉刷新
    _refreshControl.topEnabled = YES;
    _refreshControl.bottomEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr --- ui
- (UIView *)distanceView
{
    if (!_distanceView) {
        _distanceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBHeightElement)];
        _distanceView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 20, MainWidth-XQBMarginHorizontal*2, 3)];
        lineView1.backgroundColor = RGB(200, 200, 200);
        [_distanceView addSubview:lineView1];
        
        for (int i=0; i<_distanceArray.count; i++) {
            UIButton *distanceButton = [[UIButton alloc] initWithFrame:CGRectMake(XQBMarginHorizontal+(MainWidth-XQBMarginHorizontal*2-23)/(_distanceArray.count - 1)*i, 10, 23, 23)];
            distanceButton.tag = i;
            [distanceButton setImage:[UIImage imageNamed:@"bg_convenience_unSelected.png"] forState:UIControlStateNormal];
            [distanceButton setImage:[UIImage imageNamed:@"bg_convenience_selected.png"] forState:UIControlStateSelected];
            [distanceButton addTarget:self action:@selector(distanceButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
            [_distanceView addSubview:distanceButton];
            
            UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(distanceButton)-XQBMarginHorizontal, Y(distanceButton)+HEIGHT(distanceButton), WIDTH(distanceButton)+XQBMarginHorizontal*2, XQBHeightElement-23-10)];
            distanceLabel.font = XQBFontExplain;
            distanceLabel.text = [NSString stringWithFormat:@"%@m", [_distanceArray objectAtIndex:i]];
            distanceLabel.textColor = RGB(141, 141, 141);
            distanceLabel.textAlignment = NSTextAlignmentCenter;
            [_distanceView addSubview:distanceLabel];
        }
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, XQBHeightElement-0.5, MainWidth, 0.5)];
        lineView2.backgroundColor = XQBColorElementSeparationLine;
        [_distanceView addSubview:lineView2];
    }
    return _distanceView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, XQBHeightElement, self.view.bounds.size.width, MainHeight-XQBHeightElement) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (UIImageView *)DZDPIconView
{
    if (!_DZDPIconView) {
        UIImage *apiImage = [UIImage imageNamed:@"bg_dpApi_logo.png"];
        _DZDPIconView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth-apiImage.size.width-10, MainHeight-10-apiImage.size.height, apiImage.size.width, apiImage.size.height)];
        [_DZDPIconView setImage:apiImage];
    }
    
    return _DZDPIconView;
}

//空白界面
- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, XQBHeightElement, MainWidth, MainHeight-XQBHeightElement)];
        __weak typeof(self) weakself = self;
        _blankPageView.blankPageDidClickedBlock = ^(){
            weakself.currentPage = 1;
            [weakself requestDPCategoryList];
        };
    }
    return _blankPageView;
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)distanceButtonHandle:(UIButton *)sender
{
    [_DZDPListArray removeAllObjects];
    [_tableView reloadData];
    self.currentPage = 1;
    self.currentDistanceIndex = sender.tag;
    [self setSelectedButton:sender.tag];
    [self requestDPCategoryList];
}

- (void)setSelectedButton:(NSInteger)index{
    for(UIButton *button in _distanceView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag == index){
                [button setSelected:YES];
            } else {
                [button setSelected:NO];
            }
        }
    }
}

#pragma mark --- AFNetworking
- (void)requestDPCategoryList
{
    [_blankPageView removeFromSuperview];
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+XQBHeightElement+30)];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *kDPUrlWithParameters = [NSString stringWithFormat:@"%@%@?category=%@&city=%@&latitude=%f&longitude=%f&sort=%d&limit=%d&offset_type=%d&out_offset_type=%d&platform=%d&radius=%@&page=%ld", kDPAPIDomain, DZDP_FIND_BUSINESSES,_categoryName, [XQBCoreLBS shareInstance].cityName, [XQBCoreLBS shareInstance].coordinate.latitude, [XQBCoreLBS shareInstance].coordinate.longitude, 7, 10, 1, 1, 2, [_distanceArray objectAtIndex:_currentDistanceIndex], (long)_currentPage];
    
    [manager GET:[XQBDZDPUrl serializeURL:kDPUrlWithParameters params:nil] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        [XQBLoadingView hideLoadingForView:self.view];
        if (_currentPage < 2) {
            [_DZDPListArray removeAllObjects];
        }
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"OK"]) {
            
            if (0 < [[responseObject objectForKey:@"count"] integerValue]) {
                _currentPage++;
            } else {
                [self.view makeCustomToast:@"没有更多信息"];
            }
            NSArray *listArray = [responseObject objectForKey:@"businesses"];
            
            for (NSDictionary *tempDic in listArray) {
                ConvenDZDPListModel *listData = [[ConvenDZDPListModel alloc]init];
                listData.businessIdString   = [[tempDic objectForKey:@"business_id"] stringValue];
                listData.nameString         = [tempDic objectForKey:@"name"];
                listData.addressString      = [tempDic objectForKey:@"address"];
                listData.telephoneString    = [tempDic objectForKey:@"telephone"];
                listData.cityString         = [tempDic objectForKey:@"city"];
                listData.categoriesArray    = [tempDic objectForKey:@"categories"];
                listData.latitudeString     = [[tempDic objectForKey:@"latitude"] stringValue];
                listData.longitudeString    = [[tempDic objectForKey:@"longitude"] stringValue];
                listData.avg_ratingString   = [[tempDic objectForKey:@"avg_rating"] stringValue];
                listData.distanceString     = [[tempDic objectForKey:@"distance"] stringValue];
                listData.s_photo_urlString  = [tempDic objectForKey:@"s_photo_url"];
                listData.regionsArray       = [tempDic objectForKey:@"regions"];
                listData.business_urlString = [tempDic objectForKey:@"business_url"];
                [_DZDPListArray addObject:listData];
            }
            if (_DZDPListArray.count > 0) {
                [_tableView reloadData];
            } else {
                //加载没有数据界面
                [self.view addSubview:self.blankPageView];
                [_blankPageView resetImage:[UIImage imageNamed:@"no_collection.png"]];
                [_blankPageView resetTitle:NO_DATA_DP_LIST andDescribe:@""];
            }
        } else {
            //加载服务器异常界面
            [self.view addSubview:self.blankPageView];
            [_blankPageView resetImage:[UIImage imageNamed:@"server_error.png"]];
            [_blankPageView resetTitle:SERVER_ERROR andDescribe:SERVER_ERROR_DESCRIBE];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [XQBLoadingView hideLoadingForView:self.view];
        [self.view addSubview:self.blankPageView];
        [_blankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
        [_blankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
    }];
}

#pragma mark --- RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (direction==RefreshDirectionTop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl finishRefreshingDirection:RefreshDirectionTop];
        });
        self.currentPage = 1;
        [self requestDPCategoryList];
        [XQBLoadingView hideLoadingForView:self.view];
    } else if (direction == RefreshDirectionBottom) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        });
        [self requestDPCategoryList];
        [XQBLoadingView hideLoadingForView:self.view];
    }
}

#pragma mark --- tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _DZDPListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConvenDZDPListModel *model = _DZDPListArray.count > indexPath.row ? [_DZDPListArray objectAtIndex:indexPath.row] : nil;
    
    static NSString *identify = @"identify";
    XQBConDPCategoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[XQBConDPCategoryListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.s_photo_urlString] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:cell.iconImageView.frame.size]];
    cell.titleLabel.text = model.nameString;
    cell.addressLabel.text = model.addressString;
    cell.disLabel.text = [NSString stringWithFormat:@"%@ m", model.distanceString];
    [cell setStarWithGrade:[model.avg_ratingString integerValue]];
    return cell;
}

#pragma mark --- tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConvenDZDPListModel *model = _DZDPListArray.count > indexPath.row ? [_DZDPListArray objectAtIndex:indexPath.row] : nil;
    
    XQBConDPCategoryDetailViewController *detailVC = [[XQBConDPCategoryDetailViewController alloc] init];
    detailVC.listItemModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
