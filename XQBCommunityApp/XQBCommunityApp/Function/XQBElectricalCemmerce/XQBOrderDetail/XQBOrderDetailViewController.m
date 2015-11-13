//
//  XQBOrderDetailViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBOrderDetailViewController.h"
#import "Global.h"
#import "XQBPayManager.h"
#import "UPPayPlugin.h"
#import "NSObject_extra.h"
#import "MakePhoneCall.h"
#import "ECOrderDetailModel.h"
#import "ECOrderItemModel.h"
#import "PricesShown.h"
#import "SGPaymentOptionsView.h"
#import "XQBPayManager.h"
#import "XQBECProductDetailViewController.h"
#import "UPPayPlugin.h"
#import "NSObject_extra.h"
#import "MakePhoneCall.h"
#import "NSObject_extra.h"
#import "BlankPageView.h"
#import "ECOrderTableViewCell.h"
#import "XQBMeMyOrderViewController.h"
#import "XQBECProductDetailViewController.h"
#import "XQBECShoppingCartViewController.h"

#define DOVCLargeItemHeight 66
#define DOVCSamllItemHeight 44
#define DOVCHorizontalMargin 14

#define DOVCLargeLabelHeight 17
#define DOVCSamllLabelHeigth 14

@interface XQBOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate,UPPayPluginDelegate>
@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) CommunityHttpRequest *request;

@property (nonatomic, strong) ECOrderDetailModel *detailOrderModel;

@property (nonatomic, strong) UILabel *orderStatusLabel;
@property (nonatomic, strong) UILabel *orderPriceLabel;
@property (nonatomic, strong) UILabel *shippingHeaderPriceLabel;
@property (nonatomic, strong) UILabel *consigneeLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *shippingAddressLabel;
@property (nonatomic, strong) UILabel *logisticsStatusLabel;
@property (nonatomic, strong) UILabel *logisticsTimeLabel;

@property (nonatomic, strong) UILabel *shippingPriceLabel;
@property (nonatomic, strong) UILabel *paymentPriceLabel;
@property (nonatomic, strong) UILabel *orderSnLabel;
@property (nonatomic, strong) UILabel *alipayOrderIdLabel;
@property (nonatomic, strong) UILabel *transactionTimeLabel;

@property (nonatomic, strong) UIButton *deleteOrderButton;
@property (nonatomic, strong) UIButton *phoneButton;
@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic, strong) BlankPageView *blankPageView;

@property (nonatomic, strong) XQBPayManager *alipayManager;

@end

@implementation XQBOrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _detailOrderModel = [[ECOrderDetailModel alloc] init];
    }
    return self;
}

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"订单详情"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self createTableView];
    
    [self createSuspensionView];
    
    [self requestOrderDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UI
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight-DOVCSamllItemHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = XQBColorBackground;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionHeaderHeight = DOVCSamllItemHeight+10;
    _tableView.sectionFooterHeight = DOVCSamllItemHeight*2;
    _tableView.tableHeaderView = [self createTableHeaderView];
    _tableView.tableFooterView = [self createTableFooterView];
    _tableView.tableFooterView.hidden = YES;
    _tableView.separatorColor = XQBColorElementSeparationLine;
    [self.view addSubview:_tableView];
}

