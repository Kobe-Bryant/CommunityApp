//
//  XQBMeMyOrderViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeMyOrderViewController.h"
#import "Global.h"
#import "CommonParameters.h"
#import "ECOrderInfoModel.h"
#import "ECOrderItemModel.h"
#import "SGPaymentOptionsView.h"
#import "XQBPayManager.h"
#import "WEPopoverController.h"
#import "XQBECProductDetailViewController.h"
#import "UPPayPlugin.h"
#import "NSObject_extra.h"
#import "MallPopListViewController.h"
#import "ECPopMenuItem.h"
#import "ECOrderDetailModel.h"
#import "PricesShown.h"
#import "ECOrderTableViewCell.h"
#import "XQBOrderDetailViewController.h"
#import "BlankPageView.h"
#import "XQBECShippingAddressViewController.h"
#import "XQBElectricalCemmerceViewController.h"
#import "XQBOrderDetailViewController.h"
#import "RefreshControl.h"
#import "GmailRefreshView.h"
#import "AMTumblrHudRefreshTopView.h"
#import "AMTumblrHudRefreshBottomView.h"

#define MOVCItemHeight 44
#define MOVCHorizontalMargin 14
#define MOVCSegmentedItemWidth (MainWidth-MOVCHorizontalMargin*2)/3

#define viewCount 3

@interface XQBMeMyOrderViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,UPPayPluginDelegate, WEPopoverControllerDelegate, RefreshControlDelegate>

@property (nonatomic, strong) UIScrollView *segmentedScorllView;
@property (nonatomic, strong) UIView *segmentedMarkView;
@property (nonatomic, strong) UIScrollView *tableViewScrollView;
@property (nonatomic, strong) WEPopoverController *mallPopoverController;

@property (nonatomic, strong) NSMutableArray *allOrdersArray;
@property (nonatomic, strong) NSMutableArray *waitingForPaymentArray;
@property (nonatomic, strong) NSMutableArray *waitingForShippingArray;

@property (nonatomic, assign) NSInteger allOrdersPage;
@property (nonatomic, assign) NSInteger waitingForPaymentPage;
@property (nonatomic, assign) NSInteger waitingForShippingPage;
@property (nonatomic, assign) NSInteger orderState;

@property (nonatomic, strong) RefreshControl *allOrderesRefrshControl;
@property (nonatomic, strong) RefreshControl *waitingForPaymentRefreshControl;
@property (nonatomic, strong) RefreshControl *waitingForShippingRefreshControl;

@property (nonatomic, strong) BlankPageView *blankPageView;

@property (nonatomic, strong) XQBPayManager *alipayManager;

@end

@implementation XQBMeMyOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _orderState = 0;
        _allOrdersArray = [[NSMutableArray alloc] initWithCapacity:0];
        _waitingForPaymentArray = [[NSMutableArray alloc] initWithCapacity:0];
        _waitingForShippingArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"闪购订单"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    BOOL isEcopen = YES;//[UserModel shareUser].isEcOpen;
    
    if (isEcopen) {
        UIButton *mallMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mallMoreButton addTarget:self action:@selector(popMallMoreView:) forControlEvents:UIControlEventTouchUpInside];
        mallMoreButton.frame = CGRectMake(0, 0, 30, 30);
        [mallMoreButton setImage:[UIImage imageNamed:@"shoppingmall_more_green.png"] forState:UIControlStateNormal];
        [self setRightBarButtonItems:@[mallMoreButton]];
    }
    
    NSArray *array = @[@"全部", @"待付款", @"待发货"];
    
    [self createSegmentedScorllView:array];
    
    [self createTableViewScrollView];
    
    [self addRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick event:UM_MY_ORDER_EVENT];
    [self refreshOrder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UI
- (void)createSegmentedScorllView:(NSArray *)array
{
    _segmentedScorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(MOVCHorizontalMargin, 0, MainWidth - MOVCHorizontalMargin*2, MOVCItemHeight)];
    [_segmentedScorllView setShowsHorizontalScrollIndicator:NO];
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(MOVCSegmentedItemWidth*i, 0, MOVCSegmentedItemWidth, MOVCItemHeight)];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:XQBColorGreen forState:UIControlStateSelected];
        [button setTitleColor:XQBColorContent forState:UIControlStateNormal];
        if (i == 0) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTag:i+1];
        [button addTarget:self action:@selector(segmentedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_segmentedScorllView addSubview:button];
    }
    
    _segmentedMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, MOVCItemHeight-2, MOVCSegmentedItemWidth, 2)];
    _segmentedMarkView.backgroundColor = XQBColorGreen;
    [_segmentedScorllView addSubview:_segmentedMarkView];
    
    [self.view addSubview:_segmentedScorllView];

}

