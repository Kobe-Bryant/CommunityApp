//
//  ShippingAddressDetailViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "ShippingAddressDetailViewController.h"
#import "Global.h"
#import "ShippingAddressDetailCell.h"
#import "ValidateNumber.h"
#import "CityArearListViewController.h"


static const int kTextFeildTagWeight = 1000;

@interface ShippingAddressDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *sectionAttributeNameArray;
@property (nonatomic, strong) NSMutableArray *sectionAttributeValueArray;

@property (nonatomic, strong) NSString *tmpPCDString;

@end

@implementation ShippingAddressDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = XQBColorBackground;
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    
    if (!_addressModel) {
        [self setNavigationTitle:@"添加收货地址"];
        
        _addressModel = [[ShippingAddressModel alloc] init];
        _addressModel.shippingAddressId = @"0";
        _addressModel.isDefault = @"1";
        if (_addressModel.pcd.length == 0) {
            _addressModel.pcd = [NSString stringWithFormat:@"%@ %@", [UserModel shareUser].provinceName, [UserModel shareUser].cityName];
            
            if (_addressModel.pcd.length == 1) {
                _addressModel.pcd = nil;
            }
        }
        _tmpPCDString = _addressModel.pcd;
    } else {
        [self setNavigationTitle:@"收货地址详情"];
    }
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"bg_awardView_selectedAdress.png"] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(rightBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,70,44);
    [self setRightBarButtonItem:rightBtn];
    
    [self initalize];
    [self.view addSubview:self.tableView];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initalize{
    NSMutableArray *attributeNameArray1 = [[NSMutableArray alloc] initWithObjects:
                                           @"收货人",
                                           nil];
    NSMutableArray *attributeNameArray2 = [[NSMutableArray alloc] initWithObjects:
                                           @"手机号码",
                                           @"邮政编码",
                                           @"所在地区",
                                           @"详细地址",
                                           nil];
    
    
    NSMutableArray *placeHolderAttributeValueArray1 = [[NSMutableArray alloc] initWithObjects:
                                                       @"名字",
                                                       nil];
    NSMutableArray *placeHolderattributeValueArray2 = [[NSMutableArray alloc] initWithObjects:
                                                       @"请选择您的手机号",
                                                       @"请输入您的邮政编码",
                                                       @"请输入您的地区信息",
                                                       @"请输入您的街道门牌号",
                                                       nil];
    
    _sectionAttributeNameArray = [[NSMutableArray alloc] initWithObjects:attributeNameArray1, attributeNameArray2, nil];
    _sectionAttributeValueArray = [[NSMutableArray alloc] initWithObjects:placeHolderAttributeValueArray1, placeHolderattributeValueArray2, nil];
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
        _tableView.sectionHeaderHeight = XQBSpaceVerticalElement;
        
        _tableView.separatorColor = XQBColorInternalSeparationLine;
    }
    return _tableView;
}

#pragma mark ---action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnHandle:(UIButton *)sender
{
    if ([self checkForm]) {
        [self requestShippingSaveOrUpdate];
    }
}

//表单验证
- (BOOL)checkForm {
    if (self.addressModel.consignee.length == 0) {
        [self.view.window makeCustomToast:@"收货人不能为空！"];
        return FALSE;
    }else if (self.addressModel.phone.length == 0) {
        [self.view.window makeCustomToast:@"手机号码不能为空！"];
        return FALSE;
    }else if (![ValidateNumber validateMobile:self.addressModel.phone]) {
        [self.view.window makeCustomToast:@"手机号码格式错误！"];
        return FALSE;
    }else if ([self.addressModel.pcd isEqualToString:_tmpPCDString]) {
        [self.view.window makeCustomToast:@"请选择所在地区！"];
        return FALSE;
    }else if (self.addressModel.address.length == 0) {
        [self.view.window makeCustomToast:@"详细地址不能为空！"];
        return FALSE;
    }else if (self.addressModel.zipCode.length != 6) {
        if (self.addressModel.zipCode.length == 0) {
            _addressModel.zipCode = @"";
            return TRUE;
        } else {
            [self.view.window makeCustomToast:@"邮编只能为6位！"];
            return FALSE;
        }
    }else {
        return TRUE;
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    _tableView.frame = CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - STATUS_NAV_BAR_HEIGHT - TABBAR_HEIGHT - height/2);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _tableView.frame = CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - STATUS_NAV_BAR_HEIGHT - TABBAR_HEIGHT);
}