- (void)createSuspensionView
{
    UIView *suspensionView = [[UIView alloc] initWithFrame:CGRectMake(0, MainHeight-DOVCSamllItemHeight, MainWidth, DOVCSamllItemHeight)];
    suspensionView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 0.5)];
    lineView.backgroundColor = XQBColorInternalSeparationLine;
    [suspensionView addSubview:lineView];
    
    _deleteOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteOrderButton setFrame:CGRectMake(MainWidth/2 - 40, 5.5, 80, 33)];
    [_deleteOrderButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
    [_deleteOrderButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_deleteOrderButton.layer setMasksToBounds:YES];
    [_deleteOrderButton.layer setBorderColor:[XQBColorContent CGColor]];
    [_deleteOrderButton.layer setCornerRadius:3];
    [_deleteOrderButton.layer setBorderWidth:0.5];
    [suspensionView addSubview:_deleteOrderButton];
    
    _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_phoneButton setFrame:CGRectMake(MainWidth-80-DOVCHorizontalMargin, 5.5, 80, 33)];
    [_phoneButton setTitle:@"拨打电话" forState:UIControlStateNormal];
    [_phoneButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
    [_phoneButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_phoneButton.layer setMasksToBounds:YES];
    [_phoneButton.layer setBorderColor:[XQBColorContent CGColor]];
    [_phoneButton.layer setCornerRadius:3];
    [_phoneButton.layer setBorderWidth:0.5];
    [_phoneButton addTarget:self action:@selector(phoneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [suspensionView addSubview:_phoneButton];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setFrame:CGRectMake(MainWidth-80-DOVCHorizontalMargin, 5.5, 80, 33)];
    [_payButton setTitle:@"付款" forState:UIControlStateNormal];
    [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_payButton setBackgroundImage:[UIImage imageWithColor:RGB(250, 150, 0) size:_payButton.bounds.size] forState:UIControlStateNormal];
    [_payButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_payButton addTarget:self action:@selector(payButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_payButton.layer setMasksToBounds:YES];
    [_payButton.layer setCornerRadius:3];
    _payButton.hidden = YES;
    [suspensionView addSubview:_payButton];
    
    [self.view addSubview:suspensionView];
}

- (UIView *)createTableHeaderView
{
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainHeight, DOVCLargeItemHeight*3)];
    heardView.backgroundColor = [UIColor whiteColor];
    
    /*
     *交易状态栏
     */
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, DOVCLargeItemHeight)];
    statusView.backgroundColor = RGB(139, 139, 139);
    
    UIImageView *orderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, 13, 14, 16)];
    orderIcon.image = [UIImage imageNamed:@"mall_order.png"];
    [statusView addSubview:orderIcon];
    
    _orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin*2+14, 10.5, MainWidth-DOVCHorizontalMargin*3-14, DOVCLargeLabelHeight)];
    _orderStatusLabel.textColor = [UIColor whiteColor];
    _orderStatusLabel.font = [UIFont systemFontOfSize:12];
    [statusView addSubview:_orderStatusLabel];
    
    _orderPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderStatusLabel.frame.origin.x, _orderStatusLabel.frame.origin.y+_orderStatusLabel.frame.size.height, _orderStatusLabel.frame.size.width, DOVCSamllLabelHeigth)];
    _orderPriceLabel.textColor = [UIColor whiteColor];
    _orderPriceLabel.font = [UIFont systemFontOfSize:9];
    [statusView addSubview:_orderPriceLabel];
    
    _shippingHeaderPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderPriceLabel.frame.origin.x, _orderPriceLabel.frame.origin.y+_orderPriceLabel.frame.size.height, _orderPriceLabel.frame.size.width, DOVCSamllLabelHeigth)];
    _shippingHeaderPriceLabel.textColor = [UIColor whiteColor];
    _shippingHeaderPriceLabel.font = [UIFont systemFontOfSize:9];
    [statusView addSubview:_shippingHeaderPriceLabel];
    
    [heardView addSubview:statusView];
    
    /*
     *收货人和地址
     */
    UIImageView *addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, DOVCLargeItemHeight+13, 14, 16)];
    addressIcon.image = [UIImage imageNamed:@"shipping_address.png"];
    [heardView addSubview:addressIcon];
    
    _consigneeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin*2+14, DOVCLargeItemHeight+10.5, MainWidth-DOVCHorizontalMargin*3-14-90, DOVCLargeLabelHeight)];
    _consigneeLabel.textColor = XQBColorContent;
    _consigneeLabel.font = [UIFont systemFontOfSize:12];
    [heardView addSubview:_consigneeLabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_consigneeLabel.frame.origin.x+_consigneeLabel.frame.size.width, _consigneeLabel.frame.origin.y, 90, DOVCLargeLabelHeight)];
    _phoneLabel.textColor = XQBColorContent;
    _phoneLabel.font = [UIFont systemFontOfSize:12];
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    [heardView addSubview:_phoneLabel];
    
    _shippingAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_consigneeLabel.frame.origin.x, _consigneeLabel.frame.origin.y+_consigneeLabel.frame.size.height+5, MainWidth-_consigneeLabel.frame.origin.x, 28)];
    _shippingAddressLabel.textColor = XQBColorExplain;
    _shippingAddressLabel.font = [UIFont systemFontOfSize:9];
    _shippingAddressLabel.numberOfLines = 0;
    [heardView addSubview:_shippingAddressLabel];
    
    //分隔线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, DOVCLargeItemHeight*2-0.5, MainWidth - DOVCHorizontalMargin, 0.5)];
    lineView.backgroundColor = XQBColorInternalSeparationLine;
    [heardView addSubview:lineView];
    
    /*
     *物流信息栏
     */
    UIImageView *logisticsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, DOVCLargeItemHeight*2+26, 14, DOVCSamllLabelHeigth)];
    logisticsIcon.image = [UIImage imageNamed:@"logistics.png"];
    [heardView addSubview:logisticsIcon];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin+6.75, logisticsIcon.frame.origin.y+logisticsIcon.frame.size.height, 0.5, DOVCLargeItemHeight*3-logisticsIcon.frame.origin.y-logisticsIcon.frame.size.height)];
    lineView1.backgroundColor = XQBColorInternalSeparationLine;
    [heardView addSubview:lineView1];
    
    UILabel *logisticsLabel = [[UILabel alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin*2+14, DOVCLargeItemHeight*2+10.5, MainWidth-DOVCHorizontalMargin*3-14, DOVCLargeLabelHeight)];
    logisticsLabel.text = @"物流信息";
    logisticsLabel.textColor = XQBColorContent;
    logisticsLabel.font = [UIFont systemFontOfSize:12];
    [heardView addSubview:logisticsLabel];
    
    _logisticsStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(logisticsLabel.frame.origin.x, logisticsLabel.frame.origin.y+logisticsLabel.frame.size.height, logisticsLabel.frame.size.width, DOVCSamllLabelHeigth)];
    _logisticsStatusLabel.textColor = XQBColorGreen;
    _logisticsStatusLabel.font = [UIFont systemFontOfSize:8];
    [heardView addSubview:_logisticsStatusLabel];
    
    _logisticsTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logisticsStatusLabel.frame.origin.x, _logisticsStatusLabel.frame.origin.y+_logisticsStatusLabel.frame.size.height, _logisticsStatusLabel.frame.size.width, DOVCSamllLabelHeigth)];
    _logisticsTimeLabel.textColor = XQBColorExplain;
    _logisticsTimeLabel.font = [UIFont systemFontOfSize:8];
    [heardView addSubview:_logisticsTimeLabel];
    
    //分隔线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, DOVCLargeItemHeight*3-0.5, MainWidth, 0.5)];
    lineView2.backgroundColor = XQBColorInternalSeparationLine;
    [heardView addSubview:lineView2];
    
    return heardView;
}

