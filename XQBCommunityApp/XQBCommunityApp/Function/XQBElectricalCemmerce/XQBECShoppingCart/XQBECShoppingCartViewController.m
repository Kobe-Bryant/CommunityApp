//
//  XQBECShoppingCartViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/16.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBECShoppingCartViewController.h"
#import "Global.h"
#import "XQBBaseTableView.h"
#import "ECShoppingCartCell.h"
#import "ECCartShoppingModel.h"
#import "PricesShown.h"
#import "XQBECBuyingOrderViewController.h"
#import "XQBECProductDetailViewController.h"
#import "BlankPageView.h"

static const CGFloat kbottomViewHeight = 44.0f;

@interface XQBECShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XQBBaseTableView *tableView;

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *selectAllButton;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UIButton *buyNowButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) BlankPageView *blankPageView;


@property (nonatomic, strong) NSMutableArray *cartShoppingsArray;

@property (nonatomic, strong) NSMutableArray *isSelectedArray;      //每一个cell是否被选中0表示没选中，1表示选中【以后改成枚举值】
@property (nonatomic, strong) NSMutableArray *isChangedArray;       //每一个cell是否有改变
@property (nonatomic, strong) NSMutableArray *deleteCellArray;      //那些cell被删除了

@end

@implementation XQBECShoppingCartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cartShoppingsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _isSelectedArray = [[NSMutableArray alloc] initWithCapacity:0];
        _isChangedArray = [[NSMutableArray alloc] initWithCapacity:0];
        _deleteCellArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initBottomViewInfo];
    [self requestECCarts];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = XQBColorBackground;
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"购物车"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //    右边按钮
    [self setRightBarButtonItem:self.rightBtn];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- ui
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(280,0,70,44);
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:XQBColorGreen forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), MainHeight - kbottomViewHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = XQBColorBackground;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
        _tableView.separatorColor = XQBColorInternalSeparationLine;
    }
    return _tableView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainHeight - kbottomViewHeight, WIDTH(self.view), kbottomViewHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 0.5)];
        lineView1.backgroundColor = XQBColorElementSeparationLine;
        [_bottomView addSubview:lineView1];
        
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllButton.frame = CGRectMake(14, 0, 75, kbottomViewHeight);
        [_selectAllButton setTitle:@" 全选" forState:UIControlStateNormal];
        [_selectAllButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
        _selectAllButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_selectAllButton setImage:[UIImage imageNamed:@"no_choosed_button.png"] forState:UIControlStateNormal];
        [_selectAllButton setImage:[UIImage imageNamed:@"choosed_button.png"] forState:UIControlStateSelected];
        [_selectAllButton addTarget:self action:@selector(selectAllButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _selectAllButton.selected = NO;
        [_bottomView addSubview:_selectAllButton];
        
        _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_selectAllButton.frame.origin.x+_selectAllButton.frame.size.width, 7, MainWidth-_selectAllButton.frame.origin.x-_selectAllButton.frame.size.width-14-75-5, 12)];
        _totalPriceLabel.text = @"合计：￥0.00";
        _totalPriceLabel.textColor = XQBColorGreen;
        _totalPriceLabel.font = [UIFont systemFontOfSize:12.0f];
        _totalPriceLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
        [_bottomView addSubview:_totalPriceLabel];
        
        UILabel *shippingLabel = [[UILabel alloc] initWithFrame:CGRectMake(_selectAllButton.frame.origin.x+_selectAllButton.frame.size.width, _totalPriceLabel.frame.origin.y+_totalPriceLabel.frame.size.height+6, MainWidth-_selectAllButton.frame.origin.x-_selectAllButton.frame.size.width-14-75-5, 12)];
        shippingLabel.text = @"不含运费";
        shippingLabel.textColor = XQBColorContent;
        shippingLabel.font = [UIFont systemFontOfSize:12.0f];
        shippingLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
        [_bottomView addSubview:shippingLabel];
        
        _buyNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyNowButton addTarget:self action:@selector(buyNowButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _buyNowButton.frame = CGRectMake( MainWidth-75-14, 7, 75, 30);
        _buyNowButton.backgroundColor = XQBColorGreen;
        [_buyNowButton setTitle:@"结算(0)" forState:UIControlStateNormal];
        [_buyNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyNowButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buyNowButton.layer setMasksToBounds:YES];
        [_buyNowButton.layer setBorderColor:[XQBColorGreen CGColor]];
        [_buyNowButton.layer setCornerRadius:3];
        [_buyNowButton.layer setBorderWidth:0.5];
        [_bottomView addSubview:_buyNowButton];
        
        [self.view addSubview:_bottomView];
    }

    return _bottomView;
}