- (void)createTableViewScrollView
{
    _tableViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentedScorllView.frame.size.height, MainWidth, MainHeight-_segmentedScorllView.frame.size.height)];
    [_tableViewScrollView setContentSize:CGSizeMake(_tableViewScrollView.frame.size.width*3, MainHeight-_segmentedScorllView.frame.size.height)];
    [_tableViewScrollView setPagingEnabled:YES];
    [_tableViewScrollView setShowsHorizontalScrollIndicator:NO];
    _tableViewScrollView.delegate = self;
    for (int i = 0; i < viewCount; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*_tableViewScrollView.frame.size.width, 0, _tableViewScrollView.frame.size.width, MainHeight-_segmentedScorllView.frame.size.height+MOVCItemHeight*2)];
        tableView.tag = i+1;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.sectionHeaderHeight = MOVCItemHeight+10;
        tableView.sectionFooterHeight = MOVCItemHeight*2;
        tableView.separatorColor = XQBColorInternalSeparationLine;
        [_tableViewScrollView addSubview:tableView];
    }
    [self.view addSubview:_tableViewScrollView];
}


//空白界面
- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        WEAKSELF
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MainHeight-_segmentedScorllView.frame.size.height)];
        _blankPageView.blankPageDidClickedBlock = ^(){
            weakSelf.allOrdersPage = 0;
            weakSelf.waitingForPaymentPage = 0;
            weakSelf.waitingForShippingPage = 0;
            [weakSelf requestMyOrderList:weakSelf.orderState];
        };
    }
    return _blankPageView;
}

- (void)refreshOrder
{
    _allOrdersPage = 0;
    _waitingForPaymentPage = 0;
    _waitingForShippingPage = 0;
    [self requestMyOrderList:_orderState];
}

#pragma mark ---MJRefresh
- (void)addRefreshControl
{
    UIScrollView *allOrderScrollView = [self.tableViewScrollView.subviews objectAtIndex:0];
    _allOrderesRefrshControl = [[RefreshControl alloc] initWithScrollView:allOrderScrollView delegate:self];
    _allOrderesRefrshControl.autoRefreshTop = YES;
    _allOrderesRefrshControl.autoRefreshBottom = YES;
    ///注册自定义的下拉刷新view
    [_allOrderesRefrshControl registerClassForTopView:[AMTumblrHudRefreshTopView class]];
    [_allOrderesRefrshControl registerClassForBottomView:[AMTumblrHudRefreshBottomView class]];
    ///设置显示下拉刷新
    _allOrderesRefrshControl.topEnabled=YES;
    _allOrderesRefrshControl.bottomEnabled = YES;

    UIScrollView *waitingForPaymentScrollView = [self.tableViewScrollView.subviews objectAtIndex:1];
    _waitingForPaymentRefreshControl = [[RefreshControl alloc] initWithScrollView:waitingForPaymentScrollView delegate:self];
    _waitingForPaymentRefreshControl.autoRefreshTop = YES;
    _waitingForPaymentRefreshControl.autoRefreshBottom = YES;
    ///注册自定义的下拉刷新view
    [_waitingForPaymentRefreshControl registerClassForTopView:[AMTumblrHudRefreshTopView class]];
    [_waitingForPaymentRefreshControl registerClassForBottomView:[AMTumblrHudRefreshBottomView class]];
    ///设置显示下拉刷新
    _waitingForPaymentRefreshControl.topEnabled=YES;
    _waitingForPaymentRefreshControl.bottomEnabled = YES;

    UIScrollView *waitingForShippingScrollView = [self.tableViewScrollView.subviews objectAtIndex:2];
    _waitingForShippingRefreshControl = [[RefreshControl alloc] initWithScrollView:waitingForShippingScrollView delegate:self];
    _waitingForShippingRefreshControl.autoRefreshTop = YES;
    _waitingForShippingRefreshControl.autoRefreshBottom = YES;
    ///注册自定义的下拉刷新view
    [_waitingForShippingRefreshControl registerClassForTopView:[AMTumblrHudRefreshTopView class]];
    [_waitingForShippingRefreshControl registerClassForBottomView:[AMTumblrHudRefreshBottomView class]];
    ///设置显示下拉刷新
    _waitingForShippingRefreshControl.topEnabled=YES;
    _waitingForShippingRefreshControl.bottomEnabled = YES;

}