- (UIView *)createTableFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, DOVCSamllItemHeight+DOVCLargeItemHeight)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, 0, MainWidth-DOVCHorizontalMargin, 0.5)];
    lineView1.backgroundColor = XQBColorInternalSeparationLine;
    [footerView addSubview:lineView1];
    
    /*
     *运费栏
     */
    UILabel *shippingLabel = [[UILabel alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, (DOVCSamllItemHeight-DOVCSamllLabelHeigth*2)/2, (MainWidth-DOVCHorizontalMargin*2)/2, DOVCSamllLabelHeigth)];
    shippingLabel.text = @"运费：";
    shippingLabel.textColor = XQBColorExplain;
    shippingLabel.font = [UIFont systemFontOfSize:9];
    [footerView addSubview:shippingLabel];
    
    _shippingPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(shippingLabel.frame.origin.x+shippingLabel.frame.size.width, shippingLabel.frame.origin.y, (MainWidth-DOVCHorizontalMargin*2)/2, DOVCSamllLabelHeigth)];
    _shippingPriceLabel.textColor = XQBColorExplain;
    _shippingPriceLabel.font = [UIFont systemFontOfSize:9];
    _shippingPriceLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:_shippingPriceLabel];
    
    UILabel *paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, shippingLabel.frame.origin.y+shippingLabel.frame.size.height, (MainWidth-DOVCHorizontalMargin*2)/2, DOVCSamllLabelHeigth)];
    paymentLabel.text = @"实付款(含运费):";
    paymentLabel.textColor = XQBColorExplain;
    paymentLabel.font = [UIFont systemFontOfSize:9];
    [footerView addSubview:paymentLabel];
    
    _paymentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(paymentLabel.frame.origin.x+paymentLabel.frame.size.width, paymentLabel.frame.origin.y, (MainWidth-DOVCHorizontalMargin*2)/2, DOVCSamllLabelHeigth)];
    _paymentPriceLabel.textColor = [UIColor orangeColor];
    _paymentPriceLabel.font = [UIFont systemFontOfSize:9];
    _paymentPriceLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:_paymentPriceLabel];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, DOVCSamllItemHeight-0.5, MainWidth-DOVCHorizontalMargin, 0.5)];
    lineView2.backgroundColor = XQBColorInternalSeparationLine;
    [footerView addSubview:lineView2];
    
    /*
     *订单号栏
     */
    UILabel *orderIdTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, DOVCSamllItemHeight+(DOVCLargeItemHeight-DOVCSamllLabelHeigth*3)/2, (MainWidth-DOVCHorizontalMargin*2)/2, DOVCSamllLabelHeigth)];
    orderIdTextLabel.text = @"订单号：";
    orderIdTextLabel.textColor = XQBColorExplain;
    orderIdTextLabel.font = [UIFont systemFontOfSize:9];
    [footerView addSubview:orderIdTextLabel];
    
    _orderSnLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderIdTextLabel.frame.origin.x+orderIdTextLabel.frame.size.width, orderIdTextLabel.frame.origin.y, (MainWidth-DOVCHorizontalMargin*2)/2, DOVCSamllLabelHeigth)];
    _orderSnLabel.textColor = XQBColorExplain;
    _orderSnLabel.font = [UIFont systemFontOfSize:9];
    _orderSnLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:_orderSnLabel];
    
    UILabel *alipayOrderIdTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, orderIdTextLabel.frame.origin.y+orderIdTextLabel.frame.size.height, (MainWidth-DOVCHorizontalMargin*2)/2, DOVCSamllLabelHeigth)];
    alipayOrderIdTextLabel.text = @"支付宝订单号：";
    alipayOrderIdTextLabel.textColor = XQBColorExplain;
    alipayOrderIdTextLabel.font = [UIFont systemFontOfSize:9];
    [footerView addSubview:alipayOrderIdTextLabel];
    
    _alipayOrderIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(alipayOrderIdTextLabel.frame.origin.x+alipayOrderIdTextLabel.frame.size.width, alipayOrderIdTextLabel.frame.origin.y, (MainWidth-DOVCHorizontalMargin*2)/2, DOVCSamllLabelHeigth)];
    _alipayOrderIdLabel.textColor = XQBColorExplain;
    _alipayOrderIdLabel.font = [UIFont systemFontOfSize:9];
    _alipayOrderIdLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:_alipayOrderIdLabel];
    
    UILabel *transactionTimeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, alipayOrderIdTextLabel.frame.origin.y+alipayOrderIdTextLabel.frame.size.height, (MainWidth-DOVCHorizontalMargin*2)/2, DOVCSamllLabelHeigth)];
    transactionTimeTextLabel.text = @"成交时间：";
    transactionTimeTextLabel.textColor = XQBColorExplain;
    transactionTimeTextLabel.font = [UIFont systemFontOfSize:9];
    [footerView addSubview:transactionTimeTextLabel];
    
    _transactionTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(transactionTimeTextLabel.frame.origin.x+transactionTimeTextLabel.frame.size.width, transactionTimeTextLabel.frame.origin.y, (MainWidth-DOVCHorizontalMargin*2)/2, DOVCSamllLabelHeigth)];
    _transactionTimeLabel.textColor = XQBColorExplain;
    _transactionTimeLabel.font = [UIFont systemFontOfSize:9];
    _transactionTimeLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:_transactionTimeLabel];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, DOVCSamllItemHeight+DOVCLargeItemHeight-0.5, MainWidth, 0.5)];
    lineView3.backgroundColor = XQBColorInternalSeparationLine;
    [footerView addSubview:lineView3];
    
    return footerView;
}

