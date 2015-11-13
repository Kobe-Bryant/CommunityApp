//
//  XQBGuestSettingViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/4.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBGuestSettingViewController.h"
#import "Global.h"
#import "CommonSettingsViewController.h"
#import "VersionIntroductionViewController.h"
#import "AboutXQBViewController.h"

@interface XQBGuestSettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XQBGuestSettingViewController

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

#pragma mark ---action
- (void)backHandle:(UIButton *)sender{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.parentViewController.navigationController){
        [self.parentViewController.navigationController popViewControllerAnimated:YES];
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return XQBSpaceVerticalElement;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            CommonSettingsViewController *CommonSettingsVC = [[CommonSettingsViewController alloc] init];
            [self.navigationController pushViewController:CommonSettingsVC animated:YES];
            break;
        }
        case 1:{
            VersionIntroductionViewController *versionIntroductionVC = [[VersionIntroductionViewController alloc] init];
            versionIntroductionVC.parentViewController.parentViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:versionIntroductionVC animated:YES];
            break;
        }
        case 2:{
            AboutXQBViewController *aboutXQBVC = [[AboutXQBViewController alloc] init];
            [self.navigationController pushViewController:aboutXQBVC animated:YES];
            break;
        }
        default:
            break;
    }
}

- (NSString *)conifgCellTextWith:(NSInteger)index{
    switch (index) {
        case 0:
            return @"通用设置";
        case 1:
            return @"版本介绍";
        case 2:
            return @"关于小区宝";
        default:
            break;
    }
    
    return nil;
}

@end
