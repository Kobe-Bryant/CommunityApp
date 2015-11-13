//
//  XQBMeMyBillViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/11.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeMyBillViewController.h"
#import "Global.h"
#import "XQBMeMyBillTableViewCell.h"
#import "MonthBillsModel.h"
#import "MyBillModel.h"
#import "XQBMeMyBillDetailsViewController.h"
#import "DateSelectPopUpView.h"
#import "BlankPageView.h"

static const CGFloat kTotolLabelWidth = 40.0f;

@interface XQBMeMyBillViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *dateSelecteView;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *monthLabel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableViewFooterView;
@property (nonatomic, strong) UILabel *totolLabel;
@property (nonatomic, strong) UILabel *totalMoneyLabel;

@property (nonatomic, strong) DateSelectPopUpView *dateSelectePopView;

@property (nonatomic, strong) BlankPageView *noAllBillBlankPageView;
@property (nonatomic, strong) BlankPageView *noMonthBillBlankPageView;


@property (nonatomic, strong) NSMutableArray *allBillsArray;

@property (nonatomic, strong) NSMutableArray *yearsArray;
@property (nonatomic, strong) NSMutableArray *monthsArray;
@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentMonth;




@end

@implementation XQBMeMyBillViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _allBillsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _yearsArray = [[NSMutableArray alloc] initWithCapacity:0];
        _monthsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
        _currentYear = [dateComponent year];
        _currentMonth = [dateComponent month];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"物业账单"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = XQBColorBackground;
    
    [self.view addSubview:self.dateSelectView];
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestEnableYearMonth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- ui
- (UIView *)dateSelectView
{
    if (!_dateSelecteView) {
        _dateSelecteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBHeightElement)];
        _dateSelecteView.backgroundColor = [UIColor whiteColor];
        _dateSelecteView.hidden = YES;
        
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth/2, XQBHeightElement)];
        _yearLabel.font = XQBFontContent;
        _yearLabel.textColor = XQBColorContent;
        _yearLabel.textAlignment = NSTextAlignmentCenter;
        [_dateSelecteView addSubview:_yearLabel];
        
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth/2, 0, MainWidth/2, XQBHeightElement)];
        _monthLabel.font = XQBFontContent;
        _monthLabel.textColor = XQBColorContent;
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        [_dateSelecteView addSubview:_monthLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(MainWidth/2-0.5, 5, 0.5, XQBHeightElement-10)];
        lineView.backgroundColor = XQBColorInternalSeparationLine;
        [_dateSelecteView addSubview:lineView];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, XQBHeightElement-0.25, MainWidth, 0.5)];
        bottomLineView.backgroundColor = XQBColorElementSeparationLine;
        [_dateSelecteView addSubview:bottomLineView];
        
        UIButton *dateSelectButton = [[UIButton alloc] initWithFrame:_dateSelecteView.frame];
        dateSelectButton.backgroundColor = [UIColor clearColor];
        [dateSelectButton addTarget:self action:@selector(dateSelectButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        
        [_dateSelecteView addSubview:dateSelectButton];
    }
    return _dateSelecteView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XQBHeightElement, WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = XQBColorBackground;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = self.tableViewFooterView;
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
        _tableView.separatorColor = XQBColorInternalSeparationLine;
    }
    return _tableView;
}

- (UIView *)tableViewFooterView
{
    if (!_tableViewFooterView) {
        _tableViewFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBHeightElement)];
        _tableViewFooterView.backgroundColor = XQBColorBackground;
        _tableViewFooterView.hidden = YES;
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 0.5)];
        lineLabel.backgroundColor = XQBColorElementSeparationLine;
        [_tableViewFooterView addSubview:lineLabel];
        
        _totolLabel = [[UILabel alloc] init];
        _totolLabel.font = XQBFontContent;
        _totolLabel.text = @"[合计]";
        _totolLabel.textColor = XQBColorExplain;
        [_tableViewFooterView addSubview:_totolLabel];
        
        _totalMoneyLabel = [[UILabel alloc] init];
        _totalMoneyLabel.font = XQBFontContent;
        _totalMoneyLabel.textColor = XQBColorGreen;
        _totalMoneyLabel.textAlignment = NSTextAlignmentRight;
        [_tableViewFooterView addSubview:_totalMoneyLabel];
    }
    
    return _tableViewFooterView;
}