//空白界面
- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        _blankPageView.blankPageDidClickedBlock = ^(){
        };
    }
    return _blankPageView;
}


- (void)initBottomViewInfo
{
    _totalPriceLabel.text = @"合计：￥0.00";
    _selectAllButton.selected = NO;
    [_buyNowButton setTitle:@"结算(0)" forState:UIControlStateNormal];
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction
{
    if (!_rightBtn.selected) {
        _rightBtn.selected = YES;
        _bottomView.hidden = YES;
        _tableView.frame = CGRectMake(0, 0, MainWidth, MainHeight);
        [_tableView reloadData];
    } else {
        NSString *productItems;
        NSInteger arrayCount = _cartShoppingsArray.count;
        for (int i=0; i<arrayCount; i++) {
            ECCartShoppingModel *model = [_cartShoppingsArray objectAtIndex:i];
            if ([[_isChangedArray objectAtIndex:i] isEqualToString:@"1"]) {
                if (productItems.length == 0) {
                    productItems = [NSString stringWithFormat:@"%@:%@", model.productItemId, model.itemNumber];
                } else {
                    productItems = [NSString stringWithFormat:@"%@;%@:%@", productItems, model.productItemId, model.itemNumber];
                }
                
                if ([model.itemNumber integerValue] == 0) {
                    [_deleteCellArray addObject:[NSString stringWithFormat:@"%d", i]];
                }
                [_isChangedArray setObject:@"0" atIndexedSubscript:i];
            }
        }
        
        if (productItems.length > 0) {
            [self requestCartUpdate:productItems];
        } else {
            [_tableView reloadData];
        }
        _rightBtn.selected = NO;
        _bottomView.hidden = NO;
        _tableView.frame = CGRectMake(0, 0, MainWidth, MainHeight-44);
    }
}

- (void)selectButtonAction:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected = NO;
        [_isSelectedArray setObject:@"0" atIndexedSubscript:sender.tag];
        _selectAllButton.selected = NO;
        
        NSString *string =[_totalPriceLabel.text substringFromIndex:4];
        ECCartShoppingModel *model = [_cartShoppingsArray objectAtIndex:sender.tag];
        _totalPriceLabel.text = [NSString stringWithFormat:@"合计：%@" , [PricesShown priceOfShorthand:[string doubleValue] - [model.price doubleValue]*[model.itemNumber integerValue]]];
        
        NSString *string2 = [_buyNowButton.titleLabel.text substringFromIndex:3];
        [_buyNowButton setTitle:[NSString stringWithFormat:@"结算(%ld)", [string2 integerValue]-1] forState:UIControlStateNormal];
    } else {
        sender.selected = YES;
        [_isSelectedArray setObject:@"1" atIndexedSubscript:sender.tag];
        if (![_isSelectedArray containsObject:@"0"]) {
            _selectAllButton.selected = YES;
        }
        
        NSString *string =[_totalPriceLabel.text substringFromIndex:4];
        ECCartShoppingModel *model = [_cartShoppingsArray objectAtIndex:sender.tag];
        _totalPriceLabel.text = [NSString stringWithFormat:@"合计：%@" , [PricesShown priceOfShorthand:[string doubleValue] + [model.price doubleValue]*[model.itemNumber integerValue]]];
        
        NSString *string2 = [_buyNowButton.titleLabel.text substringFromIndex:3];
        [_buyNowButton setTitle:[NSString stringWithFormat:@"结算(%ld)", [string2 integerValue]+1] forState:UIControlStateNormal];
    }
}

