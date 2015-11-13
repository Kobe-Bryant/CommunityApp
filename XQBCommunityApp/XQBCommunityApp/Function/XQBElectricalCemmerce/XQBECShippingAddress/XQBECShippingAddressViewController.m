//
//  XQBECShippingAddressViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/18.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBECShippingAddressViewController.h"
#import "Global.h"
#import "ShippingAddressDetailViewController.h"
#import "ShippingAddressModel.h"
#import "XQBECShippingAddressCell.h"

@interface XQBECShippingAddressViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableViewHeaderView;

@property (nonatomic, strong) NSMutableArray *shippingAddressArray;

@end

@implementation XQBECShippingAddressViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _shippingAddressArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestShippingAddress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"收货地址"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = XQBColorBackground;
    
    [self.view addSubview:self.tableView];
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
        _tableView.tableHeaderView = self.tableViewHeaderView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
        _tableView.separatorColor = XQBColorInternalSeparationLine;
    }
    return _tableView;
}

- (UIView *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 88)];
        _tableViewHeaderView.backgroundColor = [UIColor whiteColor];
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 22)];
        spaceView.backgroundColor = XQBColorBackground;
        [_tableViewHeaderView addSubview:spaceView];
        
        UIButton *addShippingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addShippingButton setFrame:CGRectMake(14, 22, 270, 44)];
        [addShippingButton setTitle:@"  新增收货地址" forState:UIControlStateNormal];
        [addShippingButton setImage:[UIImage imageNamed:@"add_icon.png"] forState:UIControlStateNormal];
        [addShippingButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
        [addShippingButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [addShippingButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [addShippingButton addTarget:self action:@selector(addShippingButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewHeaderView addSubview:addShippingButton];
        
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth-30, 22+15, 8, 14)];
        [accessoryImageView setImage:[UIImage imageNamed:@"right_arrow_gray.png"]];
        [_tableViewHeaderView addSubview:accessoryImageView];
        
        UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 66, MainWidth, 22)];
        spaceView2.backgroundColor = XQBColorBackground;
        [_tableViewHeaderView addSubview:spaceView2];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 0.5)];
        lineView2.backgroundColor = XQBColorElementSeparationLine;
        [spaceView2 addSubview:lineView2];
    }
    return _tableViewHeaderView;
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addShippingButtonHandle:(UIButton *)sender
{
    ShippingAddressDetailViewController *addressDetailVC = [[ShippingAddressDetailViewController alloc] init];
    [self.navigationController pushViewController:addressDetailVC animated:YES];
}

- (void)detailbtnHandle:(UIButton *)sender
{
    ShippingAddressDetailViewController *addressDetailVC = [[ShippingAddressDetailViewController alloc] init];
    addressDetailVC.addressModel = [self.shippingAddressArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:addressDetailVC animated:YES];
}

#pragma mark --- AFNetwork
- (void)requestShippingAddress
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    [manager GET:EC_SHIPPING_ADDRESS_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            NSArray *shippingListArray = [responseObject objectForKey:@"shippingList"];
            
            [self.shippingAddressArray removeAllObjects];
            
            for (NSDictionary *dic in shippingListArray) {
                ShippingAddressModel *model = [[ShippingAddressModel alloc] init];
                model.shippingAddressId = [[dic objectForKey:@"id"] stringValue];
                model.consignee     = DealWithJSONValue([dic objectForKey:@"consignee"]);
                model.phone         = DealWithJSONValue([dic objectForKey:@"phone"]);
                model.zipCode       = DealWithJSONValue([dic objectForKey:@"zipcode"]);
                model.email         = DealWithJSONValue([dic objectForKey:@"email"]);
                model.province      = [[dic objectForKey:@"province"] stringValue];
                model.city          = [[dic objectForKey:@"city"] stringValue];
                model.address       = DealWithJSONValue([dic objectForKey:@"address"]);
                model.pcd           = DealWithJSONValue([dic objectForKey:@"pcd"]);
                model.isDefault     = [[dic objectForKey:@"isDefault"] stringValue];
                model.area          = [[dic objectForKey:@"district"] stringValue];
                
                [self.shippingAddressArray addObject:model];
            }
            
            [_tableView reloadData];
        } else {
            //加载服务器异常界面
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
    }];
}

- (void)requestShippingSetDefault:(NSString *)shippingId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:shippingId forKey:@"id"];
    
    [parameters addSignatureKey];
    
    [manager GET:EC_SHIPPING_SET_DEFAULT_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self backHandle:nil];
        } else {
            //加载服务器异常界面
            [self.view.window makeCustomToast:@"设置默认地址失败"];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
}

- (void)requestShippingDelete:(NSString *)shippingId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:shippingId forKey:@"id"];
    
    [parameters addSignatureKey];
    
    [manager GET:EC_SHIPPING_DELETE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self.view.window makeCustomToast:@"删除地址成功"];
            [self requestShippingAddress];
        } else {
            //加载服务器异常界面
            [self.view.window makeCustomToast:@"删除地址失败"];
            [self requestShippingAddress];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shippingAddressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    XQBECShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[XQBECShippingAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    ShippingAddressModel  *model =self.shippingAddressArray.count > indexPath.row ? [self.shippingAddressArray objectAtIndex:indexPath.row] : nil;
    
    if (![model.isDefault isEqualToString:@"0"]) {
        UIImage *imageSelected = [UIImage imageNamed:@"bg_awardView_selectedAdress.png"];
        cell.iconImageView.image = imageSelected;
    }else {
        cell.iconImageView.image = nil;
    }
    
    cell.detailbtn.tag = indexPath.row;
    [cell.detailbtn addTarget:self action:@selector(detailbtnHandle:) forControlEvents:UIControlEventTouchUpInside];
    cell.nameLabel.text = model.consignee;
    cell.contentLabel.text = [NSString stringWithFormat:@"%@%@", model.pcd, model.address];
    return cell;
}

#pragma mark --- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShippingAddressModel  *model =self.shippingAddressArray.count > indexPath.row ? [self.shippingAddressArray objectAtIndex:indexPath.row] : nil;
    
    if (![model.isDefault isEqualToString:@"0"]) {
        [self backHandle:nil];
    } else {
        [self requestShippingSetDefault:model.shippingAddressId];
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShippingAddressModel  *model =self.shippingAddressArray.count > indexPath.row ? [self.shippingAddressArray objectAtIndex:indexPath.row] : nil;
    if (![model.isDefault isEqualToString:@"0"]) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)tableView:(UITableView *)tableVie titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// 当点击删除时，删除该条记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShippingAddressModel  *model =self.shippingAddressArray.count > indexPath.row ? [self.shippingAddressArray objectAtIndex:indexPath.row] : nil;
        [self requestShippingDelete:model.shippingAddressId];
    }
}


@end