#pragma mark --- action
- (void)leftBtnAction
{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentedButtonAction:(UIButton *)sender
{
    for (int i = 0 ; i < viewCount; i++) {
        UIButton *button = [_segmentedScorllView.subviews objectAtIndex:i];
        if (i == sender.tag - 1) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
    _orderState = sender.tag-1;
    [self refreshOrder];
    
    [_tableViewScrollView scrollRectToVisible:CGRectMake(_tableViewScrollView.frame.size.width * (sender.tag - 1), _tableViewScrollView.frame.origin.y, _tableViewScrollView.frame.size.width, _tableViewScrollView.frame.size.height) animated:YES];
}

- (void)orderNameButtonAction:(UIButton *)sender
{
    ECOrderDetailModel *orderModel;
    if (_orderState == 0) {
        orderModel = [_allOrdersArray objectAtIndex:sender.tag];
    } else if (_orderState == 1) {
        orderModel = [_waitingForPaymentArray objectAtIndex:sender.tag];
    } else if (_orderState == 2) {
        orderModel = [_waitingForShippingArray objectAtIndex:sender.tag];
    } else {
        orderModel = nil;
    }
    
    
    XQBOrderDetailViewController *detailVC = [[XQBOrderDetailViewController alloc] init];
    detailVC.orderId = orderModel.orderId;
    [self.navigationController pushViewController:detailVC animated:YES];

    
}

- (void)cancelOrderBUttonAction:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否取消订单" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = sender.tag;
    [alert show];
}

- (void)deleteOrderButtonAction:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否删除订单" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = sender.tag;
    [alert show];
}