- (void)refreshUI
{
    _orderStatusLabel.text = _detailOrderModel.orderStatus;
    _orderPriceLabel.text = [NSString stringWithFormat:@"订单金额（含运费）：￥%@", _detailOrderModel.payFee];
    _shippingHeaderPriceLabel.text = [NSString stringWithFormat:@"运费：￥%@", _detailOrderModel.shippingFee];
    _consigneeLabel.text = [NSString stringWithFormat:@"收货人：%@", _detailOrderModel.consignee];
    _phoneLabel.text = _detailOrderModel.phone;
    _shippingAddressLabel.text = [NSString stringWithFormat:@"收货地址：%@", _detailOrderModel.address];
    if (_detailOrderModel.shippingNote.length == 0) {
        _logisticsStatusLabel.text = @"快递：暂无";
    } else {
        _logisticsStatusLabel.text = [NSString stringWithFormat:@"快递：%@", _detailOrderModel.shippingNote];
    }
    
    if (_detailOrderModel.shippingSn.length == 0) {
        _logisticsTimeLabel.text = @"单号：暂无";
    } else {
        _logisticsTimeLabel.text = [NSString stringWithFormat:@"单号：%@", _detailOrderModel.shippingSn];
    }
    
    _shippingPriceLabel.text = [NSString stringWithFormat:@"￥%@", _detailOrderModel.shippingFee];
    _paymentPriceLabel.text = [NSString stringWithFormat:@"￥%@", _detailOrderModel.payFee];
    _orderSnLabel.text = _detailOrderModel.orderSn;
    _alipayOrderIdLabel.text = _detailOrderModel.paySn;
    _transactionTimeLabel.text = _detailOrderModel.createTime;
    
    if ([_detailOrderModel.orderStatus isEqualToString:@"待付款"]) {
        _payButton.hidden = NO;
        _phoneButton.frame = CGRectMake(MainWidth/2 - 40, 5.5, 80, 33);
        [_deleteOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
        _deleteOrderButton.frame = CGRectMake(DOVCHorizontalMargin, 5.5, 80, 33);
        [_deleteOrderButton removeTarget:self action:@selector(deleteOrderButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_deleteOrderButton addTarget:self action:@selector(cancelOrderBUttonAction) forControlEvents:UIControlEventTouchUpInside];
    } else if ([_detailOrderModel.orderStatus isEqualToString:@"交易完成"] || [_detailOrderModel.orderStatus isEqualToString:@"交易关闭"] || [_detailOrderModel.orderStatus isEqualToString:@"已过期"]) {
        _payButton.hidden = YES;
        [_phoneButton setFrame:CGRectMake(MainWidth-80-DOVCHorizontalMargin, 5.5, 80, 33)];
        [_deleteOrderButton setTitle:@"删除订单" forState:UIControlStateNormal];
        _deleteOrderButton.frame = CGRectMake(MainWidth/2 - 40, 5.5, 80, 33);
        [_deleteOrderButton removeTarget:self action:@selector(cancelOrderBUttonAction) forControlEvents:UIControlEventTouchUpInside];
        [_deleteOrderButton addTarget:self action:@selector(deleteOrderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    } else {
        _payButton.hidden = YES;
        [_phoneButton setFrame:CGRectMake(MainWidth-80-DOVCHorizontalMargin, 5.5, 80, 33)];
        _deleteOrderButton.hidden = YES;
    }
    
    [_tableView reloadData];
    _tableView.tableFooterView.hidden = NO;
}

//空白界面
- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        WEAKSELF
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MainHeight)];
        _blankPageView.blankPageDidClickedBlock = ^(){
            [weakSelf requestOrderDetail];
        };
    }
    return _blankPageView;
}


