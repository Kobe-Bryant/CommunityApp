//
//  XQBMeSelectCommunityViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/6.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBMeSelectCommunityViewController.h"
#import "Global.h"
#import "CommunityModel.h"
#import "XQBBaseTableView.h"
#import "XQBMeSelectHouseViewController.h"
#import "XQBSeleteCommunityTableViewCell.h"

@interface XQBMeSelectCommunityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) XQBBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *communityList;
@property (nonatomic, strong) NSString *searchText;

@property (nonatomic, strong) UISearchBar *communitySearchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation XQBMeSelectCommunityViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _communityList = [[NSMutableArray alloc] init];
        _searchResults = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"完善小区资料"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self.view addSubview:self.tableView];
    
    [self initalizeSearchBar];
    
    [self requestOpenCommunity];
    
}

#pragma mark --- ui
- (void)initalizeSearchBar{
    
    _communitySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 40)];
    _communitySearchBar.delegate = self;
    [_communitySearchBar setPlaceholder:@"请输入小区名称"];
    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
    if ([ _communitySearchBar respondsToSelector : @selector (barTintColor)]) {
        float  iosversion7_1 = 7.1 ;
        if (version >= iosversion7_1)
        {
            //iOS7.1
            [[[[_communitySearchBar . subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
            [_communitySearchBar setBackgroundColor :RGB(240, 240, 240)];
        }
        else
        {
            //iOS7.0
            [_communitySearchBar setBarTintColor :[ UIColor clearColor ]];
            [_communitySearchBar setBackgroundColor :RGB(240, 240, 240)];
        }
    }
    else
    {
        //iOS7.0 以下
        [[_communitySearchBar.subviews objectAtIndex : 0 ] removeFromSuperview ];
        [_communitySearchBar setBackgroundColor :RGB(240, 240, 240)];
    }
    [self.view addSubview:_communitySearchBar];
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_communitySearchBar contentsController:self];
    _searchController.active = NO;
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
}

- (XQBBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, MainHeight-44) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _tableView;
}

#pragma mark ---network
- (void)requestOpenCommunity{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    if (self.cityId) {
        [parameters setObject:self.cityId forKey:@"cityId"];
    }
    [parameters setObject:@"" forKey:@"keyword"];
    [parameters addSignatureKey];
    
    [manager GET:API_COMMUNITY_URL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self.communityList removeAllObjects];
             if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]){
             
                 NSArray *citys = [[responseObject objectForKey:@"data"] objectForKey:@"communities"];
                 
                 for (NSDictionary *dic in citys) {
                     CommunityModel *model = [[CommunityModel alloc] init];
                     model.communityId = [[dic objectForKey:@"id"] stringValue];
                     model.communityName = [dic objectForKey:@"name"];
                     model.address = [dic objectForKey:@"address"];
                     model.hasHouse = DealWithJSONBoolValue([dic objectForKey:@"hasHouse"]);
                     [self.communityList addObject:model];
                 }
             }else{
                 //加载服务器异常界面
             }
             
             [self.tableView reloadData];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"网络异常error-->%@",error);
         }];
}


- (void)searchKeyWordsCommunity:(NSString *)keywords{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    if (self.cityId) {
        [parameters setObject:self.cityId forKey:@"cityId"];
    }
    if (keywords) {
        [parameters setObject:keywords forKey:@"keyword"];
    }
    [parameters addSignatureKey];
    [manager GET:API_COMMUNITY_URL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self.communityList removeAllObjects];
             if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]){
                 
                 NSArray *citys = [[responseObject objectForKey:@"data"] objectForKey:@"communities"];
                 
                 for (NSDictionary *dic in citys) {
                     CommunityModel *model = [[CommunityModel alloc] init];
                     model.communityId = [[dic objectForKey:@"id"] stringValue];
                     model.communityName = [dic objectForKey:@"name"];
                     model.address = [dic objectForKey:@"address"];
                     [self.searchResults addObject:model];
                 }
             }else{
                 //加载服务器异常界面
             }
             
             [self.searchController.searchResultsTableView reloadData];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"网络异常error-->%@",error);
         }];

}

#pragma mark ---action
- (void)backHandle:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommunityModel *communityModel = nil;
    if (tableView == _tableView) {
        CommunityModel *model = ([self.communityList count]>indexPath.row)?[self.communityList objectAtIndex:indexPath.row]:nil;
        communityModel = model;
    }else if (tableView == self.searchController.searchResultsTableView){
        CommunityModel *model = ([self.searchResults count]>indexPath.row)?[self.searchResults objectAtIndex:indexPath.row]:nil;
        communityModel = model;
    }
    if (communityModel.hasHouse) {
        XQBMeSelectHouseViewController *viewController = [[XQBMeSelectHouseViewController alloc] init];
        viewController.communityId = communityModel.communityId;
        [self.navigationController pushViewController:viewController animated:YES];
    }else {
        [self.view makeCustomToast:@"该小区没有相关数据"];
    }
}

#pragma mark --- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return [self.communityList count];
    }else if (tableView == self.searchController.searchResultsTableView){
        return [self.searchResults count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    XQBSeleteCommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[XQBSeleteCommunityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (tableView == _tableView) {
        CommunityModel *model = ([self.communityList count]>indexPath.row)?[self.communityList objectAtIndex:indexPath.row]:nil;
        cell.communityNameLabel.text = model.communityName;
        cell.communityAddressLabel.text = model.address;
    }else if (tableView == self.searchController.searchResultsTableView){
        CommunityModel *model = ([self.searchResults count]>indexPath.row)?[self.searchResults objectAtIndex:indexPath.row]:nil;
        cell.communityNameLabel.text = model.communityName;
        cell.communityAddressLabel.text = model.address;
    }
    
    return cell;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)hsearchBar
{
    hsearchBar.showsCancelButton = YES;
    for(id cc in [hsearchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
        if (searchText.length == 2) {
            if (self.searchText.length > 0) {
                if (![searchText hasPrefix:self.searchText]) {
                    self.searchText = searchText;
                    [self searchKeyWordsCommunity:self.searchText];
                }
            }else{
                self.searchText = searchText;
                [self searchKeyWordsCommunity:self.searchText];
            }
    
        }
}
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{

}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.searchResults removeAllObjects];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (searchBar.text.length > 0) {
        self.searchText = searchBar.text;
        [self searchKeyWordsCommunity:searchBar.text];
    }
}


@end
