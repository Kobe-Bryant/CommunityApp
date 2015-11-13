//
//  XQBHomeAroundShopViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/4.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBHomeAroundShopViewController.h"
#import "Global.h"
#import "XQBConCategoryTableViewCell.h"
#import "XQBBaseTableView.h"
#import "XQBConDetailWebViewController.h"
#import "ConvenienceListModel.h"
#import "XQBDZDPUrl.h"
#import "XQBConDPCategoryListViewController.h"

static NSString *identify = @"identify";

@interface XQBHomeAroundShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) NSMutableArray *convenienceListArray;

@end

@implementation XQBHomeAroundShopViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initalize];
    }
    
    return self;
}

- (void)initalize{
    _convenienceListArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"周边小店"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[XQBConCategoryTableViewCell class] forCellReuseIdentifier:identify];
    
    [self requestConvenienceList];
}

#pragma makr --- ui
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-STATUS_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

#pragma mark --- AFNetwork
- (void)requestConvenienceList
{
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+30)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    [manager GET:API_LIFE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        [XQBLoadingView hideLoadingForView:self.view];
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
        [XQBLoadingView hideLoadingForView:self.view];
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
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark ---
- (void)backHandle:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