//空白界面
- (BlankPageView *)noAllBillBlankPageView{
    if (_noAllBillBlankPageView == nil) {
        //空白界面
        WEAKSELF
        _noAllBillBlankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MainHeight)];
        _noAllBillBlankPageView.blankPageDidClickedBlock = ^(){
            [weakSelf requestEnableYearMonth];
        };
    }
    return _noAllBillBlankPageView;
}

- (BlankPageView *)noMonthBillBlankPageView{
    if (_noMonthBillBlankPageView == nil) {
        //空白界面
        WEAKSELF
        _noMonthBillBlankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, XQBHeightElement, SCREEN_WIDTH, MainHeight-XQBHeightElement)];
        _noMonthBillBlankPageView.blankPageDidClickedBlock = ^(){
            [weakSelf requestMyBill];
        };
    }
    return _noMonthBillBlankPageView;
}

#pragma mark --- refresh UI
- (void)refreshTableViewFooterView
{
    MonthBillsModel *currentMonthBillsModel = [[MonthBillsModel alloc] init];
    
    for (MonthBillsModel *mBillsModel in _allBillsArray) {
        if (_currentYear == [mBillsModel.year integerValue] && _currentMonth == [mBillsModel.month integerValue]) {
            currentMonthBillsModel = mBillsModel;
        }
    }
    
    _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%@", currentMonthBillsModel.totalMoney];
    
    CGSize size=[_totalMoneyLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, XQBHeightElement) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_totalMoneyLabel.font } context:nil].size;
    
    _totalMoneyLabel.frame = CGRectMake(MainWidth-XQBMarginHorizontal-size.width, 0, size.width, XQBHeightElement);
    _totolLabel.frame = CGRectMake(MainWidth-XQBMarginHorizontal-size.width-kTotolLabelWidth, 0, kTotolLabelWidth, XQBHeightElement);
    
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dateSelectButtonHandle:(UIButton *)sender
{
    if (!_dateSelectePopView) {
        _dateSelectePopView = [[DateSelectPopUpView alloc] initWithYearItems:_yearsArray andMonthItems:_monthsArray];
        
        __weak typeof(self) weakSelf = self;
        _dateSelectePopView.dateDidSelectedBlock = ^(NSInteger year, NSInteger month){
            weakSelf.currentYear = year;
            weakSelf.currentMonth = month;
            weakSelf.yearLabel.text = [NSString stringWithFormat:@"%ld年", weakSelf.currentYear];
            weakSelf.monthLabel.text = [NSString stringWithFormat:@"%ld月", weakSelf.currentMonth];
            [weakSelf requestMyBill];
            
            [weakSelf.dateSelectePopView dismiss];
        };
        
        [_dateSelectePopView showInView:self.view withOffset:UIOffsetMake(0, XQBHeightElement)];
    } else {
        [_dateSelectePopView dismiss];
        _dateSelectePopView = nil;
    }
}

#pragma mark --- other
- (UIImage *)configSectionIcon:(NSString *)title
{
    if ([title isEqualToString:@"水费"]) {
        return [UIImage imageNamed:@"bill_water_costs.png"];
    } else if ([title isEqualToString:@"电费"]) {
        return [UIImage imageNamed:@"bill_electricity_costs.png"];
    } else if ([title isEqualToString:@"燃气费"]) {
        return [UIImage imageNamed:@"bill_cas_costs.png"];
    } else if ([title isEqualToString:@"物业管理费"]) {
        return [UIImage imageNamed:@"bill_property_management_costs.png"];
    } else {
        return [UIImage imageNamed:@"bill_property_management_costs.png"];
    }
}

