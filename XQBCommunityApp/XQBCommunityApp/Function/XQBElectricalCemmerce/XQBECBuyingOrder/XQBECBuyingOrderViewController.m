//
//  XQBECBuyingOrderViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/17.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBECBuyingOrderViewController.h"
#import "Global.h"
#import "XQBBaseTableView.h"
#import "ShippingAddressModel.h"
#import "ECOrderInfoModel.h"
#import "ECCartShoppingModel.h"
#import "XQBECBuyingOrderCell.h"
#import "PricesShown.h"
#import "XQBECShippingAddressViewController.h"
#import "XQBOrderDetailViewController.h"
#import "XQBECProductDetailViewController.h"

@interface XQBECBuyingOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XQBBaseTableView *tableView;
@property (nonatomic, strong) UIView *tableViewHeaderView;
@property (nonatomic, strong) UIView *tableViewFooterView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *orderConfirmationButton;

//header
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *addShippingButton;

//footer
@property (nonatomic, strong) UILabel *freightLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *priceTextLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;

@property (nonatomic, strong) ECOrderInfoModel *orderInfoModel;

@property (nonatomic, assign) BOOL isExistenceAddress;
@end

@implementation XQBECBuyingOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _orderInfoModel = [[ECOrderInfoModel alloc] init];
        _isExistenceAddress = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestOrdersInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = XQBColorBackground;
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"确认订单"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- ui
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) ) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = XQBColorBackground;
        _tableView.tableHeaderView = self.tableViewHeaderView;
        _tableView.tableFooterView = self.tableViewFooterView;
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
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 22)];
        titleLabel.backgroundColor = XQBColorBackground;
        titleLabel.text = @"    收货地址";
        titleLabel.textColor = XQBColorContent;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [_tableViewHeaderView addSubview:titleLabel];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 22-0.5, MainWidth, 0.5)];
        lineView1.backgroundColor = XQBColorElementSeparationLine;
        [_tableViewHeaderView addSubview:lineView1];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 22+6.5, 200, 17)];
        _nameLabel.textColor = XQBColorContent;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [_tableViewHeaderView addSubview:_nameLabel];
        
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 22+8.5, 60, 17)];
        _phoneLabel.textColor = XQBColorContent;
        _phoneLabel.font = [UIFont systemFontOfSize:9];
        _phoneLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        [_tableViewHeaderView addSubview:_phoneLabel];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 22+6.5+17, 260, 14)];
        _addressLabel.textColor = XQBColorContent;
        _addressLabel.font = [UIFont systemFontOfSize:9];
        [_tableViewHeaderView addSubview:_addressLabel];
        
        _addShippingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addShippingButton setFrame:CGRectMake(14, 22, 270, 44)];
        [_addShippingButton setTitle:@"  新增收货地址" forState:UIControlStateNormal];
        [_addShippingButton setImage:[UIImage imageNamed:@"add_icon.png"] forState:UIControlStateNormal];
        [_addShippingButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
        [_addShippingButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_addShippingButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_addShippingButton setUserInteractionEnabled:NO];
        _addShippingButton.hidden = YES;
        [_tableViewHeaderView addSubview:_addShippingButton];
        
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth-30, 22+15, 8, 14)];
        [accessoryImageView setImage:[UIImage imageNamed:@"right_arrow_gray.png"]];
        [_tableViewHeaderView addSubview:accessoryImageView];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 66-0.5, MainWidth, 0.5)];
        lineView2.backgroundColor = XQBColorElementSeparationLine;
        [_tableViewHeaderView addSubview:lineView2];
        
        UILabel *shopTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, MainWidth, 22)];
        shopTitleLabel.backgroundColor = XQBColorBackground;
        shopTitleLabel.text = @"    商品信息";
        shopTitleLabel.textColor = XQBColorContent;
        shopTitleLabel.font = [UIFont systemFontOfSize:12];
        [_tableViewHeaderView addSubview:shopTitleLabel];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 88-0.5, MainWidth, 0.5)];
        lineView3.backgroundColor = XQBColorElementSeparationLine;
        [_tableViewHeaderView addSubview:lineView3];
        
        UITapGestureRecognizer *heardViewClicked = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(heardViewClickedAction)];
        [_tableViewHeaderView addGestureRecognizer:heardViewClicked];
    }
    return _tableViewHeaderView;
}

