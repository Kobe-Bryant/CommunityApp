//
//  XQBMeEdittingViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/6.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeEdittingViewController.h"
#import "Global.h"
#import "XQBMeEdittingTableViewCell.h"
#import "XQBTabPickerView.h"
#import "XQBDataLocation.h"
#import "XQBTabDatePickerView.h"
#import "XQBMeEditingSummaryViewController.h"

typedef enum
{
    EnumEdittingInputTypeAlertView = 0,         //弹出alert输入框
    EnumEdittingInputTypeViewController,        //进入下一个VC的输入形式
    EnumEdittingInputTypePickView,              //弹出选择器
} EnumEdittingInputType;

typedef enum {
    EnumPickViewTypeSex = 0,                    //性别选择器
    EnumPickViewTypeYMD,                        //年月日选择器
    EnumPickViewTypePCD,                        //省市区选择器
    EnumPickViewTypeCommunity,                  //小区选择器
} EnumPickViewType;

static const int kAlertViewTagWeight = 1000;


@interface XQBMeEdittingViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionAttributeNameArray;
@property (nonatomic, strong) NSMutableArray *sectionAttributeValueArray;
@property (nonatomic, strong) NSMutableArray *sectionInputTypeArray;

@property (nonatomic, strong) XQBTabPickerView *sexPickerView;
@property (nonatomic, strong) NSArray *sexDataSource;
@property (nonatomic, strong) XQBTabPickerView *locationPickerView;
@property (nonatomic, strong) NSArray *locationDataSource;
@property (nonatomic, strong) XQBTabDatePickerView *birthdayPicker;

@property (nonatomic, copy) UserModel *muCopyUserModel;

@end

@implementation XQBMeEdittingViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initalize];
        
        
    }
    return self;
}

- (void)initalize{
    
    _muCopyUserModel = [[UserModel shareUser] mutableCopy];
    
    self.sexDataSource = @[@"男",@"女"];
    self.locationDataSource = [XQBDataLocation shareInstance].pcList;
    
    NSMutableArray *attributeNameArray1 = [[NSMutableArray alloc] initWithObjects:
                                           @"昵称",
                                           @"性别",
                                           @"所在地",
                                           @"小区",
                                           @"简介",
                                           nil];
    NSMutableArray *attributeNameArray2 = [[NSMutableArray alloc] initWithObjects:
                                           @"生日",
                                           @"邮箱",
                                           @"微博",
                                           @"QQ",
                                           nil];
    
    
    NSMutableArray *placeHolderAttributeValueArray1 = [[NSMutableArray alloc] initWithObjects:
                                                       @"请输入您的昵称",
                                                       @"请选择您的性别",
                                                       @"选择您的所在地",
                                                       @"请选择您的小区",
                                                       @"请填写您的简介",
                                                       nil];
    NSMutableArray *placeHolderattributeValueArray2 = [[NSMutableArray alloc] initWithObjects:
                                                       @"请选择您的生日",
                                                       @"请输入您的邮箱",
                                                       @"请输入您的微博",
                                                       @"请输入您的QQ号",
                                                       nil];
    
    NSMutableArray *inputeTypeArray1 = [[NSMutableArray alloc] initWithObjects:
                                        [NSString stringWithFormat:@"%d", EnumEdittingInputTypeAlertView],
                                        [NSString stringWithFormat:@"%d", EnumEdittingInputTypePickView],
                                        [NSString stringWithFormat:@"%d", EnumEdittingInputTypePickView],
                                        [NSString stringWithFormat:@"%d", EnumEdittingInputTypePickView],
                                        [NSString stringWithFormat:@"%d", EnumEdittingInputTypeViewController],
                                        nil];
    NSMutableArray *inputeTypeArray2 = [[NSMutableArray alloc] initWithObjects:
                                        [NSString stringWithFormat:@"%d", EnumEdittingInputTypePickView],
                                        [NSString stringWithFormat:@"%d", EnumEdittingInputTypeAlertView],
                                        [NSString stringWithFormat:@"%d", EnumEdittingInputTypeAlertView],
                                        [NSString stringWithFormat:@"%d", EnumEdittingInputTypeAlertView],
                                        [NSString stringWithFormat:@"%d", EnumEdittingInputTypeAlertView],
                                        nil];
    
    _sectionAttributeNameArray = [[NSMutableArray alloc] initWithObjects:attributeNameArray1, attributeNameArray2, nil];
    _sectionAttributeValueArray = [[NSMutableArray alloc] initWithObjects:placeHolderAttributeValueArray1, placeHolderattributeValueArray2, nil];
    
    _sectionInputTypeArray = [[NSMutableArray alloc] initWithObjects:inputeTypeArray1, inputeTypeArray2, nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"编辑"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---ui
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - STATUS_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
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
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
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
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return _muCopyUserModel.nickName;
                break;
            case 1:
                return [_muCopyUserModel getGenderChar];
                break;
            case 2:
            {
                NSString *strLocation = [_muCopyUserModel.provinceName stringByAppendingString:_muCopyUserModel.cityName];
                return strLocation;
            }
                break;
            case 3:
                return _muCopyUserModel.residentDesc;
                break;
            case 4:
                return _muCopyUserModel.signature;      //用户简介
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                return _muCopyUserModel.birthday;
                break;
            case 1:
                return _muCopyUserModel.email;
                break;
            case 2:
                return _muCopyUserModel.microblog;
                break;
            case 3:
                return _muCopyUserModel.qq;
                break;
                
            default:
                break;
        }
    }
    
    return nil;
}

