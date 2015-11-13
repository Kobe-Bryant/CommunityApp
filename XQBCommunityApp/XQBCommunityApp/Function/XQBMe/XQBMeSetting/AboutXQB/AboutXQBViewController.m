//
//  AboutXQBViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/5.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "AboutXQBViewController.h"
#import "XQBCustomServiceModel.h"
#import "MakePhoneCall.h"
#import "Global.h"
#import "XQBFAQViewController.h"

static const CGFloat kSpaceVerticalLarge        = 25.0f;
static const CGFloat kSpaceVerticalMiddle       = 7.5f;
static const CGFloat kSpaceVerticalLittle       = 5.0f;

NSInteger baseTag = 10000;

@interface AboutXQBViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableViewHeaderView;
@property (nonatomic, strong) UIView *tableViewFooterView;

@end

@implementation AboutXQBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"关于小区宝"];
    
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

#pragma mark --- UI
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - STATUS_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = XQBColorBackground;
        _tableView.tableHeaderView = self.tableViewHeaderView;
        _tableView.tableFooterView = self.tableViewFooterView;
        
        _tableView.separatorColor = XQBColorInternalSeparationLine;
    }
    return _tableView;
}

- (UIView *)tableViewHeaderView{
    if (_tableViewHeaderView == nil) {
        _tableViewHeaderView = [[UIView alloc] init];
        _tableViewHeaderView.backgroundColor = XQBColorBackground;
        
        UIImageView *xqbImageView = [[UIImageView alloc] initWithFrame:CGRectMake((MainWidth-56)/2, kSpaceVerticalLarge, 56, 65)];
        xqbImageView.backgroundColor = XQBColorBackground;
        xqbImageView.image = [UIImage imageNamed:@"about_xqb_shadow_icon.png"];
        [_tableViewHeaderView addSubview:xqbImageView];
        
        UILabel *xqbLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, Y(xqbImageView)+HEIGHT(xqbImageView)+XQBSpaceVerticalElement, MainWidth-XQBMarginHorizontal*2, 17)];
        xqbLabel.font = [UIFont systemFontOfSize:17.0f];
        xqbLabel.text = @"小区宝";
        xqbLabel.textColor = XQBColorContent;
        xqbLabel.textAlignment = NSTextAlignmentCenter;
        [_tableViewHeaderView addSubview:xqbLabel];
        
        UILabel *xqbVersionCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, Y(xqbLabel)+HEIGHT(xqbLabel)+kSpaceVerticalMiddle, MainWidth-XQBMarginHorizontal*2, 10)];
        xqbVersionCodeLabel.font = [UIFont systemFontOfSize:10.0f];
        xqbVersionCodeLabel.text = [NSString stringWithFormat:@"iPhone %@版", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        xqbVersionCodeLabel.textColor = XQBColorOrange;
        xqbVersionCodeLabel.textAlignment = NSTextAlignmentCenter;
        [_tableViewHeaderView addSubview:xqbVersionCodeLabel];
        
        _tableViewHeaderView.frame = CGRectMake(0, 0, MainWidth, Y(xqbVersionCodeLabel)+HEIGHT(xqbVersionCodeLabel)+kSpaceVerticalLarge);
    }
    
    return _tableViewHeaderView;
}