#pragma mark --- conifge section
- (NSString *)configSectionAttributeName:(NSIndexPath *)indexPath
{
    return [[_sectionAttributeNameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSString *)configSectionAttributePlaceholder:(NSIndexPath *)indexPath
{
    return [[_sectionAttributeValueArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSString *)configSectionAttributeValue:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            return _addressModel.consignee;
        } case 1: {
            switch (indexPath.row) {
                case 0: {
                    return _addressModel.phone;
                } case 1: {
                    return _addressModel.zipCode;
                } case 2: {
                    return _addressModel.pcd;
                } case 3: {
                    return _addressModel.address;
                }
                default:
                    return nil;
            }
        }
        default:
            return nil;
    }
}


#pragma mark --- AFNetwork
- (void)requestShippingSaveOrUpdate
{    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:_addressModel.shippingAddressId forKey:@"id"];
    [parameters setObject:_addressModel.consignee forKey:@"consignee"];
    [parameters setObject:_addressModel.phone forKey:@"phone"];
    [parameters setObject:_addressModel.zipCode forKey:@"zipCode"];
    [parameters setObject:_addressModel.province forKey:@"province"];
    [parameters setObject:_addressModel.city forKey:@"city"];
    [parameters setObject:_addressModel.area forKey:@"district"];
    [parameters setObject:_addressModel.address forKey:@"address"];
    [parameters setObject:_addressModel.isDefault forKey:@"isDefault"];
    
    [parameters addSignatureKey];
    
    [manager GET:EC_SHIPPING_SAVE_OR_UPDATE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
            [self backHandle:nil];
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

#pragma mark --- textField delegate
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag/kTextFeildTagWeight) {
        case 0: {
            _addressModel.consignee = textField.text;
            break;
        } case 1: {
            switch (textField.tag%kTextFeildTagWeight) {
                case 0: {
                    _addressModel.phone = textField.text;
                    break;
                } case 1: {
                    _addressModel.zipCode = textField.text;
                    break;
                } case 2: {
                    _addressModel.pcd = textField.text;
                    break;
                } case 3: {
                    _addressModel.address = textField.text;
                    break;
                }
                default:
                    break;
            }
        }
        default:
            break;
    }
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
    return [_sectionAttributeNameArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_sectionAttributeNameArray objectAtIndex:section] count]>0 ? [[_sectionAttributeNameArray objectAtIndex:section] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    ShippingAddressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[ShippingAddressDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
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
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.attributeValueField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.attributeValueField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.attributeValueField.enabled = NO;
    }
    
    cell.attributeNameLabel.text = [self configSectionAttributeName:indexPath];
    cell.attributeValueField.placeholder = [self configSectionAttributePlaceholder:indexPath];
    cell.attributeValueField.text = [self configSectionAttributeValue:indexPath];
    cell.attributeValueField.tag = kTextFeildTagWeight*indexPath.section + indexPath.row;
    [cell.attributeValueField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

#pragma mark --- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return XQBHeightElement;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return XQBSpaceVerticalElement;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        CityArearListViewController *cityArearListVC = [[CityArearListViewController alloc] init];
        cityArearListVC.distanceDidSelectedCompleteBlock = ^(CityDistrictsModel *districtModel){
            self.addressModel.pcd = [NSString stringWithFormat:@"%@ %@",districtModel.pcName,districtModel.districtName];
            self.addressModel.province = districtModel.pId;
            self.addressModel.city = districtModel.cId;
            self.addressModel.area = districtModel.districtsId;
        };
        [self.navigationController pushViewController:cityArearListVC animated:YES];
    }
}

@end