- (UIView *)tableViewFooterView
{
    if (!_tableViewFooterView) {
        _tableViewFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 88)];
        _tableViewFooterView.backgroundColor = [UIColor whiteColor];
        
        //分隔线
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(14, 0, MainWidth - 14, 0.5)];
        lineView1.backgroundColor = XQBColorInternalSeparationLine;
        [_tableViewFooterView addSubview:lineView1];
        
        _freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth-80-18, 0, 80, 44)];
        _freightLabel.textColor = XQBColorContent;
        _freightLabel.font = [UIFont systemFontOfSize:9];
        _freightLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
        [_tableViewFooterView addSubview:_freightLabel];
        
        //分隔线
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(14, 44-0.5, MainWidth - 14, 0.5)];
        lineView2.backgroundColor = XQBColorInternalSeparationLine;
        [_tableViewFooterView addSubview:lineView2];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 44, 60, 44)];
        _countLabel.textColor = XQBColorContent;
        _countLabel.font = [UIFont systemFontOfSize:9];
        _countLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        [_tableViewFooterView addSubview:_countLabel];
        
        _priceTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 28, 44)];
        _priceTextLabel.text = @"实付：";
        _priceTextLabel.textColor = XQBColorContent;
        _priceTextLabel.font = [UIFont systemFontOfSize:9];
        [_tableViewFooterView addSubview:_priceTextLabel];
        
        _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth-14-90, 44, 90, 44)];
        _totalPriceLabel.textColor = [UIColor orangeColor];
        _totalPriceLabel.font = [UIFont systemFontOfSize:15.0f];
        _totalPriceLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
        [_tableViewFooterView addSubview:_totalPriceLabel];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, _tableViewFooterView.frame.size.height-0.5, MainWidth, 0.5)];
        lineView3.backgroundColor = XQBColorElementSeparationLine;
        [_tableViewFooterView addSubview:lineView3];
    }
    return _tableViewFooterView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainHeight - 44, MainWidth, 44)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 0.5)];
        lineView1.backgroundColor = XQBColorElementSeparationLine;
        [_bottomView addSubview:lineView1];
        
        self.orderConfirmationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderConfirmationButton addTarget:self action:@selector(orderConfirmationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _orderConfirmationButton.frame = CGRectMake(MainWidth/2-40, 7, 80, 30);
        [_orderConfirmationButton setTitle:@"确认订单" forState:UIControlStateNormal];
        [_orderConfirmationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_orderConfirmationButton setBackgroundImage:[UIImage imageWithColor:RGB(250, 150, 0) size:_orderConfirmationButton.bounds.size] forState:UIControlStateNormal];
        _orderConfirmationButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_orderConfirmationButton.layer setMasksToBounds:YES];
        [_orderConfirmationButton.layer setCornerRadius:3];
        [_bottomView addSubview:_orderConfirmationButton];
        
        UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        agreeButton.frame = CGRectMake(MainWidth-14-80, 27, 80, 10);
        [agreeButton setImage:[UIImage imageNamed:@"user_agreement.png"] forState:UIControlStateNormal];
        [agreeButton setTitle:@"   我已同意产品购买协议" forState:UIControlStateNormal];
        [agreeButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
        [agreeButton setTitleColor:XQBColorExplain forState:UIControlStateSelected];
        [agreeButton.titleLabel setFont:[UIFont systemFontOfSize:6]];
        [_bottomView addSubview:agreeButton];
    }
    
    return _bottomView;
}