#pragma mark --- action
- (void)leftBtnAction
{
    for (int i = self.navigationController.viewControllers.count-1; i>-1;i--) {
        UIViewController *tempViewController = [self.navigationController.viewControllers objectAtIndex:i];
        if ([tempViewController isKindOfClass:[XQBMeMyOrderViewController class]]) {
            [self.navigationController popToViewController:tempViewController animated:YES];
            return;
        } else if ([tempViewController isKindOfClass:[XQBECProductDetailViewController class]]) {
            [self.navigationController popToViewController:tempViewController animated:YES];
            return;
        } else if ([tempViewController isKindOfClass:[XQBECShoppingCartViewController class]]) {
            [self.navigationController popToViewController:tempViewController animated:YES];
            return;
        }
    }
}

- (void)cancelOrderBUttonAction
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否取消订单" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 100;
    [alert show];
}

- (void)deleteOrderButtonAction
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否删除订单" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 101;
    [alert show];
}

- (void)phoneButtonAction
{
    MakePhoneCall *instance = [MakePhoneCall getInstance];
    BOOL call_ok = [instance makeCall:@"4008338528"];
    
    if (call_ok) {
        //上报
        //        [self requestReport:model.shopId];
    }else{
        MsgBox(@"设备不支持电话功能");
        //[self alertWithFistButton:@"确定" SencodButton:nil Message:@"设备不支持电话功能"];
    }
}