#pragma mark --- AFNetwork
- (void)requestEnableYearMonth
{
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+30)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    [_noAllBillBlankPageView removeFromSuperview];
    
    [manager GET:API_BILL_YEAR_MONTH_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        [XQBLoadingView hideLoadingForView:self.view];
        [_yearsArray removeAllObjects];
        [_monthsArray removeAllObjects];
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            NSArray *datesArray = [responseObject objectForKey:@"data"];
            for (NSDictionary *datesDic in datesArray) {
                [_yearsArray addObject:[datesDic objectForKey:@"year"]];
                
                NSArray *tmpMonthsArray = [datesDic objectForKey:@"months"];
                [_monthsArray addObject:tmpMonthsArray];
                
                _currentYear = [[datesDic objectForKey:@"year"] integerValue];
                _currentMonth = [[tmpMonthsArray objectAtIndex:tmpMonthsArray.count-1] integerValue];
            }
            
            if (_yearsArray.count > 0) {
                _dateSelecteView.hidden = NO;
                _yearLabel.text = [NSString stringWithFormat:@"%ld年", _currentYear];
                _monthLabel.text = [NSString stringWithFormat:@"%ld月", _currentMonth];
                [self requestMyBill];
            } else {
                _dateSelecteView.hidden = YES;
                [self.view addSubview:self.noAllBillBlankPageView];
                [_noAllBillBlankPageView resetImage:[UIImage imageNamed:@"server_error.png"]];
                [_noAllBillBlankPageView resetTitle:NO_DATA_MY_BILL andDescribe:@""];
            }
        } else {
            //加载服务器异常界面
            [self.view addSubview:self.noAllBillBlankPageView];
            [_noAllBillBlankPageView resetImage:[UIImage imageNamed:@"server_error.png"]];
            [_noAllBillBlankPageView resetTitle:SERVER_ERROR andDescribe:SERVER_ERROR_DESCRIBE];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [XQBLoadingView hideLoadingForView:self.view];
        [self.view addSubview:self.noAllBillBlankPageView];
        [_noAllBillBlankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
        [_noAllBillBlankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
    }];
}