- (void)syncMutableCopyUserModel:(NSIndexPath *)indexPath withString:(NSString *)string
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                _muCopyUserModel.nickName = string;
                break;
            case 1:
                _muCopyUserModel.gender = string;
                break;
            case 2://省市不赋值
            {                
            }
                break;
            case 3:
                _muCopyUserModel.residentDesc = string;
                break;
            case 4:
                _muCopyUserModel.signature = string;      //用户简介
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                _muCopyUserModel.birthday = string;
                break;
            case 1:
                _muCopyUserModel.email = string;
                break;
            case 2:
                _muCopyUserModel.microblog = string;
                break;
            case 3:
                _muCopyUserModel.qq = string;
                break;
                
            default:
                break;
        }
    }
}

#pragma mark --- edittingBox
- (void)edittingBoxAlert:(NSIndexPath *)indexPath
{
    NSString *message = [self configSectionAttributeName:indexPath];
    NSString *placeHolder = [self configSectionAttributePlaceholder:indexPath];
    NSString *content = [self configSectionAttributeValue:indexPath];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *firstTextField = [alert textFieldAtIndex:0];
    firstTextField.placeholder = placeHolder;
    firstTextField.text = content;
    alert.tag = indexPath.section*kAlertViewTagWeight + indexPath.row;
    [alert show];
}

- (void)edittingBoxPickView:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {         //性别
        [self editPickSex:indexPath];
    }else if (indexPath.section == 0 && indexPath.row == 2){    //所在地
        //[self.view.window makeCustomToast:@"亲,所在地插件 开发ing,谢谢支持~~"];
        return;
        [self editPickLocation:indexPath];
    }else if (indexPath.section == 1 && indexPath.row == 0){    //生日
        //[self.view.window makeCustomToast:@"生日选择插件 开发ing,谢谢支持~~"];
        [self editPickerBirthday:indexPath];
    }
}