- (void)payButtonAction
{
    SGPaymentOptionsView *view = [SGPaymentOptionsView sharePaymentSheet];
    view.payActionHandler = ^(NSInteger index){
        switch (index) {
            case 0:     //银联支付
            {
                NSString *strOrderId = [NSString stringWithFormat:@"%@",self.orderId];
                XQBPayManager *paymanager = [[XQBPayManager alloc] init];
                [paymanager orderUnionPay:strOrderId];
                paymanager.paymentUnionCallBackBlock = ^(NSString *reMsg){
                    [UPPayPlugin startPay:reMsg mode:UNION_PAY_PLUGIN_ENVIRONMENT viewController:self delegate:self];
                };
                paymanager.paymentUnionResultBlock = ^(NSString *result){
                    //银联支付返回结果
                    
                };
            }
                break;
            case 1:     //支付宝支付
            {
                NSString *strOrderId = [NSString stringWithFormat:@"%@",self.orderId];
                XQBPayManager *paymanager = [[XQBPayManager alloc] init];
                self.alipayManager = paymanager;
                //支付宝返回结果回调
                paymanager.paymentAliResultBlock = ^(NSDictionary *result) {
                    [self requestOrderDetail];
                    self.alipayManager = nil;
                };
                [paymanager orderAlipay:strOrderId];

            }
                break;
            default:
                break;
        }
    };
    [SGActionView showCustomView:view animation:YES];
}

