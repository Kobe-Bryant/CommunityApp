//
//  CityArearListViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "CityArearListViewController.h"
#import "Global.h"
#import "BlankPageView.h"

@interface CityArearListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BlankPageView *blankPageView;

@property (nonatomic, strong) NSMutableArray *districtArray;

@end

@implementation CityArearListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _districtArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = XQBColorBackground;
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"区域选择"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self.view addSubview:self.tableView];
    [self requestDataDistricts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---ui
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - STATUS_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = XQBColorBackground;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.sectionHeaderHeight = XQBSpaceVerticalElement;
        
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
            [weakself requestDataDistricts];
        };
    }
    return _blankPageView;
}


#pragma mark ---action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- AFNetwork
- (void)requestDataDistricts
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    [manager GET:EC_DATA_DISTRICTS_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSArray *array = [responseObject objectForKey:@"districts"];
            for (NSDictionary *dic in array) {
                CityDistrictsModel *model = [[CityDistrictsModel alloc] init];
                model.pcName = [responseObject objectForKey:@"pcName"];
                model.pId = [[responseObject objectForKey:@"pid"] stringValue];
                model.cId = [[responseObject objectForKey:@"cid"] stringValue];
                model.districtName = [dic objectForKey:@"name"];
                model.districtsId = [[dic objectForKey:@"id"] stringValue];
                
                [self.districtArray addObject:model];
            }
            
            if (self.districtArray.count > 0) {
                [_tableView reloadData];
            } else {
                //加载无数据界面；
                [self.view addSubview:self.blankPageView];
                [_blankPageView resetImage:[UIImage imageNamed:@"no_collection.png"]];
                [_blankPageView resetTitle:MALL_NO_CITY_AREAR_LIST_DATA andDescribe:MALL_NO_LIST_DATA_DESCRIBE];
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
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
        [self.view addSubview:self.blankPageView];
        [_blankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
        [_blankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
    }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _districtArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    CityDistrictsModel *model = ([self.districtArray count]>indexPath.row)? [self.districtArray objectAtIndex:indexPath.row]:nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
#ifdef __IPHONE_8_0
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
#endif
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",model.pcName,model.districtName];
    
    return cell;
}

#pragma mark --- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return XQBHeightElement;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityDistrictsModel *model = ([self.districtArray count]>indexPath.row)? [self.districtArray objectAtIndex:indexPath.row]:nil;
    if (self.distanceDidSelectedCompleteBlock) {
        self.distanceDidSelectedCompleteBlock(model);
    }
    [self backHandle:nil];
}
@end
