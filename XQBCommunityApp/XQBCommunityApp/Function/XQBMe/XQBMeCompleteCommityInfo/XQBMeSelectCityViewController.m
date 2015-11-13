//
//  XQBMeSelectCityViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/6.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBMeSelectCityViewController.h"
#import "Global.h"
#import "XQBBaseTableView.h"
#import "CityModel.h"
#import "XQBCoreLBS.h"
#import "XQBMeSelectCommunityViewController.h"
#import "XQBSeleteCommunityTableViewCell.h"

@interface XQBMeSelectCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) XQBBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *openCitys;


@end

@implementation XQBMeSelectCityViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _openCitys = [[NSMutableArray alloc] init];
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
    
    [self requestCommunityCity];
}

#pragma mark --- ui
- (XQBBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = XQBColorBackground;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
        _tableView.separatorColor = XQBColorInternalSeparationLine;
    }
    return _tableView;
}

- (void)requestCommunityCity{
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+30)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    [manager GET:API_CITY_OPEN_URL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [XQBLoadingView hideLoadingForView:self.view];
             [_openCitys removeAllObjects];
             NSArray *citys = [responseObject objectForKey:@"data"];
             
             for (NSDictionary *dic in citys) {
                 CityModel *model = [[CityModel alloc] init];
                 model.cityId = [[dic objectForKey:@"cityId"] stringValue];
                 model.cityName = DealWithJSONValue([dic objectForKey:@"name"]);
                 
                 [_openCitys addObject:model];
             }
             
             [self.tableView reloadData];
    
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [XQBLoadingView hideLoadingForView:self.view];
         }];
    
}

#pragma mark ---tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {   //GPS定位
        return;
    }else if (indexPath.section == 1){
        //do something
        CityModel *cityModel = ([self.openCitys count]>indexPath.row)?[self.openCitys objectAtIndex:indexPath.row]:nil;
        XQBMeSelectCommunityViewController *viewController = [[XQBMeSelectCommunityViewController alloc] init];
        viewController.hiddenNavigationBarWhenPoped = YES;
        viewController.cityId = cityModel.cityId;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return XQBSpaceVerticalElement;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBSpaceVerticalElement)];
    backgroundView.backgroundColor = XQBColorBackground;
    
    return backgroundView;
}


#pragma mark ---tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return [_openCitys count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *text = [NSString stringWithFormat:@"GPS定位:%@",[XQBCoreLBS shareInstance].cityName];
        cell.textLabel.text = text;
    }else if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        CityModel *model = ([self.openCitys count]>indexPath.row)?[self.openCitys objectAtIndex:indexPath.row]:nil;
        cell.textLabel.text = model.cityName;
    }

    return cell;
}

#pragma mark ---action
- (void)backHandle:(UIButton *)sender{
    if(self.hiddenNavigationBarWhenPoped){
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