- (void)payButtonAction:(UIButton *)sender
{
    SGPaymentOptionsView *view = [SGPaymentOptionsView sharePaymentSheet];
    
    ECOrderDetailModel *orderModel;
    if (_orderState == 0) {
        orderModel = [_allOrdersArray objectAtIndex:sender.tag];
    } else if (_orderState == 1) {
        orderModel = [_waitingForPaymentArray objectAtIndex:sender.tag];
    } else if (_orderState == 2) {
        orderModel = [_waitingForShippingArray objectAtIndex:sender.tag];
    } else {
        orderModel = nil;
    }
    
    view.payActionHandler = ^(NSInteger index){
        switch (index) {
            case 0:     //银联支付
            {
                NSString *strOrderId = [NSString stringWithFormat:@"%@", orderModel.orderId];
                XQBPayManager *paymanager = [[XQBPayManager alloc] init];
                [paymanager orderUnionPay:strOrderId];
                paymanager.paymentUnionCallBackBlock = ^(NSString *reMsg){
                    [UPPayPlugin startPay:reMsg mode:UNION_PAY_PLUGIN_ENVIRONMENT viewController:self delegate:self];

                };
                paymanager.paymentUnionResultBlock = ^(NSString *result){
                    //银联支付返回结果
                    [MobClick event:UM_MY_ORDER_EVENT];
                    
                };
            }
                break;
            case 1:     //支付宝支付
            {
                NSString *strOrderId = [NSString stringWithFormat:@"%@", orderModel.orderId];
                XQBPayManager *paymanager = [[XQBPayManager alloc] init];
                self.alipayManager = paymanager;
                //支付宝返回结果回调
                paymanager.paymentAliResultBlock = ^(NSDictionary *result) {
                    [MobClick event:UM_MY_ORDER_EVENT];
                    [self refreshOrder];
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

- (void)popMallMoreView:(UIButton *)sender{
    
    if (!self.mallPopoverController) {
        
        NSMutableArray *items = [NSMutableArray array];
        NSArray *itemTitles = [NSArray arrayWithObjects:@"闪购首页",@"收货地址", nil];
        for (int i = 0; i < [itemTitles count]; i++) {
            ECPopMenuItem *item = [[ECPopMenuItem alloc] init];
            item.title = [itemTitles objectAtIndex:i];
            [items addObject:item];
        }
        
        MallPopListViewController *contentViewController = [[MallPopListViewController alloc] initWithMenuItems:items];
        self.mallPopoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
        self.mallPopoverController.delegate = self;
        self.mallPopoverController.passthroughViews = nil;//[NSArray arrayWithObject:self.view];
        
        [self.mallPopoverController presentPopoverFromRect:CGRectMake(sender.frame.origin.x+30,sender.frame.origin.y, sender.frame.size.width+30, sender.frame.size.height+11)
                                                    inView:self.navigationController.view
                                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                                  animated:YES];
        
        contentViewController.popMenuDidSlectedCompled = ^(NSInteger index){
            switch (index) {
                case 0:
                {
                    self.navigationController.tabBarController.selectedIndex = 2;
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    
                    [self.mallPopoverController dismissPopoverAnimated:YES];
                    self.mallPopoverController.delegate = nil;
                    self.mallPopoverController = nil;
                }
                    break;
                case 1:
                {
                    
                    XQBECShippingAddressViewController *deliveryAddressVC = [[XQBECShippingAddressViewController alloc] init];
                    [self.navigationController pushViewController:deliveryAddressVC animated:YES];
                     
                    [self.mallPopoverController dismissPopoverAnimated:YES];
                    self.mallPopoverController.delegate = nil;
                    self.mallPopoverController = nil;
                }
                    
                    break;
                default:
                    break;
            }
        };
    } else {
        [self.mallPopoverController dismissPopoverAnimated:YES];
        self.mallPopoverController.delegate = nil;
        self.mallPopoverController = nil;
    }
}

#pragma mark --- network request
- (void)requestMyOrderList:(NSInteger)status
{
    [_blankPageView removeFromSuperview];
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+30+MOVCItemHeight)];
    
    NSInteger page = 0;
    
    if (status == 0) {
        page = ++_allOrdersPage;
    } else if (status == 1) {
        page = ++_waitingForPaymentPage;
    } else if (status == 2) {
        page = ++_waitingForShippingPage;
    }
    
    UITableView *tableView = [_tableViewScrollView.subviews objectAtIndex:status];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    NSString *pageStr = [[NSNumber numberWithInteger:page] stringValue];
    NSString *orderStateStr = [[NSNumber numberWithInteger:_orderState] stringValue];
    [parameters setObject:pageStr forKey:@"page"];
    [parameters setObject:orderStateStr forKey:@"status"];
    
    [parameters addSignatureKey];
    
    [manager GET:EC_ORDERS_LIST_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [XQBLoadingView hideLoadingForView:self.view];
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            if (_orderState == 0 && _allOrdersPage < 2) {
                [_allOrdersArray removeAllObjects];
            } else if (_orderState == 1 && _waitingForPaymentPage < 2) {
                [_waitingForPaymentArray removeAllObjects];
            } else if (_orderState == 2 && _waitingForShippingPage < 2) {
                [_waitingForShippingArray removeAllObjects];
            }

            NSArray *orderArray = [responseObject objectForKey: @"orders"];
            for (NSDictionary *dic in orderArray) {
                ECOrderDetailModel *orderModel = [[ECOrderDetailModel alloc] init];
                orderModel.orderId = [[dic objectForKey:@"orderId"] stringValue];//DealWithJSONValue() ;
                orderModel.orderSn = DealWithJSONValue([dic objectForKey:@"orderSn"]);
                orderModel.orderStatus = DealWithJSONValue([dic objectForKey:@"orderStatus"]);
                orderModel.createTime = DealWithJSONValue([dic objectForKey:@"createTime"]);
                orderModel.payFee = DealWithJSONValue([dic objectForKey:@"payFee"]);
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
                    orderModel.orderItems = orderItemsMutableArray;
                }
                
                if (_orderState == 0) {
                    [_allOrdersArray addObject:orderModel];
                } else if (_orderState == 1) {
                    [_waitingForPaymentArray addObject:orderModel];
                } else if (_orderState == 2) {
                    [_waitingForShippingArray addObject:orderModel];
                }

            }
            
            NSInteger totalPages = [[responseObject objectForKey:@"totalPages"] integerValue];
            NSInteger page = [[responseObject objectForKey:@"page"] integerValue];
            NSInteger tmpPage;
            if (page <= totalPages) {
                tmpPage = page;
            } else {
                tmpPage = totalPages;
                if (totalPages != 0) {
                    [self.view makeCustomToast:@"没有更多信息"];
                }
            }
            
            if (_orderState == 0) {
                _allOrdersPage = tmpPage;
                if (_allOrdersArray.count == 0) {
                    
                    [_tableViewScrollView addSubview:[self blankPageView]];
                    [_blankPageView resetImage:[UIImage imageNamed:@"no_order.png"]];
                    
                } else {
                    
                    UITableView *tableView = [_tableViewScrollView.subviews objectAtIndex:0];
                    [tableView reloadData];
                }
            } else if (_orderState == 1) {
                _waitingForPaymentPage = tmpPage;
                if (_waitingForPaymentArray.count == 0) {
                    
                    [_tableViewScrollView addSubview:[self blankPageView]];
                    [_blankPageView resetImage:[UIImage imageNamed:@"no_order.png"]];
                    
                } else {
                    
                    UITableView *tableView = [_tableViewScrollView.subviews objectAtIndex:1];
                    [tableView reloadData];
                }
            } else if (_orderState == 2) {
                _waitingForShippingPage = tmpPage;
                if (_waitingForShippingArray.count == 0) {
                    [_tableViewScrollView addSubview:[self blankPageView]];
                    [_blankPageView resetImage:[UIImage imageNamed:@"no_order.png"]];
                } else {
                    UITableView *tableView = [_tableViewScrollView.subviews objectAtIndex:2];
                    [tableView reloadData];
                }
            }
            
            if (_blankPageView.superview) {
                [_blankPageView resetTitle:MALL_NO_ORDER_ALL andDescribe:MALL_NO_ORDER_ALL_DESCRIBE];
                [_blankPageView setFrame:CGRectMake(SCREEN_WIDTH*_orderState, 0, SCREEN_WIDTH, MainHeight-_segmentedScorllView.frame.size.height)];
            }
            for (int i = 0; i < viewCount; i++) {
                UITableView *tableView = [_tableViewScrollView.subviews objectAtIndex:i];
                [tableView reloadData];
            }
        } else {
            if (_orderState == 0 && _allOrdersPage < 2) {
                [_allOrdersArray removeAllObjects];
            } else if (_orderState == 1 && _waitingForPaymentPage < 2) {
                [_waitingForPaymentArray removeAllObjects];
            } else if (_orderState == 2 && _waitingForShippingPage < 2) {
                [_waitingForShippingArray removeAllObjects];
            }
            [tableView reloadData];
            [_tableViewScrollView addSubview:[self blankPageView]];
            [_blankPageView resetImage:[UIImage imageNamed:@"server_error.png"]];
            [_blankPageView resetTitle:SERVER_ERROR andDescribe:SERVER_ERROR_DESCRIBE];
            [_blankPageView setFrame:CGRectMake(SCREEN_WIDTH*_orderState, 0, SCREEN_WIDTH, MainHeight-_segmentedScorllView.frame.size.height)];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [XQBLoadingView hideLoadingForView:self.view];
        if (_orderState == 0 && _allOrdersPage < 2) {
            [_allOrdersArray removeAllObjects];
        } else if (_orderState == 1 && _waitingForPaymentPage < 2) {
            [_waitingForPaymentArray removeAllObjects];
        } else if (_orderState == 2 && _waitingForShippingPage < 2) {
            [_waitingForShippingArray removeAllObjects];
        }
        [tableView reloadData];
        [_tableViewScrollView addSubview:[self blankPageView]];
        [_blankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
        [_blankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
        [_blankPageView setFrame:CGRectMake(SCREEN_WIDTH*_orderState, 0, SCREEN_WIDTH, MainHeight-_segmentedScorllView.frame.size.height)];
        
    }];
    
}

- (void)requestOrderCancel:(NSString *)orderId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:orderId forKey:@"orderId"];
    [parameters addSignatureKey];
    
    [manager GET:EC_ORDERS_CANCEL_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self.view.window makeCustomToast:@"订单已成功取消"];
            [self refreshOrder];
        }else{
            [self.view.window makeCustomToast:@"服务器出错了"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XQBLog(@"网络异常");
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
    
}

- (void)requestOrderDelete:(NSString *)orderId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:orderId forKey:@"orderId"];
    [parameters addSignatureKey];
    
    [manager GET:EC_ORDERS_DELETE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self.view.window makeCustomToast:@"订单已成功删除"];
            [self refreshOrder];
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
        [self refreshOrder];
    }else{
        MsgBox(msg);
    }
}