- (void)selectAllButtonAction
{
    if (_selectAllButton.selected) {
        _selectAllButton.selected = NO;
        
        [_buyNowButton setTitle:[NSString stringWithFormat:@"结算(0)"] forState:UIControlStateNormal];
        
        for (int i=0; i<_cartShoppingsArray.count; i++) {
            NSString *string =[_totalPriceLabel.text substringFromIndex:4];
            ECCartShoppingModel *model = [_cartShoppingsArray objectAtIndex:i];
            _totalPriceLabel.text = [NSString stringWithFormat:@"合计：%@" , [PricesShown priceOfShorthand:[string doubleValue] - [model.price doubleValue]*[model.itemNumber integerValue]]];
            
            [_isSelectedArray setObject:@"0" atIndexedSubscript:i];
        }
    } else {
        _selectAllButton.selected = YES;
        [_buyNowButton setTitle:[NSString stringWithFormat:@"结算(%ld)", _cartShoppingsArray.count] forState:UIControlStateNormal];
        for (int i=0; i<_cartShoppingsArray.count; i++) {
            NSString *string =[_totalPriceLabel.text substringFromIndex:4];
            ECCartShoppingModel *model = [_cartShoppingsArray objectAtIndex:i];
            if ([[_isSelectedArray objectAtIndex:i] isEqualToString:@"0"]) {
                _totalPriceLabel.text = [NSString stringWithFormat:@"合计：%@" ,[PricesShown priceOfShorthand:[string doubleValue] + [model.price doubleValue]*[model.itemNumber integerValue]]];
            }
            
            [_isSelectedArray setObject:@"1" atIndexedSubscript:i];
        }
    }
    [_tableView reloadData];
}

- (void)buyNowButtonAction
{
    if (![_isSelectedArray containsObject:@"1"]) {
        [self.view.window makeCustomToast:@"您还未选中任何商品！"];
    } else {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<_cartShoppingsArray.count; i++) {
            ECCartShoppingModel *model = [_cartShoppingsArray objectAtIndex:i];
            if ([[_isSelectedArray objectAtIndex:i] isEqualToString:@"1"]) {
                [array addObject:model.productItemId];
            }
        }

        XQBECBuyingOrderViewController *buyingOrderVC = [[XQBECBuyingOrderViewController alloc] init];
        buyingOrderVC.productItemIDsArray = array;
        buyingOrderVC.entance = EntanceFromCart;
        [self.navigationController pushViewController:buyingOrderVC animated:YES];
    }
}

