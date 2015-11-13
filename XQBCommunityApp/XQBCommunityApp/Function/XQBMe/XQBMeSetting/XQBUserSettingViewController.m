//
//  XQBUserSettingViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/4.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBUserSettingViewController.h"
#import "Global.h"
#import "CommonSettingsViewController.h"
#import "OpinionFeedbackViewController.h"
#import "VersionIntroductionViewController.h"
#import "AboutXQBViewController.h"

@interface XQBUserSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation XQBUserSettingViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"设置"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark --- net work
- (void)requestLogout{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:[UserModel shareUser].cityName forKey:@"cityName"];
    [parameters addSignatureKey];
    
    [manager POST:API_UESER_LOGOUT_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        [[UserModel shareUser] clearUserInfo];
        [self backHandle:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kXQBLogoutSucceedNotification object:nil];
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            XQBLog(@"登出成功");
            [self.view.window makeCustomToast:@"登出成功"];
        }else {
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


#pragma mark --- ui
#pragma mark ---ui
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - STATUS_NAV_BAR_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = XQBColorBackground;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        _tableView.sectionHeaderHeight = XQBSpaceVerticalElement;
        
        _tableView.separatorColor = XQBColorInternalSeparationLine;
    }
    return _tableView;
}

#pragma mark --- table view
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        //YOUR_HEIGHT 为最高的那个headerView的高度
        CGFloat sectionHeaderHeight = XQBSpaceVerticalElement;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell) {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = XQBFontContent;
    }
    
    cell.textLabel.text = [self conifgCellTextWithIndexPath:indexPath];
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return XQBSpaceVerticalElement;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                CommonSettingsViewController *CommonSettingsVC = [[CommonSettingsViewController alloc] init];
                [self.navigationController pushViewController:CommonSettingsVC animated:YES];
            }                
                break;
                
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                OpinionFeedbackViewController *opinionFeedbackVC = [[OpinionFeedbackViewController alloc] init];
                [self.navigationController pushViewController:opinionFeedbackVC animated:YES];
            }
                break;
            case 1:
            {
                VersionIntroductionViewController *versionIntroductionVC = [[VersionIntroductionViewController alloc] init];
                [self.navigationController pushViewController:versionIntroductionVC animated:YES];
                break;
            }
            case 2:
            {
                AboutXQBViewController *aboutXQBVC = [[AboutXQBViewController alloc] init];
                [self.navigationController pushViewController:aboutXQBVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
            {
                [self requestLogout];
            }
                break;
            default:
                break;
        }
    }

}

- (NSString *)conifgCellTextWithIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return @"通用设置";
                break;
                
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                return @"意见反馈";
            case 1:
                return @"版本介绍";
            case 2:
                return @"关于小区宝";
            default:
                break;
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
                return @"退出当前用户";
                
            default:
                break;
        }
    }
    
    return nil;
}

#pragma mark ---action
- (void)backHandle:(UIButton *)sender{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.parentViewController.navigationController){
        [self.parentViewController.navigationController popViewControllerAnimated:YES];
    }
    
}



@end