- (void)requestMyBill
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currentYear] forKey:@"year"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currentMonth] forKey:@"month"];
    [parameters setObject:@"1" forKey:@"number"];
    
    [parameters addSignatureKey];
    
    [_noMonthBillBlankPageView removeFromSuperview];
    
    [manager GET:API_BILL_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        XQBLog(@"\nresponseObject:%@", responseObject);
        [_allBillsArray removeAllObjects];
        
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            NSArray *dataArray = [responseObject objectForKey:@"data"];
            
            for (NSDictionary *dataDic in dataArray) {
                MonthBillsModel *mBillsModel    = [[MonthBillsModel alloc] init];
                mBillsModel.year                = [[dataDic objectForKey:@"year"] stringValue];
                mBillsModel.month               = [[dataDic objectForKey:@"month"] stringValue];
                mBillsModel.isNeedPay           = [[dataDic objectForKey:@"isNeedPay"] stringValue];
                mBillsModel.totalMoney          = [[dataDic objectForKey:@"totalMoney"] stringValue];
                mBillsModel.needPayMoney        = [[dataDic objectForKey:@"needPayMoney"] stringValue];
                
                NSArray *billsArray = [dataDic objectForKey:@"bills"];
                NSMutableArray *billsMutableArray = [[NSMutableArray alloc] init];
                for (NSDictionary *billDic in billsArray) {
                    MyBillModel *billModel  = [[MyBillModel alloc] init];
                    billModel.billId        = [[billDic objectForKey:@"id"] stringValue];
                    billModel.title         = [billDic objectForKey:@"title"];
                    billModel.total         = [[billDic objectForKey:@"total"] stringValue];
                    billModel.billStatus    = [billDic objectForKey:@"billStatus"];
                    billModel.billStartTime = [billDic objectForKey:@"billStartTime"];
                    billModel.billEndTime   = [billDic objectForKey:@"billEndTime"];
                    billModel.moneyOne      = [[billDic objectForKey:@"moneyOne"] stringValue];
                    billModel.oldArrears    = [[billDic objectForKey:@"oldArrears"] stringValue];
                    billModel.oldReadings   = [[billDic objectForKey:@"oldReadings"] stringValue];
                    billModel.readings      = [[billDic objectForKey:@"readings"] stringValue];
                    billModel.price         = [[billDic objectForKey:@"price"] stringValue];
                    billModel.count         = [[billDic objectForKey:@"count"] stringValue];
                    billModel.unit          = [billDic objectForKey:@"unit"];
                    billModel.damage        = [[billDic objectForKey:@"damage"] stringValue];
                    
                    [billsMutableArray addObject:billModel];
                }
                mBillsModel.myBills             = billsMutableArray;
                [_allBillsArray addObject:mBillsModel];
            }
            if (_allBillsArray.count == 0) {
                //加载没有账单界面
                [self.view addSubview:self.noMonthBillBlankPageView];
                [_noMonthBillBlankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
                [_noMonthBillBlankPageView resetTitle:NO_DATA_MY_BILL andDescribe:@""];
            } else {
                _tableViewFooterView.hidden = NO;
                [self refreshTableViewFooterView];
                [_tableView reloadData];
            }
            
        } else {
            //加载服务器异常界面
            [self.view addSubview:self.noMonthBillBlankPageView];
            [_noMonthBillBlankPageView resetImage:[UIImage imageNamed:@"server_error.png"]];
            [_noMonthBillBlankPageView resetTitle:SERVER_ERROR andDescribe:SERVER_ERROR_DESCRIBE];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [self.view addSubview:self.noMonthBillBlankPageView];
        [_noMonthBillBlankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
        [_noMonthBillBlankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
    }];
}

#pragma mark --- table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MonthBillsModel *currentMonthBillsModel = [[MonthBillsModel alloc] init];
    
    for (MonthBillsModel *mBillsModel in _allBillsArray) {
        if (_currentYear == [mBillsModel.year integerValue] && _currentMonth == [mBillsModel.month integerValue]) {
            currentMonthBillsModel = mBillsModel;
        }
    }
    
    return currentMonthBillsModel.myBills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    XQBMeMyBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[XQBMeMyBillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    MonthBillsModel *currentMonthBillsModel = [[MonthBillsModel alloc] init];
    
    for (MonthBillsModel *mBillsModel in _allBillsArray) {
        if (_currentYear == [mBillsModel.year integerValue] && _currentMonth == [mBillsModel.month integerValue]) {
            currentMonthBillsModel = mBillsModel;
        }
    }
    
    MyBillModel *billModel = (currentMonthBillsModel.myBills.count>indexPath.row)?[currentMonthBillsModel.myBills objectAtIndex:indexPath.row]:nil;
    
    cell.iconView.image = [self configSectionIcon:billModel.title];
    cell.title.text = billModel.title;
    cell.totalPrice.text = [NSString stringWithFormat:@"￥%@", billModel.total];
    cell.billStatus.text = billModel.billStatus;
    if ([billModel.billStatus isEqualToString:@"已缴费"]) {
        cell.billStatus.textColor = XQBColorGreen;
    } else if ([billModel.billStatus isEqualToString:@"待缴"]) {
        cell.billStatus.textColor = XQBColorOrange;
    } else if ([billModel.billStatus isEqualToString:@"逾期"]) {
        cell.billStatus.textColor = XQBColorOrange;
    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MonthBillsModel *currentMonthBillsModel = [[MonthBillsModel alloc] init];
    
    for (MonthBillsModel *mBillsModel in _allBillsArray) {
        if (_currentYear == [mBillsModel.year integerValue] && _currentMonth == [mBillsModel.month integerValue]) {
            currentMonthBillsModel = mBillsModel;
        }
    }
    
    MyBillModel *tmpBillModel = (currentMonthBillsModel.myBills.count>indexPath.row)?[currentMonthBillsModel.myBills objectAtIndex:indexPath.row]:nil;
    
    XQBMeMyBillDetailsViewController *myBillDetailsVC = [[XQBMeMyBillDetailsViewController alloc] init];
    myBillDetailsVC.billModel = tmpBillModel;
    [self.navigationController pushViewController:myBillDetailsVC animated:YES];
}

@end
