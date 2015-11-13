//
//  XQBMeMyNoticeViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/13.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeMyNoticeViewController.h"
#import "Global.h"
#import "XQBMeMyNoticeTableviewCell.h"
#import "HomeFeedsModel.h"
#import "XQBMeMyNoticeDetailViewController.h"
#import "AMTumblrHudRefreshTopView.h"
#import "AMTumblrHudRefreshBottomView.h"
#import "BlankPageView.h"

@interface XQBMeMyNoticeViewController () <UITableViewDelegate, UITableViewDataSource, RefreshControlDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RefreshControl *refreshControl;

@property (nonatomic, strong) BlankPageView *blankPageView;

@property (nonatomic, strong) NSMutableArray *myNoticeArray;

@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation XQBMeMyNoticeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _myNoticeArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _currentPage = 1;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"我的通知"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = XQBColorBackground;
    
    [self.view addSubview:self.tableView];
    
    [self requestUserNotifications];
    
    
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

#pragma mark --- ui
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - STATUS_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = XQBColorBackground;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
        _tableView.separatorColor = XQBColorInternalSeparationLine;
    }
    return _tableView;
}

//空白界面
- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        __weak typeof(self) weakself = self;
        _blankPageView.blankPageDidClickedBlock = ^(){
            weakself.currentPage = 1;
            [weakself requestUserNotifications];
        };
    }
    return _blankPageView;
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- AFNetWorking
- (void)requestUserNotifications
{
    [_blankPageView removeFromSuperview];
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+30)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currentPage] forKey:@"page"];
    [parameters addSignatureKey];
    
    [manager GET:API_USER_NOTIFICATIONS_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        [XQBLoadingView hideLoadingForView:self.view];
        if (_currentPage < 2) {
            [_myNoticeArray removeAllObjects];
        }
        
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            NSDictionary *data = [responseObject objectForKey:@"data"];

            NSArray *notifications = [data objectForKey:@"notifications"];
            for (NSDictionary *feedDic in notifications) {
                HomeFeedsModel *model = [[HomeFeedsModel alloc] init];
                model.feedId = [[feedDic objectForKey:@"id"] stringValue];
                model.title = DealWithJSONValue([feedDic objectForKey:@"title"]);
                model.time = DealWithJSONValue([feedDic objectForKey:@"time"]);
                model.detailUrl = DealWithJSONValue([feedDic objectForKey:@"detailUrl"]);
                
                [_myNoticeArray addObject:model];
            }
            
            if (_myNoticeArray.count > 0) {
                /* Animate the table view reload */
                
                NSDictionary *notificationPage = [data objectForKey:@"notificationPage"];
                if (_currentPage <= [[notificationPage objectForKey:@"totalPage"] integerValue]) {
                    _currentPage++;
                } else {
                    [self.view makeCustomToast:@"没有更多信息"];
                }
                
                [UIView transitionWithView: self.tableView
                                  duration: 0.35f
                                   options: UIViewAnimationOptionTransitionCrossDissolve
                                animations: ^(void)
                 {
                     [self.tableView reloadData];
                 }
                                completion: ^(BOOL isFinished)
                 {
                     /* TODO: Whatever you want here */
                 }];
                
            } else {
                //加载没有数据界面
                [self.view addSubview:self.blankPageView];
                [_blankPageView resetImage:[UIImage imageNamed:@"no_collection.png"]];
                [_blankPageView resetTitle:NO_DATA_NOTICE andDescribe:@""];
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
        [self requestUserNotifications];
        [XQBLoadingView hideLoadingForView:self.view];
    } else if (direction == RefreshDirectionBottom) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        });
        [self requestUserNotifications];
        [XQBLoadingView hideLoadingForView:self.view];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _myNoticeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"homeFeedsTableCell";
    XQBMeMyNoticeTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[XQBMeMyNoticeTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    HomeFeedsModel *model = ([_myNoticeArray count]>indexPath.section)?[_myNoticeArray objectAtIndex:indexPath.section]:nil;
    cell.iconView.image = [UIImage imageNamed:@"me_notification_button.png"];
    [cell.titleLabel setText:model.title];
    [cell.timeLabel setText:model.time];

    return cell;
}

#pragma mark --- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeFeedsModel *model = ([_myNoticeArray count]>indexPath.section)?[_myNoticeArray objectAtIndex:indexPath.section]:nil;
    
    XQBMeMyNoticeDetailViewController *noticeDetailVC = [[XQBMeMyNoticeDetailViewController alloc] init];
    noticeDetailVC.noticeTitle = model.title;
    noticeDetailVC.noticeDetailUrl = model.detailUrl;
    [self.navigationController pushViewController:noticeDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return XQBSpaceVerticalElement;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBSpaceVerticalElement)];
    backgroundView.backgroundColor = XQBColorBackground;
    
    return backgroundView;
}
@end