//选择性别
- (void)editPickSex:(NSIndexPath *)indexPath{
    _sexPickerView = [XQBTabPickerView initalize];
    _sexPickerView.pickerView.dataSource = self;
    _sexPickerView.pickerView.delegate = self;
    WEAKSELF
    [_sexPickerView setPickComplete:^(NSString *result){
        XQBLog(@"pick complete");
        NSInteger selectRow = [weakSelf.sexPickerView.pickerView selectedRowInComponent:0];
        NSString *gender = [weakSelf.sexDataSource objectAtIndex:selectRow];
        if (![gender isEqualToString:weakSelf.muCopyUserModel.gender]) {
            weakSelf.muCopyUserModel.gender = [weakSelf.sexDataSource objectAtIndex:selectRow];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf requestEditUserProfile];
        }
    }];
    [_sexPickerView setPickCancel:^(NSString *result) {
        XQBLog(@"pick cancel");
    }];
    [_sexPickerView showPickerView];
}

//选择所在地
- (void)editPickLocation:(NSIndexPath *)indexPath{
    _locationPickerView = [XQBTabPickerView initalize];
    _locationPickerView.pickerView.dataSource = self;
    _locationPickerView.pickerView.delegate = self;
    WEAKSELF
    [_locationPickerView setPickComplete:^(NSString *result){
        XQBLog(@"_locationPickerView complete");
        
        NSInteger firstSelectRow = [weakSelf.locationPickerView.pickerView selectedRowInComponent:0];
        NSInteger secondSelectRow = [weakSelf.locationPickerView.pickerView selectedRowInComponent:1];
        ProvinceModel *pModel = [weakSelf.locationDataSource objectAtIndex:firstSelectRow];
        CityModel *cModel = [pModel.cities objectAtIndex:secondSelectRow];
        weakSelf.muCopyUserModel.provinceName = pModel.name;
        weakSelf.muCopyUserModel.provinceId = pModel.pid;
        weakSelf.muCopyUserModel.cityName = cModel.cityName;
        weakSelf.muCopyUserModel.cityId = cModel.cityId;
        
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        
        [weakSelf requestEditUserProfile];
        
    }];
    [_locationPickerView setPickCancel:^(NSString *result) {
        XQBLog(@"_locationPickerView cancel");
    }];
    
    [_locationPickerView showPickerView];
}

- (void)editPickerBirthday:(NSIndexPath *)indexPath{
    _birthdayPicker = [XQBTabDatePickerView initalize];
    WEAKSELF
    [_birthdayPicker setPickComplete:^(NSString *result){
        XQBLog(@"_locationPickerView complete");
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday fromDate:weakSelf.birthdayPicker.dataPicker.date];
    
        weakSelf.muCopyUserModel.birthday = [NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day];
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        
        [weakSelf requestEditUserProfile];
    }];
    [_birthdayPicker setPickCancel:^(NSString *result) {
        XQBLog(@"_locationPickerView cancel");
    }];
    
    [_birthdayPicker showPickerView];
}

