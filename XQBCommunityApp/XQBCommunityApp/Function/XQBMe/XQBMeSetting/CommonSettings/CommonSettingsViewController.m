//
//  CommonSettingsViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/5.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "CommonSettingsViewController.h"
#import "Global.h"
#import "XQBBaseSheetMenu.h"
#import "SDImageCache.h"
#import "XQBPush.h"

NSString *pushSettingDescrible = @"";

@interface CommonSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CommonSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"通用设置"];
    
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - STATUS_NAV_BAR_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = XQBColorBackground;
        _tableView.sectionHeaderHeight = XQBSpaceVerticalElement;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorColor = XQBColorInternalSeparationLine;
    }
    return _tableView;
}

#pragma mark --- life
- (void)showCleanDiskSheetMenu{
    XQBBaseSheetMenu *sheetMenu = [[XQBBaseSheetMenu alloc] initWithTitle:nil itemTitles:@[@"清理图片缓存",@"取消"]];
    [sheetMenu triggerSelectedAction:^(NSInteger actionHandle) {
        
        if (actionHandle == 0){     //清除
            XQBLoadingView *loadingView = [XQBLoadingView showLoadingAddedToView:self.view];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                [loadingView performSelector:@selector(hideLoading) withObject:nil afterDelay:1.0];
            }];
        }else if (actionHandle == 1){
        
        }
        [[SGActionView sharedActionView] dismissMenu:sheetMenu Animated:YES];
    }];
    [SGActionView showCustomView:sheetMenu animation:YES];
}

#pragma mark ---action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //去掉UItableview的section的headerview黏性
    CGFloat sectionHeaderHeight = XQBSpaceVerticalElement;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        if (indexPath.section == 0) {
            /*
            UISwitch *cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(MainWidth-XQBMarginHorizontal-50, 7, 0, 0)];
            [cell addSubview:cellSwitch];
             */
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = XQBFontContent;
    }
    cell.textLabel.text = [self conifgCellTextWith:indexPath];
    cell.detailTextLabel.text = nil;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.detailTextLabel.textColor = XQBColorExplain;
        NSString *stateString = @"已开启";
        if (![XQBPush shareInstance].pushAvailable) {
            stateString = @"未开启";
        }
        cell.detailTextLabel.text = stateString;
        cell.detailTextLabel.font = XQBFontContent;
    }
    if (indexPath.section == 1&& indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f M",[[SDImageCache sharedImageCache] getSize]/(1024.0*1024)] ;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 44.0f;
    }
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 44)];
    backgroundView.backgroundColor = XQBColorBackground;
    if (section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, MainWidth-30, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.textColor = XQBColorExplain;
        label.font = [UIFont systemFontOfSize:11];
        label.text = [NSString stringWithFormat:@"要开启或关闭%@的推送通知,请在iPhone的\"设置\"-\"通知\"中找到\"%@\"进行设置",APP_NAME,APP_NAME];
        [backgroundView addSubview:label];
    }
    
    return backgroundView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBSpaceVerticalElement)];
    backgroundView.backgroundColor = XQBColorBackground;
    
    return backgroundView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:         //清除图片缓存
                {
                    [self showCleanDiskSheetMenu];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        
        case 2:
        {
        
        }
            break;
            
        default:
            break;
    }
}

- (NSString *)conifgCellTextWith:(NSIndexPath *)index{
    switch (index.section) {
        case 0:{
            switch (index.row) {
                case 0:{
                    return @"新消息通知";
                }
                case 1:{
                    return @"声音";
                }
                default:
                    return nil;
            }
        }
        case 1:
            switch (index.row) {
                case 0:{
                    return @"清除图片缓存";
                }
                default:
                    return nil;
            }
        case 2:
            switch (index.row) {
                case 0:{
                    return @"免打扰设置";
                }
                default:
                    return nil;
            }
        default:
            return nil;
    }
}
@end
