//
//  XQBHomeFeedListViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/12.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBHomeFeedListViewController.h"
#import "Global.h"
#import "HomeFeedSectionModel.h"
#import "XQBHomeFeedListTableViewCell.h"
#import "XQBHomeFeedDetailViewController.h"

@interface XQBHomeFeedListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation XQBHomeFeedListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:self.feedModel.title];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self.view addSubview:self.tableView];
    
    [self requestHomeFeedList];
}

#pragma mark --- ui
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)-STATUS_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
    }
    
    return _tableView;
}

#pragma mark --- action

- (void)backHandle:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- network

- (void)requestHomeFeedList{
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+30)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:self.feedModel.feedType forKey:@"category"];
    [parameters setObject:self.feedModel.feedCity forKey:@"feedCity"];
    [parameters setObject:self.feedModel.feedId   forKey:@"homeFeedId"];
    
    [manager GET:API_HOME_FEED_LIST parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [_dataSource removeAllObjects];
             [XQBLoadingView hideLoadingForView:self.view];
             if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]){
                 NSArray *sectionArray = [responseObject objectForKey:@"data"];
                 for (NSDictionary *sectionDic in sectionArray) {
                     HomeFeedSectionModel *feedSectionModel = [[HomeFeedSectionModel alloc] init];
                     feedSectionModel.ptime = DealWithJSONValue([sectionDic objectForKey:@"ptime"]);
                     [self.dataSource addObject:feedSectionModel];
                     
                     NSArray *homeFeedDetails = [sectionDic objectForKey:@"homeFeedDetails"];
                     
                     for (NSDictionary *homeFeedDetailDic in homeFeedDetails) {
                         XQBHomeFeedDetailModel *feedDetailModel = [[XQBHomeFeedDetailModel alloc] init];
                         feedDetailModel.title = DealWithJSONValue([homeFeedDetailDic objectForKey:@"title"]);
                         feedDetailModel.feedIcon = DealWithJSONValue([homeFeedDetailDic objectForKey:@"icon"]);
                         feedDetailModel.setDefault = DealWithJSONValue([homeFeedDetailDic objectForKey:@"setDefault"]);
                         feedDetailModel.detailUrl = DealWithJSONValue([homeFeedDetailDic objectForKey:@"detailUrl"]);
                         feedDetailModel.feedType = DealWithJSONValue([homeFeedDetailDic objectForKey:@"feedType"]);
                         feedDetailModel.feedCategory = self.feedModel.title;
                         
                         feedDetailModel.feedId = [[homeFeedDetailDic objectForKey:@"id"] stringValue];
                         feedDetailModel.isLiked = [[homeFeedDetailDic objectForKey:@"isLiked"] stringValue];
                         feedDetailModel.likeCount = [[homeFeedDetailDic objectForKey:@"likeCount"] stringValue];
                         feedDetailModel.commentCount = [[homeFeedDetailDic objectForKey:@"commentCount"] stringValue];
                         
                         if ([feedDetailModel.setDefault isEqualToString:@"yes"]) {
                             [feedSectionModel.homeFeedDetails insertObject:feedDetailModel atIndex:0];
                         }else{
                             [feedSectionModel.homeFeedDetails addObject:feedDetailModel];
                         }
                     }
                 }
                 [self.tableView reloadData];
             }else{
                 
             }
             
             if ([self.dataSource count]>=1) {
                 [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:([self.dataSource count]-1)] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             XQBLog(@"网络异常%@",error);
             [XQBLoadingView hideLoadingForView:self.view];
         }];
    
}


#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //去掉UItableview的section的headerview黏性
    CGFloat sectionHeaderHeight = SECTION_NORMAL_NEWS_HEIGHT;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark --- tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}

#pragma mark --- tableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeFeedSectionModel *model =  (self.dataSource.count>indexPath.section)?[self.dataSource objectAtIndex:indexPath.section]:nil;
    return SECTION_TOP_NEWS_HEIGHT+(model.homeFeedDetails.count-1)*SECTION_NORMAL_NEWS_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *homeFeedListCell = @"homeFeedListCell";
    
    HomeFeedSectionModel *model =  (self.dataSource.count>indexPath.section)?[self.dataSource objectAtIndex:indexPath.section]:nil;
    XQBHomeFeedListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeFeedListCell];
    if (!cell) {
        cell = [[XQBHomeFeedListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeFeedListCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.feedCellHandleBlock = ^(HomeFeedSectionModel *sectionModel,NSInteger index){
            XQBHomeFeedDetailModel *model = (sectionModel.homeFeedDetails.count>index)?[sectionModel.homeFeedDetails objectAtIndex:index]:nil;
            XQBHomeFeedDetailViewController *viewController = [[XQBHomeFeedDetailViewController alloc] init];
            viewController.feedDetailModel = model;
            [self.navigationController pushViewController:viewController animated:YES];
        };
    }
    
    cell.sectionModel = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 16.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HomeFeedSectionModel *model =  (self.dataSource.count>section)?[self.dataSource objectAtIndex:section]:nil;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 44)];
    backgroundView.backgroundColor = tableView.backgroundColor;
    
    NSString *strPtime = model.ptime;
    CGSize size = [strPtime sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *label = [[UILabel alloc] init];
    CGFloat realWidth = size.width*1.1+10;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 4.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor lightGrayColor];
    label.frame = CGRectMake((MainWidth-realWidth)/2, (44+16-20)/2-10, realWidth, 20);
    label.text = model.ptime;
    [backgroundView addSubview:label];
    
    return backgroundView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 16)];
    backgroundView.backgroundColor = tableView.backgroundColor;
    
    return backgroundView;
}

@end