- (void)edittingBoxViewController:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 4) {
        XQBMeEditingSummaryViewController *viewController = [[XQBMeEditingSummaryViewController alloc] init];
        viewController.muCopyUserModel = self.muCopyUserModel;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark ---network
//请求编辑用户信息
- (void)requestEditUserProfile{
    UserModel *userModel = _muCopyUserModel;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    //cityId
    NSString *strCityId = userModel.cityId;
    [parameters setObject:strCityId forKey:@"cityId"];
    //userId
    NSString *strUserId = userModel.userId;
    [parameters setObject:strUserId forKey:@"userId"];
    //nick name
    NSString *strNickName = (userModel.nickName.length > 0)?userModel.nickName:@"";
    [parameters setObject:strNickName forKey:@"nickname"];
    //gender
    NSString *strGender = userModel.gender;
    [parameters setObject:strGender forKey:@"gender"];
    //signature
    NSString *strSignature = (userModel.signature.length > 0)?userModel.signature:@"";
    [parameters setObject:strSignature forKey:@"signature"];
    //birthday
    NSString *strBirthday = (userModel.birthday.length > 0)?userModel.birthday:@"";
    [parameters setObject:strBirthday forKey:@"birthday"];
    //email
    NSString *strEmail = (userModel.email.length > 0)?userModel.email:@"";
    [parameters setObject:strEmail forKey:@"email"];
    //microblog
    NSString *strMicroblog = (userModel.microblog.length > 0)?userModel.microblog:@"";
    [parameters setObject:strMicroblog forKey:@"microblog"];
    //qq
    NSString *strQQ = (userModel.qq.length > 0)?userModel.qq:@"";
    [parameters setObject:strQQ forKey:@"qq"];
    [parameters addSignatureKey];
    
    [manager POST:API_USER_EDIT_PROFILE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            XQBLog(@"更新个人信息成功");
            //同步个人信息
            [_muCopyUserModel copyUserInfoToInstance];
            [self.view.window makeCustomToast:@"修改成功"];
        } else {
            //加载服务器异常界面
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];

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
    XQBMeEdittingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[XQBMeEdittingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.attributeNameLabel.text = [self configSectionAttributeName:indexPath];
    cell.placeHolderLabel.text = [self configSectionAttributePlaceholder:indexPath];
    NSString *attributeValue = [self configSectionAttributeValue:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 2 || indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (attributeValue.length > 0) {
        cell.placeHolderLabel.text = nil;
        cell.attributeValueLabel.text = attributeValue;
        
    }else{
        cell.attributeValueLabel.text = nil;
    }
    return cell;
}

#pragma mark --- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return XQBHeightElement;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[[_sectionInputTypeArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue] == EnumEdittingInputTypeAlertView) {
        [self edittingBoxAlert:indexPath];
    } else if ([[[_sectionInputTypeArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue] == EnumEdittingInputTypePickView) {
        [self edittingBoxPickView:indexPath];
    } else if ([[[_sectionInputTypeArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue] == EnumEdittingInputTypeViewController) {
        [self edittingBoxViewController:indexPath];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return XQBSpaceVerticalElement;
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

#pragma mark --- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if (buttonIndex == 1) {
        NSInteger section = alertView.tag/kAlertViewTagWeight;
        NSInteger row = alertView.tag%kAlertViewTagWeight;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [[_sectionAttributeValueArray objectAtIndex:section] replaceObjectAtIndex:row withObject:[alertView textFieldAtIndex:0].text];
        [self syncMutableCopyUserModel:indexPath withString:[alertView textFieldAtIndex:0].text];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:section], nil] withRowAnimation:UITableViewRowAnimationNone];
        [self requestEditUserProfile];
        //XQBMeEdittingTableViewCell *cell = (XQBMeEdittingTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        //[cell setEditDone:YES];
    }
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -------UIPickerViewDataSource
//@required

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == _sexPickerView.pickerView) {
        return 1;
    }else if (pickerView == _locationPickerView.pickerView){
        return 2;
    }
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerView == _sexPickerView.pickerView) {
        return 2;
    }else if (pickerView == _locationPickerView.pickerView){
        if (component == 0) {
            return [self.locationDataSource count];
        }else if (component == 1){
            NSInteger index = [pickerView selectedRowInComponent:0];
            ProvinceModel *model = [self.locationDataSource objectAtIndex:index];
            return [model.cities count];
        }
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == _sexPickerView.pickerView) {
        return ([self.sexDataSource count] > row)?[self.sexDataSource objectAtIndex:row]:@"";
    }else if (pickerView == _locationPickerView.pickerView){
        if (component == 0) {
            ProvinceModel *model = [self.locationDataSource objectAtIndex:row];
            return model.name;
        }else if (component == 1){
            NSInteger index = [pickerView selectedRowInComponent:0];
            ProvinceModel *model = [self.locationDataSource objectAtIndex:index];
            CityModel *cityModel = [model.cities objectAtIndex:row];
            return cityModel.cityName;
        }
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _sexPickerView.pickerView) {
        
    }else if (pickerView == _locationPickerView.pickerView){
        if (component == 0) {
            [pickerView reloadComponent:1];
        }else if (component == 1){

        }
    }
}

@end