- (void)goShoppingButtonAction:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark --- AFNetwork
- (void)requestECCarts
{
    [_blankPageView removeFromSuperview];
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+30)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    __weak typeof(self) weakSelf = self;
    [manager GET:EC_CART_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        [XQBLoadingView hideLoadingForView:self.view];
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [weakSelf.cartShoppingsArray removeAllObjects];
            [weakSelf.isSelectedArray removeAllObjects];
            [weakSelf.isChangedArray removeAllObjects];

            NSArray *cartShoppingSArray = [responseObject objectForKey:@"carts"];
            
            for (NSDictionary *cartShoppingDic in cartShoppingSArray) {
                ECCartShoppingModel *cartShoppingModel = [[ECCartShoppingModel alloc] init];
                
                cartShoppingModel.productId     = [[cartShoppingDic objectForKey:ECCSProductId] stringValue];
                cartShoppingModel.productItemId = [[cartShoppingDic objectForKey:ECCSProductItemId] stringValue];
                cartShoppingModel.productName   = DealWithJSONValue([cartShoppingDic objectForKey:ECCSProductName]);
                cartShoppingModel.cover         = DealWithJSONValue([cartShoppingDic objectForKey:ECCSCover]);
                cartShoppingModel.measure       = DealWithJSONValue([cartShoppingDic objectForKey:ECCSMeasure]);
                cartShoppingModel.unit          = DealWithJSONValue([cartShoppingDic objectForKey:ECCSUnit]);
                cartShoppingModel.itemNumber    = [[cartShoppingDic objectForKey:ECCSItemNumber] stringValue];
                cartShoppingModel.price         = [[cartShoppingDic objectForKey:ECCSPrice] stringValue];
                cartShoppingModel.oldPrice      = [[cartShoppingDic objectForKey:ECCSOldPrice] stringValue];
                cartShoppingModel.stockCount    = [[cartShoppingDic objectForKey:ECCSStockCount] stringValue];
                cartShoppingModel.favorNumber   = [[cartShoppingDic objectForKey:ECCSFavorNumber] stringValue];
                
                [weakSelf.cartShoppingsArray addObject:cartShoppingModel];
                [weakSelf.isSelectedArray addObject:@"0"];
                [weakSelf.isChangedArray addObject:@"0"];
            }
            
            if (weakSelf.cartShoppingsArray.count > 0) {
                [weakSelf.tableView reloadData];
            } else {
                [self.view addSubview:[self blankPageView]];
                [_blankPageView resetImage:[UIImage imageNamed:@"shopping_cart_empty.png"]];
                [_blankPageView resetTitle:MALL_SHOPPING_CART_EMPTY andDescribe:MALL_SHOPPING_CART_EMPTY_DESCRIBE];
                _rightBtn.hidden = YES;
                
                UIButton *goShoppingButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [goShoppingButton setFrame:CGRectMake(120, _blankPageView.frame.size.height/2-40+315/2, 80, 25)];
                [goShoppingButton setTitle:@"去逛逛" forState:UIControlStateNormal];
                [goShoppingButton setTitleColor:XQBColorExplain forState:UIControlStateNormal];
                goShoppingButton.titleLabel.font = [UIFont systemFontOfSize:12];
                goShoppingButton.backgroundColor = RGB(239, 239, 239);
                [goShoppingButton.layer setMasksToBounds:YES];
                [goShoppingButton.layer setBorderColor:[RGB(231, 231, 231) CGColor]];
                [goShoppingButton.layer setCornerRadius:3];
                [goShoppingButton.layer setBorderWidth:0.5];
                [goShoppingButton addTarget:self action:@selector(goShoppingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [_blankPageView addSubview:goShoppingButton];
            }
        } else {
            [self.view addSubview:self.blankPageView];
            [_blankPageView resetImage:[UIImage imageNamed:@"server_error.png"]];
            [_blankPageView resetTitle:SERVER_ERROR andDescribe:SERVER_ERROR_DESCRIBE];
            _rightBtn.hidden = YES;
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [XQBLoadingView hideLoadingForView:self.view];
        [self.view addSubview:self.blankPageView];
        [_blankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
        [_blankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
        _rightBtn.hidden = YES;
    }];
}

- (void)requestCartUpdate:(NSString *)productItems
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:productItems forKey:@"productItems"];
    
    [parameters addSignatureKey];
    
    __weak typeof(self) weakSelf = self;
    [manager POST:EC_CART_BATCH_UPDATE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            for (NSInteger i=weakSelf.deleteCellArray.count; 0<i; i--) {
                [weakSelf.cartShoppingsArray removeObjectAtIndex:[[_deleteCellArray objectAtIndex:i-1] integerValue]];
                [weakSelf.isSelectedArray removeObjectAtIndex:[[_deleteCellArray objectAtIndex:i-1] integerValue]];
                [weakSelf.isChangedArray removeObjectAtIndex:[[_deleteCellArray objectAtIndex:i-1] integerValue]];
                [weakSelf.tableView reloadData];
            }
            [weakSelf.deleteCellArray removeAllObjects];
            if (![weakSelf.isSelectedArray containsObject:@"0"] && weakSelf.isSelectedArray.count > 0) {
                weakSelf.selectAllButton.selected = YES;
            } else {
                weakSelf.selectAllButton.selected = NO;
            }
            
            weakSelf.totalPriceLabel.text = @"合计：￥0";
            for (NSInteger i=0; i<_isSelectedArray.count; i++) {
                if ([[weakSelf.isSelectedArray objectAtIndex:i] isEqualToString:@"1"]) {
                    NSString *string =[weakSelf.totalPriceLabel.text substringFromIndex:4];
                    ECCartShoppingModel *model = [weakSelf.cartShoppingsArray objectAtIndex:i];
                    weakSelf.totalPriceLabel.text = [NSString stringWithFormat:@"合计：%@" , [PricesShown priceOfShorthand:[string doubleValue] + [model.price doubleValue]*[model.itemNumber integerValue]]];
                }
            }
            weakSelf.selectAllButton.selected = NO;
            
            [self initBottomViewInfo];
            [self requestECCarts];
        } else {
            //加载服务器异常界面
            [self.view.window makeCustomToast:[responseObject objectForKey:NETWORK_RETURN_ERROR_MSG]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cartShoppingsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"shoppingCartCell";
    ECCartShoppingModel *model = ([_cartShoppingsArray count]>indexPath.row)?[self.cartShoppingsArray objectAtIndex:indexPath.row]:nil;
    ECShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[ECShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak typeof(cell) weakCell = cell;
        __weak typeof(self) weakSelf = self;
        cell.changeCountComponent.changeCountHandleBlock = ^(NSInteger tag, NSInteger count){
            [weakSelf.isChangedArray setObject:@"1" atIndexedSubscript:tag];
            ECCartShoppingModel *tempModel = [self.cartShoppingsArray objectAtIndex:tag];
            tempModel.itemNumber = [NSString stringWithFormat:@"%ld", (long)[weakCell.changeCountComponent getCount]];
        };
        
        cell.changeCountComponent.achieveMaxValueBlock = ^(NSInteger tag, NSInteger count){
            [self.view.window makeCustomToast:@"超出限购数量"];
        };
        
        cell.changeCountComponent.achieveMinValueBlock = ^(NSInteger tag, NSInteger count){
            [self.view.window makeCustomToast:@"编辑数量至少为1"];
        };
    }
    if ([[_isSelectedArray objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        cell.selectButton.selected = NO;
    } else {
        cell.selectButton.selected = YES;
    }
    cell.selectButton.tag = indexPath.row;
    [cell.selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.shoppingIconView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:cell.shoppingIconView.frame.size]];
    cell.shoppingNameLabel.text  = model.productName;
    cell.shoppingPriceLabel.text = [PricesShown priceOfShorthand:[model.price doubleValue]];
    
    cell.shoppingTypeLabel.text  = model.measure;
    cell.shoppingCountLabel.text = [NSString stringWithFormat:@"%@%@", model.itemNumber, model.unit];
    cell.changeCountComponent.tag = indexPath.row;
    [cell.changeCountComponent setCount:[model.itemNumber integerValue]];
    [cell.changeCountComponent setMaximumValue:[model.stockCount integerValue]];
    [cell.changeCountComponent setMinimumValue:1];
    if (_rightBtn.selected) {
        cell.shoppingNameLabel.hidden = YES;
        cell.changeCountComponent.hidden = NO;
        cell.shoppingCountLabel.hidden = YES;
        cell.selectButton.hidden = YES;
    } else {
        cell.shoppingNameLabel.hidden = NO;
        cell.changeCountComponent.hidden = YES;
        cell.shoppingCountLabel.hidden = NO;
        cell.selectButton.hidden = NO;
    }
    
    
    
    return cell;
}

#pragma mark --- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECCartShoppingModel *model = ([_cartShoppingsArray count]>indexPath.row)?[self.cartShoppingsArray objectAtIndex:indexPath.row]:nil;
    
    XQBECProductDetailViewController *productDetailVC = [[XQBECProductDetailViewController alloc] init];
    productDetailVC.productId = model.productId;
    productDetailVC.productIamgeUrl = model.cover;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableVie titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

// 当点击删除时，删除该条记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ECCartShoppingModel *model = [_cartShoppingsArray objectAtIndex:indexPath.row];
        NSString *productItems = [NSString stringWithFormat:@"%@:%d", model.productItemId, 0];
        [self requestCartUpdate:productItems];
        [_deleteCellArray addObject:[NSString stringWithFormat:@"%ld", indexPath.row]];
    }
}
@end