#pragma mark --- refresh
- (void)refreshUI
{
    ShippingAddressModel *addressModel = _orderInfoModel.shippingAddress;
    
    if (addressModel.consignee.length == 0 || addressModel.phone.length == 0 || addressModel.address == 0) {
        _nameLabel.hidden = YES;
        _phoneLabel.hidden = YES;
        _addressLabel.hidden = YES;
        _addShippingButton.hidden = NO;
        _isExistenceAddress = NO;
    } else {
        _nameLabel.hidden = NO;
        _phoneLabel.hidden = NO;
        _addressLabel.hidden = NO;
        _addShippingButton.hidden = YES;
        _nameLabel.text = [NSString stringWithFormat:@"%@", addressModel.consignee];
        _phoneLabel.text = [NSString stringWithFormat:@"%@", addressModel.phone];
        _addressLabel.text = [NSString stringWithFormat:@"%@", addressModel.address];
        _isExistenceAddress = YES;
    }
    
    
    _freightLabel.text = [NSString stringWithFormat:@"运费：%@", [PricesShown priceOfShorthand:[_orderInfoModel.shippingFee doubleValue]]];
    _countLabel.text = [NSString stringWithFormat:@"共%ld件商品", _orderInfoModel.productItems.count];
    _totalPriceLabel.text = [PricesShown priceOfShorthand:[_orderInfoModel.payFee doubleValue]];
    CGSize size=[_totalPriceLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, _totalPriceLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_totalPriceLabel.font } context:nil].size;
    
    [_totalPriceLabel setFrame:CGRectMake(MainWidth-size.width-14, 44, size.width, 44)];
    [_priceTextLabel setFrame:CGRectMake(MainWidth-28-size.width-14, 44, 28, 44)];
    
    [_tableView reloadData];
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)orderConfirmationButtonAction:(UIButton *)sender
{
    if (!_isExistenceAddress) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请添加收获地址" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        return;
    }
    
    if (sender.enabled == YES) {
        sender.enabled = NO;
        [self requestCommitOrders];
    }
}

- (void)heardViewClickedAction
{
    XQBECShippingAddressViewController *addressAddVC = [[XQBECShippingAddressViewController alloc] init];
    [self.navigationController pushViewController:addressAddVC animated:YES];
}

#pragma mark --- AFNetwork
- (void)requestOrdersInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSString *urlString;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    if (_entance == EntanceFromProductDetail) {
        urlString = EC_ORDERS_CHECKNOW_URL;
        [parameters setObject:_productItemID forKey:@"productItemId"];
        [parameters setObject:_itemNumber forKey:@"itemNumber"];
    } else if (_entance == EntanceFromCart) {
        urlString = EC_ORDER_NEW_CONFIRMATION_URL;
        NSString *productItemIds;
        for (int i=0; i<_productItemIDsArray.count; i++) {
            if (productItemIds.length == 0) {
                productItemIds = [NSString stringWithFormat:@"%@", [_productItemIDsArray objectAtIndex:i]];
            } else {
                productItemIds = [NSString stringWithFormat:@"%@;%@", productItemIds, [_productItemIDsArray objectAtIndex:i]];
            }
        }
        [parameters setObject:productItemIds forKey:@"productItemIds"];
    }
    
    [parameters addSignatureKey];
    
    __weak typeof(self) weakSelf = self;
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            weakSelf.orderInfoModel.shippingFee = DealWithJSONValue([responseObject objectForKey:ECOIShippingFee]);
            weakSelf.orderInfoModel.payFee      = DealWithJSONValue([responseObject objectForKey:ECOIPayFee]);
            
            ShippingAddressModel *shippingModel = [[ShippingAddressModel alloc] init];
            
            shippingModel.shippingAddressId   = [[[responseObject objectForKey:ECOIShippingAddress] objectForKey:SAShippingAddressId] stringValue];
            shippingModel.consignee           = DealWithJSONValue([[responseObject objectForKey:ECOIShippingAddress] objectForKey:SAConsignee]);
            shippingModel.address             = DealWithJSONValue([[responseObject objectForKey:ECOIShippingAddress] objectForKey:SAAddress]);
            shippingModel.phone               = DealWithJSONValue([[responseObject objectForKey:ECOIShippingAddress] objectForKey:SAPhone]);
            
            weakSelf.orderInfoModel.shippingAddress = shippingModel;
            
            NSArray *productsArray = [responseObject objectForKey:ECOIProductItems];
            NSMutableArray *productItemsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *productDic in productsArray) {
                ECCartShoppingModel *shoppingModel = [[ECCartShoppingModel alloc] init];
                
                shoppingModel.productId     = [[productDic objectForKey:ECCSProductId] stringValue];
                shoppingModel.productItemId = [[productDic objectForKey:ECCSProductItemId] stringValue];
                shoppingModel.productName   = DealWithJSONValue([productDic objectForKey:ECCSProductName]);
                shoppingModel.cover         = DealWithJSONValue([productDic objectForKey:ECCSCover]);
                shoppingModel.measure       = DealWithJSONValue([productDic objectForKey:ECCSMeasure]);
                shoppingModel.unit          = DealWithJSONValue([productDic objectForKey:ECCSUnit]);
                shoppingModel.itemNumber    = [[productDic objectForKey:ECCSItemNumber] stringValue];
                shoppingModel.price         = [[productDic objectForKey:ECCSPrice] stringValue];
                shoppingModel.oldPrice      = [[productDic objectForKey:ECCSOldPrice] stringValue];
                shoppingModel.stockCount    = [[productDic objectForKey:ECCSStockCount] stringValue];
                shoppingModel.favorNumber   = [[productDic objectForKey:ECCSFavorNumber] stringValue];
                
                [productItemsArray addObject:shoppingModel];
            }
            
            weakSelf.orderInfoModel.productItems = productItemsArray;
            
            [self refreshUI];
        } else {
            //加载服务器异常界面
            [self.view.window makeCustomToast:[responseObject objectForKey:NETWORK_RETURN_ERROR_MSG]];
            [self refreshUI];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
        [self refreshUI];
    }];
}