#pragma mark --- UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        ECOrderDetailModel *orderModel;
        if (_orderState == 0) {
            orderModel = [_allOrdersArray objectAtIndex:alertView.tag];
        } else if (_orderState == 1) {
            orderModel = [_waitingForPaymentArray objectAtIndex:alertView.tag];
        } else if (_orderState == 2) {
            orderModel = [_waitingForShippingArray objectAtIndex:alertView.tag];
        } else {
            orderModel = nil;
        }
        
        if ([orderModel.orderStatus isEqualToString:@"待付款"]) {
            [self requestOrderCancel:orderModel.orderId];
        } else if ([orderModel.orderStatus isEqualToString:@"交易完成"] || [orderModel.orderStatus isEqualToString:@"交易关闭"] || [orderModel.orderStatus isEqualToString:@"已过期"]) {
            [self requestOrderDelete:orderModel.orderId];
        }
    }
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!scrollView.tag) {
        int index = 0;
        if (scrollView.contentOffset.x != 0)
        {
            index = scrollView.contentOffset.x/scrollView.frame.size.width;
        }
        
        for (int i = 0 ; i < viewCount; i++) {
            UIButton *button = [_segmentedScorllView.subviews objectAtIndex:i];
            if (i == index) {
                button.selected = YES;
            } else {
                button.selected = NO;
            }
        }
        
        [_segmentedMarkView setFrame:CGRectMake(scrollView.contentOffset.x*(MOVCSegmentedItemWidth/scrollView.frame.size.width), _segmentedMarkView.frame.origin.y, _segmentedMarkView.frame.size.width, _segmentedMarkView.frame.size.height)];
    } else {
        //去掉UItableview的section的headerview黏性
        CGFloat sectionHeaderViewHeight = MOVCItemHeight+10;
        CGFloat sectionFooterViewoffset = 0;
        if (scrollView.tag == 1) {
            for (int i=0; i<_allOrdersArray.count; i++) {
                ECOrderDetailModel *orderModel = [_allOrdersArray objectAtIndex:i];
                sectionFooterViewoffset = sectionFooterViewoffset+(sectionHeaderViewHeight+MOVCItemHeight*2+103*orderModel.orderItems.count);
            }
            sectionFooterViewoffset = sectionFooterViewoffset - MOVCItemHeight*2-MainHeight+MOVCItemHeight;
        } else if (scrollView.tag == 2) {
            for (int i=0; i<_waitingForPaymentArray.count; i++) {
                ECOrderDetailModel *orderModel = [_waitingForPaymentArray objectAtIndex:i];
                sectionFooterViewoffset = sectionFooterViewoffset+(sectionHeaderViewHeight+MOVCItemHeight*2+103*orderModel.orderItems.count);
            }
            sectionFooterViewoffset = sectionFooterViewoffset - MOVCItemHeight*2-MainHeight+MOVCItemHeight;
        } else if (scrollView.tag == 3) {
            for (int i=0; i<_waitingForShippingArray.count; i++) {
                ECOrderDetailModel *orderModel = [_waitingForShippingArray objectAtIndex:i];
                sectionFooterViewoffset = sectionFooterViewoffset+(sectionHeaderViewHeight+MOVCItemHeight*2+103*orderModel.orderItems.count);
            }
            sectionFooterViewoffset = sectionFooterViewoffset - MOVCItemHeight*2-MainHeight+MOVCItemHeight;
        }
        
        
        if ( 0 <= scrollView.contentOffset.y && scrollView.contentOffset.y<=sectionHeaderViewHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (sectionHeaderViewHeight <= scrollView.contentOffset.y && scrollView.contentOffset.y<=sectionFooterViewoffset) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderViewHeight, 0, 0, 0);
            scrollView.frame = CGRectMake((scrollView.tag-1)*_tableViewScrollView.frame.size.width, 0, _tableViewScrollView.frame.size.width, MainHeight-_segmentedScorllView.frame.size.height+MOVCItemHeight*2);
        } else if (sectionFooterViewoffset+MOVCItemHeight*2 > scrollView.contentOffset.y && scrollView.contentOffset.y>sectionFooterViewoffset && scrollView.contentOffset.y > 0){
            scrollView.frame = CGRectMake((scrollView.tag-1)*_tableViewScrollView.frame.size.width, 0, _tableViewScrollView.frame.size.width, MainHeight-_segmentedScorllView.frame.size.height+MOVCItemHeight*2-scrollView.contentOffset.y+sectionFooterViewoffset);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!scrollView.tag) {
        int index = 0;
        if (scrollView.contentOffset.x != 0)
        {
            index = scrollView.contentOffset.x/scrollView.frame.size.width;
        }
        _orderState = index;
        [self refreshOrder];
    }
}