- (UIView *)tableViewFooterView{
    if (_tableViewFooterView == nil) {
        _tableViewFooterView = [[UIView alloc] init];
        _tableViewFooterView.backgroundColor = XQBColorBackground;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 0.5)];
        lineView.backgroundColor = XQBColorElementSeparationLine;
        [_tableViewFooterView addSubview:lineView];
        
        UILabel *phoneTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, kSpaceVerticalLarge, MainWidth-XQBMarginHorizontal*2, 7)];
        phoneTextLabel.font = [UIFont systemFontOfSize:7.0f];
        phoneTextLabel.text = @"客服电话（按当地市话标准计费）";
        phoneTextLabel.textColor = XQBColorExplain;
        phoneTextLabel.textAlignment = NSTextAlignmentCenter;
        [_tableViewFooterView addSubview:phoneTextLabel];
        
        UIButton *phoneNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneNumberButton.frame = CGRectMake(XQBMarginHorizontal, Y(phoneTextLabel)+HEIGHT(phoneTextLabel)+XQBSpaceVerticalItem, MainWidth-XQBMarginHorizontal*2, 12);
        phoneNumberButton.titleLabel.font = XQBFontExplain;
        [phoneNumberButton setTitle:XQB_CUSTOME_SERVICE_PHONE_NUMBER forState:UIControlStateNormal];
        [phoneNumberButton setTitleColor:XQBColorGreen forState:UIControlStateNormal];
        [phoneNumberButton addTarget:self action:@selector(phoneNumberButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewFooterView addSubview:phoneNumberButton];
        
        UILabel *xqbAgreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, Y(phoneNumberButton)+HEIGHT(phoneNumberButton)+kSpaceVerticalLarge, MainWidth-XQBMarginHorizontal*2, 7)];
        xqbAgreementLabel.font = [UIFont systemFontOfSize:7.0f];
        xqbAgreementLabel.text = @"小区宝服务使用协议";
        xqbAgreementLabel.textColor = XQBColorContent;
        xqbAgreementLabel.textAlignment = NSTextAlignmentCenter;
        [_tableViewFooterView addSubview:xqbAgreementLabel];
        
        UILabel *copyRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, Y(xqbAgreementLabel)+HEIGHT(xqbAgreementLabel)+kSpaceVerticalLittle, MainWidth-XQBMarginHorizontal*2, 7)];
        copyRightLabel.font = [UIFont systemFontOfSize:7.0f];
        copyRightLabel.text = @"Copyright @ 2013-2015 XIAOQUBAO";
        copyRightLabel.textColor = XQBColorExplain;
        copyRightLabel.textAlignment = NSTextAlignmentCenter;
        [_tableViewFooterView addSubview:copyRightLabel];
        
        _tableViewFooterView.frame = CGRectMake(0, 0, MainWidth, Y(copyRightLabel)+HEIGHT(copyRightLabel)+XQBSpaceVerticalItem);
    }
    
    return _tableViewFooterView;
}

#pragma mark ---action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)phoneNumberButtonHandle:(UIButton *)sender
{
    MakePhoneCall *instance = [MakePhoneCall getInstance];
    BOOL call_ok = [instance makeCall:XQB_CUSTOME_SERVICE_PHONE_NUMBER];
    
    if (call_ok) {
        //上报
    }else{
        MsgBox(@"设备不支持电话功能");
    }
}

#pragma mark ---network
- (void)requestVersionCheck{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    [manager GET:API_APP_UPDATE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            XQBLog(@"版本更新请求成功");
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSDictionary *appDic = [data objectForKey:@"app"];
            NSString *updateContent = [data objectForKey:@"description"];
            BOOL isLatest = [[appDic objectForKey:@"isLatest"] boolValue];
            BOOL isForceUpdate = [[appDic objectForKey:@"isForceUpdate"] boolValue];
            if (isLatest) {
                [[UIApplication sharedApplication].keyWindow makeCustomToast:@"已是最新版本"];
            }else{
                if (isForceUpdate) {
                    UIAlertView *forceUpdtateAlertView = [[UIAlertView alloc] initWithTitle:@"亲，有新版本哟~~" message:updateContent delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    
                    forceUpdtateAlertView.tag = baseTag+1;
                    [forceUpdtateAlertView show];
                    
                    
                }else{
                    UIAlertView *forceUpdtateAlertView = [[UIAlertView alloc] initWithTitle:@"亲，有新版本哟~~" message:updateContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级",nil];
                    forceUpdtateAlertView.tag = baseTag+2;
                    [forceUpdtateAlertView show];
                }
            }
            
            
        } else {
            //加载服务器异常界面
            XQBLog(@"服务器异常");
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
    
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = XQBFontContent;
    }
    cell.textLabel.text = [self conifgCellTextWith:indexPath.row];
    
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{        //好评
            [self openiTunesStoreURL];
        }
            break;
        case 1:{        //常见问题
            XQBFAQViewController *viewController = [[XQBFAQViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 2:{        //版本更新
            [self requestVersionCheck];
        }
            break;
        default:
            break;
    }
}

- (NSString *)conifgCellTextWith:(NSInteger)index{
    switch (index) {
        case 0:
            return @"亲~给我们个好评";
        case 1:
            return @"常见问题";
        case 2:
            return @"版本更新";
        default:
            break;
    }
    
    return nil;
}

#pragma mark ---alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger alertIndex = alertView.tag - baseTag;
    switch (alertIndex) {
        case 1:
        {
            [self openiTunesStoreURL];
            exit(0);
        }
            
            break;
        case 2:{
            
            if (buttonIndex == 0) {
                //取消升级
                XQBLog(@"取消版本升级");
            }else{
                [self openiTunesStoreURL];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)openiTunesStoreURL{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
}

@end