#pragma mark --- network request
- (void)requestOrderDetail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [manager GET:EC_ORDER_INFO_URL(_orderId)
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [_blankPageView removeFromSuperview];
             
             if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
                 NSDictionary *dic = [responseObject objectForKey:@"order"];
                 
                 _detailOrderModel.orderId = DealWithJSONValue([dic objectForKey:@"orderId"]);
                 _detailOrderModel.orderSn = DealWithJSONValue([dic objectForKey:@"orderSn"]);
                 _detailOrderModel.orderStatus = DealWithJSONValue([dic objectForKey:@"orderStatus"]);
                 _detailOrderModel.payFee = DealWithJSONValue([dic objectForKey:@"payFee"]);
                 _detailOrderModel.payNote = DealWithJSONValue([dic objectForKey:@"payNote"]);
                 _detailOrderModel.payTime = DealWithJSONValue([dic objectForKey:@"payTime"]);
                 _detailOrderModel.paySn = DealWithJSONValue([dic objectForKey:@"paySn"]);
                 _detailOrderModel.shippingFee = DealWithJSONValue([dic objectForKey:@"shippingFee"]);
                 _detailOrderModel.shippingNote = DealWithJSONValue([dic objectForKey:@"shippingNote"]);
                 _detailOrderModel.shippingSn = DealWithJSONValue([dic objectForKey:@"shippingSn"]);
                 _detailOrderModel.shippingTime = DealWithJSONValue([dic objectForKey:@"shippingTime"]);
                 _detailOrderModel.weight = DealWithJSONValue([dic objectForKey:@"weight"]);
                 _detailOrderModel.consignee = DealWithJSONValue([dic objectForKey:@"consignee"]);
                 _detailOrderModel.address = DealWithJSONValue([dic objectForKey:@"address"]);
                 _detailOrderModel.phone = DealWithJSONValue([dic objectForKey:@"phone"]);
                 _detailOrderModel.email = DealWithJSONValue([dic objectForKey:@"email"]);
                 _detailOrderModel.zipcode = DealWithJSONValue([dic objectForKey:@"zipcode"]);
                 _detailOrderModel.createTime = DealWithJSONValue([dic objectForKey:@"createTime"]);
                 
                 if (![[dic objectForKey:@"orderItems"] isKindOfClass:[NSNull class]]) {
                     NSMutableArray *orderItemsMutableArray = [[NSMutableArray alloc] init];
                     NSArray *orderItemsArray = [dic objectForKey:@"orderItems"];
                     for (NSDictionary *itemsDic in orderItemsArray) {
                         ECOrderItemModel *orderItemModel = [[ECOrderItemModel alloc] init];
                         orderItemModel.productId = DealWithJSONValue([itemsDic objectForKey:MOOIProductId]);
                         orderItemModel.productItemId = DealWithJSONValue([itemsDic objectForKey:MOOIProductItemId]);
                         orderItemModel.productName = DealWithJSONValue([itemsDic objectForKey:MOOIProductName]);
                         orderItemModel.cover = DealWithJSONValue([itemsDic objectForKey:MOOICover]);
                         orderItemModel.measure = DealWithJSONValue([itemsDic objectForKey:MOOIMeasure]);
                         orderItemModel.unit = DealWithJSONValue([itemsDic objectForKey:MOOIUnit]);
                         orderItemModel.itemNumber= DealWithJSONValue([itemsDic objectForKey:MOOIItemNumber]);
                         orderItemModel.price = DealWithJSONValue([itemsDic objectForKey:MOOIPrice]);

                         [orderItemsMutableArray addObject:orderItemModel];
                         
                     }
                     _detailOrderModel.orderItems = orderItemsMutableArray;
                    
                 }
                 [self refreshUI];
             } else {
                 
                 [self.view addSubview:[self blankPageView]];
                 [_blankPageView resetImage:[UIImage imageNamed:@"server_error.png"]];
                 [_blankPageView resetTitle:SERVER_ERROR andDescribe:SERVER_ERROR_DESCRIBE];
                 
             }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XQBLog(@"网络异常,请求订单详情失败");
        [self.view addSubview:[self blankPageView]];
        [_blankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
        [_blankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
        
    }];

}

- (void)requestOrderCancel
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:_orderId forKey:@"orderId"];
    [parameters addSignatureKey];
    
    [manager GET:EC_ORDERS_CANCEL_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self.view.window makeCustomToast:@"订单已成功取消"];
            [self leftBtnAction];
        }else{
            [self.view.window makeCustomToast:@"服务器出错了"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XQBLog(@"网络异常");
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];

}

- (void)requestOrderDelete
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:_orderId forKey:@"orderId"];
    [parameters addSignatureKey];
    
    [manager GET:EC_ORDERS_DELETE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self.view.window makeCustomToast:@"订单已成功删除"];
            
            [self leftBtnAction];
        }else{
            [self.view.window makeCustomToast:@"服务器出错了"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XQBLog(@"网络异常");
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];

}


#pragma mark ----union pay result callback
//银联支付结果回调
- (void) returnWithResult:(NSString *)strResult{
    if (strResult) {
        //上报服务器结果
        
        //[self reportPayResult:strResult];
    }
}

-(void)UPPayPluginResult:(NSString*)result{
    NSString* msg = [NSString stringWithFormat:kResult, result];
    if ([result isEqualToString:@"success"]) {
        MsgBox(@"支付成功");
        [self requestOrderDetail];
        //[self alertWithFistButton:@"确定" SencodButton:nil Message:@"支付成功"];
    }else{
        MsgBox(msg);
        //[self alertWithFistButton:@"确定" SencodButton:nil Message:msg];
    }
    
}

