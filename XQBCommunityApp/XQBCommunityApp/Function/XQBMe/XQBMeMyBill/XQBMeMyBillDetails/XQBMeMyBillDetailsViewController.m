//
//  XQBMeMyBillDetailsViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/12.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeMyBillDetailsViewController.h"
#import "Global.h"
#import "XQBMeMybillDetailsCell.h"

static const CGFloat kSectionHeaderHeight = 45.0f;

@interface XQBMeMyBillDetailsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *sectionAttributeNameArray;
@property (nonatomic, retain) NSMutableArray *sectionAttributeValueArray;

@end

@implementation XQBMeMyBillDetailsViewController

- (void)initalize
{
    NSMutableArray *attributeNameArray1 = [[NSMutableArray alloc] init];
    NSMutableArray *attributeNameArray2 = [[NSMutableArray alloc] init];
    NSMutableArray *attributeNameArray3 = [[NSMutableArray alloc] init];
    
    NSMutableArray *attributeValueArray1 = [[NSMutableArray alloc] init];
    NSMutableArray *attributeValueArray2 = [[NSMutableArray alloc] init];
    NSMutableArray *attributeValueArray3 = [[NSMutableArray alloc] init];
    
    //cell 1
    if (_billModel.total)
    {
        [attributeNameArray1 addObject:@"应付总额（元）"];
        [attributeValueArray1 addObject:[NSString stringWithFormat:@"￥%@", _billModel.total]];
    }
    if (_billModel.count)
    {
        [attributeNameArray1 addObject:[NSString stringWithFormat:@"本期用量（%@）", _billModel.unit]];
        [attributeValueArray1 addObject:_billModel.count];
    }
    if (_billModel.billStartTime && _billModel.billEndTime)
    {
        [attributeNameArray1 addObject:@"起止时间"];
        [attributeValueArray1 addObject:[NSString stringWithFormat:@"%@到%@", _billModel.billStartTime, _billModel.billEndTime]];
    }
    
    //cell 2
    if (_billModel.moneyOne)
    {
        [attributeNameArray2 addObject:@"本期费用（元）"];
        [attributeValueArray2 addObject:[NSString stringWithFormat:@"￥%@", _billModel.moneyOne]];
    }
    if (_billModel.oldReadings)
    {
        [attributeNameArray2 addObject:[NSString stringWithFormat:@"上期读数（%@）", _billModel.unit]];
        [attributeValueArray2 addObject:_billModel.oldReadings];
    }
    if (_billModel.readings)
    {
        [attributeNameArray2 addObject:[NSString stringWithFormat:@"本期读数（%@）", _billModel.unit]];
        [attributeValueArray2 addObject:_billModel.readings];
    }
    if (_billModel.price)
    {
        [attributeNameArray2 addObject:@"单价"];
        [attributeValueArray2 addObject:[NSString stringWithFormat:@"￥%@", _billModel.price]];
    }
    
    //cell 3
    if (_billModel.oldArrears)
    {
        [attributeNameArray3 addObject:@"上次欠费"];
        [attributeValueArray3 addObject:[NSString stringWithFormat:@"￥%@", _billModel.oldArrears]];
    }
    if (_billModel.damage)
    {
        [attributeNameArray3 addObject:@"违约金"];
        [attributeValueArray3 addObject:[NSString stringWithFormat:@"￥%@", _billModel.damage]];
    }
    
    
    _sectionAttributeNameArray = [[NSMutableArray alloc] init];
    _sectionAttributeValueArray = [[NSMutableArray alloc] init];
    
    if (attributeNameArray1.count > 0) {
        [_sectionAttributeNameArray addObject:attributeNameArray1];
        [_sectionAttributeValueArray addObject:attributeValueArray1];
    }
    if (attributeNameArray2.count > 0) {
        [_sectionAttributeNameArray addObject:attributeNameArray2];
        [_sectionAttributeValueArray addObject:attributeValueArray2];
    }
    if (attributeNameArray3.count > 0) {
        [_sectionAttributeNameArray addObject:attributeNameArray3];
        [_sectionAttributeValueArray addObject:attributeValueArray3];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:_billModel.title];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initalize];
    
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
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorColor = XQBColorInternalSeparationLine;
        _tableView.sectionHeaderHeight = kSectionHeaderHeight;
    }
    return _tableView;
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //去掉UItableview的section的headerview黏性
    CGFloat sectionHeaderHeight = kSectionHeaderHeight;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark --- table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionAttributeNameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [(NSMutableArray *)[_sectionAttributeNameArray objectAtIndex:section] count]>0 ? [(NSMutableArray *)[_sectionAttributeNameArray objectAtIndex:section] count]: 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    XQBMeMybillDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[XQBMeMybillDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.attributeNameLabel.text = [[_sectionAttributeNameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.attributeValueLabel.text = [[_sectionAttributeValueArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return XQBHeightElement;
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
    return kSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, kSectionHeaderHeight)];
    sectionHeaderView.backgroundColor = XQBColorBackground;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 0, MainWidth-XQBMarginHorizontal*2, kSectionHeaderHeight)];
    titleLabel.backgroundColor = XQBColorBackground;
    titleLabel.font = XQBFontContent;
    titleLabel.textColor = XQBColorContent;
    [sectionHeaderView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 0.5)];
    lineView.backgroundColor = XQBColorElementSeparationLine;
    
    switch (section) {
        case 0:
            titleLabel.text = @"概况";
            break;
        case 1:
        {
            titleLabel.text = @"详情";
            [sectionHeaderView addSubview:lineView];
            break;
        }
        case 2:
        {
            titleLabel.text = @"费用";
            [sectionHeaderView addSubview:lineView];
            break;
        }
        default:
            break;
    }
    
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