- (void)requestCommitOrders
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:_orderInfoModel.shippingAddress.shippingAddressId forKey:@"shippingAddressId"];
    
    if (_entance == EntanceFromProductDetail) {
        [parameters setObject:@"checknow" forKey:@"postOrderFrom"];
        [parameters setObject:_productItemID forKey:@"productItemIds"];
        [parameters setObject:_itemNumber forKey:@"itemNumber"];
    } else if (_entance == EntanceFromCart) {
        [parameters setObject:@"carts" forKey:@"postOrderFrom"];
        NSString *productItemIds;
        for (int i=0; i<_productItemIDsArray.count; i++) {
            if (productItemIds.length == 0) {
                productItemIds = [NSString stringWithFormat:@"%@", [_productItemIDsArray objectAtIndex:i]];
            } else {
                productItemIds = [NSString stringWithFormat:@"%@;%@", productItemIds, [_productItemIDsArray objectAtIndex:i]];
            }
        }
        [parameters setObject:productItemIds forKey:@"productItemIds"];
    }
    
    [parameters addSignatureKey];
    
    [manager POST:EC_ORDERS_NEW_ADD_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            XQBOrderDetailViewController *detailVC = [[XQBOrderDetailViewController alloc] init];
            detailVC.orderId = [[responseObject objectForKey:@"orderId"] stringValue];
            [self.navigationController pushViewController:detailVC animated:YES];
        } else {
            //加载服务器异常界面
            [self.view.window makeCustomToast:[responseObject objectForKey:NETWORK_RETURN_ERROR_MSG]];
            _orderConfirmationButton.enabled = YES;
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
        _orderConfirmationButton.enabled = YES;
    }];
}

#pragma mark --- alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        XQBECShippingAddressViewController *addressAddVC = [[XQBECShippingAddressViewController alloc] init];
        [self.navigationController pushViewController:addressAddVC animated:YES];
    }else{
        NSLog(@"取消发布");
    }
}

#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderInfoModel.productItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"shoppingCartCell";
    XQBECBuyingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[XQBECBuyingOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ECCartShoppingModel *model = ([_orderInfoModel.productItems count]>indexPath.row)?[self.orderInfoModel.productItems objectAtIndex:indexPath.row]:nil;
    
    [cell.shoppingIconView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:cell.shoppingIconView.frame.size]];
    cell.shoppingNameLabel.text  = model.productName;
    cell.shoppingPriceLabel.text = [PricesShown priceOfShorthand:[model.price doubleValue]];
    cell.shoppingTypeLabel.text  = model.measure;
    cell.shoppingCountLabel.text = [NSString stringWithFormat:@"%@%@", model.itemNumber , model.unit];
    
    return cell;
}

#pragma mark --- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     ECCartShoppingModel *model = ([_orderInfoModel.productItems count]>indexPath.row)?[self.orderInfoModel.productItems objectAtIndex:indexPath.row]:nil;
    
    XQBECProductDetailViewController *productDetailVC = [[XQBECProductDetailViewController alloc] init];
    productDetailVC.productId = model.productId;
    productDetailVC.productIamgeUrl = model.cover;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

@end