#pragma mark --- UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100 ) {
        if (buttonIndex == 0) {
            [self requestOrderCancel];
        }
    } else if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            [self requestOrderDelete];
        }
    }
}

#pragma mark --- tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailOrderModel.orderItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ECOrderItemModel *orderItemModel = ([_detailOrderModel.orderItems count] > indexPath.row)?[_detailOrderModel.orderItems objectAtIndex:indexPath.row]:nil;
    
    static NSString *identifier = @"Cell";
    
    ECOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ECOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.shoppingIconView sd_setImageWithURL:[NSURL URLWithString:orderItemModel.cover] placeholderImage:[UIImage imageNamed:@"default_rect_placeholder_image.png"]];
    cell.shoppingNameLabel.text = orderItemModel.productName;
    cell.shoppingTypeLabel.text = [NSString stringWithFormat:@"容量分类：%@%@", orderItemModel.measure, orderItemModel.unit];
    if ([_detailOrderModel.orderStatus isEqualToString:@"待付款"]) {
        cell.afterSalesButton.hidden = YES;
    } else if ([_detailOrderModel.orderStatus isEqualToString:@"待发货"]) {
        cell.afterSalesButton.hidden = NO;
    }
    cell.shoppingPriceLabel.text = [PricesShown priceOfShorthand:[orderItemModel.price doubleValue]];
    
    cell.shoppingCountLabel.text = [NSString stringWithFormat:@"×%@", orderItemModel.itemNumber];
    
    return cell;

}

#pragma mark --- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, DOVCSamllItemHeight+10)] ;
    backgroundView.backgroundColor = XQBColorBackground;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10-0.5, MainWidth, 0.5)];
    lineView2.backgroundColor = XQBColorInternalSeparationLine;
    [backgroundView addSubview:lineView2];
    
    UIView *heardItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainWidth, DOVCSamllItemHeight)];
    heardItemView.backgroundColor = [UIColor whiteColor];
    
    UIButton *orderNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGSize size = [[NSString stringWithFormat:@"    %@", _detailOrderModel.orderSn] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, DOVCSamllItemHeight) lineBreakMode:NSLineBreakByWordWrapping];
    
    orderNameButton.frame = CGRectMake(DOVCHorizontalMargin, 0, size.width+16+DOVCHorizontalMargin+14, DOVCSamllItemHeight);
    [orderNameButton setImage:[UIImage imageNamed:@"mall_store.png"] forState:UIControlStateNormal];
    [orderNameButton setTitle:[NSString stringWithFormat:@"    %@", _detailOrderModel.orderSn] forState:UIControlStateNormal];
    [orderNameButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
    [orderNameButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [orderNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [heardItemView addSubview:orderNameButton];
    
    UIImageView *arrowIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_icon.png"]];
    arrowIconView.frame = CGRectMake(size.width+16+DOVCHorizontalMargin, 15, 14, DOVCSamllLabelHeigth);
    [orderNameButton addSubview:arrowIconView];
    
    UILabel *transactionStatuslabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth-DOVCHorizontalMargin-70, 0, 70, DOVCSamllItemHeight)];
    transactionStatuslabel.text = _detailOrderModel.orderStatus;
    transactionStatuslabel.textColor = XQBColorGreen;
    transactionStatuslabel.font = [UIFont systemFontOfSize:10];
    transactionStatuslabel.textAlignment = UIControlContentHorizontalAlignmentRight;
    [heardItemView addSubview:transactionStatuslabel];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(DOVCHorizontalMargin, DOVCSamllItemHeight-0.5, MainWidth-DOVCHorizontalMargin, 0.5)];
    lineView3.backgroundColor = XQBColorInternalSeparationLine;
    [heardItemView addSubview:lineView3];
    
    [backgroundView addSubview:heardItemView];
    
    return backgroundView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECOrderItemModel *orderItemModel = ([_detailOrderModel.orderItems count] > indexPath.row)?[_detailOrderModel.orderItems objectAtIndex:indexPath.row]:nil;
    XQBECProductDetailViewController *viewController = [[XQBECProductDetailViewController alloc] init];
    viewController.productId = orderItemModel.productId;
    viewController.productIamgeUrl = orderItemModel.cover;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