#pragma mark ---WEPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
    //Safe to release the popover here
    self.mallPopoverController.delegate = nil;
    self.mallPopoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
    //The popover is automatically dismissed if you click outside it, unless you return NO here
    return YES;
}

#pragma mark --- tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return _allOrdersArray.count;
    } else if (tableView.tag == 2) {
        return _waitingForPaymentArray.count;
    } else if (tableView.tag == 3) {
        return _waitingForShippingArray.count;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        for (int i = 0; i<_allOrdersArray.count; i++) {
            ECOrderDetailModel *orderModel = [_allOrdersArray objectAtIndex:i];
            if (section == i) {
                return orderModel.orderItems.count;
            }
        }
    } else if (tableView.tag == 2) {
        for (int i=0; i<_waitingForPaymentArray.count; i++) {
            ECOrderDetailModel *orderModel = [_waitingForPaymentArray objectAtIndex:i];
            if (section == i) {
                return orderModel.orderItems.count;
            }
        }
    } else if (tableView.tag == 3) {
        for (int i=0; i<_waitingForShippingArray.count; i++) {
            ECOrderDetailModel *orderModel = [_waitingForShippingArray objectAtIndex:i];
            if (section == i) {
                return orderModel.orderItems.count;
            }
        }
    } else {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECOrderDetailModel *orderModel;
    if (tableView.tag == 1) {
        orderModel = [_allOrdersArray objectAtIndex:indexPath.section];
    } else if (tableView.tag == 2) {
        orderModel = [_waitingForPaymentArray objectAtIndex:indexPath.section];
    } else if (tableView.tag == 3) {
        orderModel = [_waitingForShippingArray objectAtIndex:indexPath.section];
    } else {
        orderModel = nil;
    }
    ECOrderItemModel *orderItemModel = [orderModel.orderItems objectAtIndex:indexPath.row];
    
    
    static NSString *identifier = @"Cell";
    ECOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ECOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.shoppingIconView sd_setImageWithURL:[NSURL URLWithString:orderItemModel.cover] placeholderImage:[UIImage imageNamed:@"default_rect_placeholder_image.png"]];
    cell.shoppingNameLabel.text = orderItemModel.productName;
    cell.shoppingTypeLabel.text = [NSString stringWithFormat:@"容量分类：%@%@", orderItemModel.measure, orderItemModel.unit];
    if ([orderModel.orderStatus isEqualToString:@"待付款"]) {
        cell.shoppingNameLabel.frame = CGRectMake(cell.shoppingIconView.frame.size.width+cell.shoppingIconView.frame.origin.x+14, cell.shoppingIconView.frame.origin.y+14, 160, 30);
        cell.shoppingTypeLabel.frame = CGRectMake(cell.shoppingNameLabel.frame.origin.x, cell.shoppingNameLabel.frame.origin.y+cell.shoppingNameLabel.frame.size.height, 160, 17);
        cell.afterSalesButton.hidden = YES;
    } else if ([orderModel.orderStatus isEqualToString:@"已付款待发货"]) {
        cell.shoppingNameLabel.frame = CGRectMake(cell.shoppingIconView.frame.size.width+cell.shoppingIconView.frame.origin.x+14, cell.shoppingIconView.frame.origin.y+5.5, 160, 30);
        cell.shoppingTypeLabel.frame = CGRectMake(cell.shoppingNameLabel.frame.origin.x, cell.shoppingNameLabel.frame.origin.y+cell.shoppingNameLabel.frame.size.height, 160, 17);
        cell.afterSalesButton.frame = CGRectMake(cell.shoppingTypeLabel.frame.origin.x, cell.shoppingTypeLabel.frame.origin.y+cell.shoppingTypeLabel.frame.size.height, 50, 17);
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
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MOVCItemHeight+10)];
    backgroundView.backgroundColor = XQBColorBackground;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 0.5)];
    lineView1.backgroundColor = XQBColorInternalSeparationLine;
    [backgroundView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10-0.5, MainWidth, 0.5)];
    lineView2.backgroundColor = XQBColorInternalSeparationLine;
    [backgroundView addSubview:lineView2];

    
    UIView *heardItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainWidth, MOVCItemHeight)];
    heardItemView.backgroundColor = [UIColor whiteColor];
    
    ECOrderDetailModel *orderModel;
    if (tableView.tag == 1) {
        orderModel = [_allOrdersArray objectAtIndex:section];
    } else if (tableView.tag == 2) {
        orderModel = [_waitingForPaymentArray objectAtIndex:section];
    } else if (tableView.tag == 3) {
        orderModel = [_waitingForShippingArray objectAtIndex:section];
    } else {
        orderModel = nil;
    }
    
    UIButton *orderNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGSize size = [[NSString stringWithFormat:@"    %@", orderModel.orderSn] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, MOVCItemHeight) lineBreakMode:NSLineBreakByWordWrapping];
    
    orderNameButton.frame = CGRectMake(MOVCHorizontalMargin, 0, size.width+16+MOVCHorizontalMargin+14, MOVCItemHeight);
    [orderNameButton setImage:[UIImage imageNamed:@"mall_store.png"] forState:UIControlStateNormal];
    [orderNameButton setTitle:[NSString stringWithFormat:@"    %@", orderModel.orderSn] forState:UIControlStateNormal];
    [orderNameButton setTitleColor:XQBColorExplain forState:UIControlStateNormal];
    [orderNameButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [orderNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [orderNameButton setTag:section];
    [orderNameButton addTarget:self action:@selector(orderNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [heardItemView addSubview:orderNameButton];
    
    UIImageView *arrowIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_icon.png"]];
    arrowIconView.frame = CGRectMake(size.width+16+MOVCHorizontalMargin, 15, 14, 14);
    [orderNameButton addSubview:arrowIconView];
    
    UILabel *transactionStatuslabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth-MOVCHorizontalMargin-70, 0, 70, MOVCItemHeight)];
    transactionStatuslabel.text = orderModel.orderStatus;
    transactionStatuslabel.textColor = XQBColorGreen;
    transactionStatuslabel.font = [UIFont systemFontOfSize:10];
    transactionStatuslabel.textAlignment = UIControlContentHorizontalAlignmentRight;
    [heardItemView addSubview:transactionStatuslabel];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(MOVCHorizontalMargin, MOVCItemHeight-0.5, MainWidth-MOVCHorizontalMargin, 0.5)];
    lineView3.backgroundColor = XQBColorInternalSeparationLine;
    [heardItemView addSubview:lineView3];
    
    [backgroundView addSubview:heardItemView];
    
    return backgroundView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MOVCItemHeight*2)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    ECOrderDetailModel *orderModel;
    if (tableView.tag == 1) {
        orderModel = [_allOrdersArray objectAtIndex:section];
    } else if (tableView.tag == 2) {
        orderModel = [_waitingForPaymentArray objectAtIndex:section];
    } else if (tableView.tag == 3) {
        orderModel = [_waitingForShippingArray objectAtIndex:section];
    } else {
        orderModel = nil;
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, MainHeight-10, 0.5)];
    lineView1.backgroundColor = XQBColorInternalSeparationLine;
    [footerView addSubview:lineView1];
    
    UILabel *goodsNumCountLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainWidth-60)/2, 0, 60, MOVCItemHeight)];
    goodsNumCountLabel.text = [NSString stringWithFormat:@"共%lu件商品", (unsigned long)orderModel.orderItems.count];
    goodsNumCountLabel.textColor = XQBColorExplain;
    goodsNumCountLabel.font = [UIFont systemFontOfSize:9];
    goodsNumCountLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    [footerView addSubview:goodsNumCountLabel];
    
    CGSize size = [[PricesShown priceOfShorthand:[orderModel.payFee doubleValue]] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, MOVCItemHeight) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *priceHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth-size.width-30-MOVCHorizontalMargin, 0, 30, MOVCItemHeight)];
    priceHintLabel.text = @"实付:";
    priceHintLabel.textColor = XQBColorExplain;
    priceHintLabel.font = [UIFont systemFontOfSize:9];
    priceHintLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
    [footerView addSubview:priceHintLabel];
    
    UILabel *footerPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth-size.width-MOVCHorizontalMargin, 0, size.width, MOVCItemHeight)];
    footerPriceLabel.text = [PricesShown priceOfShorthand:[orderModel.payFee doubleValue]];
    footerPriceLabel.textColor = [UIColor orangeColor];
    footerPriceLabel.font = [UIFont systemFontOfSize:15];
    footerPriceLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
    [footerView addSubview:footerPriceLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, MOVCItemHeight-0.5, MainHeight-10, 0.5)];
    lineView.backgroundColor = XQBColorInternalSeparationLine;
    [footerView addSubview:lineView];
    
    UIButton *deleteOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteOrderButton setFrame:CGRectMake(MainWidth-60-MOVCHorizontalMargin, 10+MOVCItemHeight, 60, 24)];
    [deleteOrderButton setTitle:@"删除订单" forState:UIControlStateNormal];
    [deleteOrderButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
    [deleteOrderButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [deleteOrderButton setTag:section];
    [deleteOrderButton.layer setMasksToBounds:YES];
    [deleteOrderButton.layer setBorderColor:[XQBColorContent CGColor]];
    [deleteOrderButton.layer setCornerRadius:3];
    [deleteOrderButton.layer setBorderWidth:0.5];
    [footerView addSubview:deleteOrderButton];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [payButton setFrame:CGRectMake(MainWidth-60-MOVCHorizontalMargin, 10+MOVCItemHeight, 60, 24)];
    [payButton setTitle:@"付款" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setBackgroundImage:[UIImage imageWithColor:RGB(250, 150, 0) size:payButton.bounds.size] forState:UIControlStateNormal];
    [payButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [payButton setTag:section];
    [payButton addTarget:self action:@selector(payButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [payButton.layer setMasksToBounds:YES];
    [payButton.layer setCornerRadius:3];
    [payButton setHidden:YES];
    [footerView addSubview:payButton];
    
    if ([orderModel.orderStatus isEqualToString:@"待付款"]) {
        [payButton setHidden:NO];
        
        [deleteOrderButton setFrame:CGRectMake(MainWidth-(60+MOVCHorizontalMargin)*2, 10+MOVCItemHeight, 60, 24)];
        [deleteOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [deleteOrderButton removeTarget:self action:@selector(deleteOrderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteOrderButton addTarget:self action:@selector(cancelOrderBUttonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([orderModel.orderStatus isEqualToString:@"交易完成"] || [orderModel.orderStatus isEqualToString:@"交易关闭"] || [orderModel.orderStatus isEqualToString:@"已过期"]) {
        [payButton setHidden:YES];
        
        [deleteOrderButton removeTarget:self action:@selector(cancelOrderBUttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteOrderButton addTarget:self action:@selector(deleteOrderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [payButton setHidden:YES];
        [deleteOrderButton setHidden:YES];
    }
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECOrderDetailModel *orderModel;
    if (tableView.tag == 1) {
        orderModel = [_allOrdersArray objectAtIndex:indexPath.section];
    } else if (tableView.tag == 2) {
        orderModel = [_waitingForPaymentArray objectAtIndex:indexPath.section];
    } else if (tableView.tag == 3) {
        orderModel = [_waitingForShippingArray objectAtIndex:indexPath.section];
    } else {
        orderModel = nil;
    }
    
    ECOrderItemModel *orderItemModel = [orderModel.orderItems objectAtIndex:indexPath.row];
    XQBECProductDetailViewController *viewController = [[XQBECProductDetailViewController alloc] init];
    viewController.productId = orderItemModel.productId;
    viewController.productIamgeUrl = orderItemModel.cover;
    [self.navigationController pushViewController:viewController animated:YES];
    
}


#pragma mark --- RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (direction==RefreshDirectionTop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl finishRefreshingDirection:RefreshDirectionTop];
        });
        [self refreshOrder];
        [XQBLoadingView hideLoadingForView:self.view];
    } else if (direction == RefreshDirectionBottom) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        });
        [self requestMyOrderList:_orderState];
        [XQBLoadingView hideLoadingForView:self.view];
    }
}

@end
