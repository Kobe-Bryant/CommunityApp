//
//  XQBRegisterStepTwoViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/27.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBRegisterStepTwoViewController.h"
#import "Global.h"
#import "CustomTextField.h"
#import "XQBRegisterStepThreeViewController.h"
#import "NSString+MD5.h"


@interface XQBRegisterStepTwoViewController ()

@property (nonatomic, strong) CustomTextField *nickNameView;
@property (nonatomic, strong) CustomTextField *passwordView;
@property (nonatomic, strong) CustomTextField *confirmPasswordView;

@end

@implementation XQBRegisterStepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"注册"];
    
    //自定义返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //点击退出键盘
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:closeTap];
    
    [self.view addSubview: [self nickNameView]];
    [self.view addSubview: [self passwordView]];
    [self.view addSubview: [self confirmPasswordView]];
    [self.view addSubview: [self doneButton]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UI
- (UIView *)nickNameView
{
    _nickNameView = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBHeightElement)];
    _nickNameView.leftLabelString = @"昵称";
    _nickNameView.middleTextFieldPlaceholder = @"输入您的昵称";
    _nickNameView.bottomLineView.backgroundColor = XQBColorInternalSeparationLine;
    _nickNameView.tag = 100;
    [_nickNameView textFieldBecomeFirstResponder];
    [_nickNameView changeRightButtonSelected:YES];
    
    return _nickNameView;
}

- (UIView *)passwordView
{
    _passwordView = [[CustomTextField alloc] initWithFrame:CGRectMake(0, XQBHeightElement, MainWidth, XQBHeightElement)];
    _passwordView.secureTextEntry = YES;
    _passwordView.leftLabelString = @"密码";
    _passwordView.middleTextFieldPlaceholder = @"不少于6个字符";
    _passwordView.bottomLineView.backgroundColor = XQBColorInternalSeparationLine;
    _passwordView.tag = 101;
    [_passwordView changeRightButtonSelected:YES];
    
    return _passwordView;
}

- (UIView *)confirmPasswordView
{
    _confirmPasswordView = [[CustomTextField alloc] initWithFrame:CGRectMake(0, XQBHeightElement*2, MainWidth, XQBHeightElement)];
    _confirmPasswordView.secureTextEntry = YES;
    _confirmPasswordView.leftLabelString = @"确认密码";
    _confirmPasswordView.middleTextFieldPlaceholder = @"再次输入一遍密码";
    _confirmPasswordView.tag = 102;
    [_confirmPasswordView changeRightButtonSelected:YES];
    
    return _confirmPasswordView;
}

- (UIView *)doneButton
{
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, XQBHeightElement*3+XQBSpaceVerticalElement, MainWidth, XQBHeightElement)];
    doneButton.backgroundColor = [UIColor whiteColor];
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton setTitleColor:XQBColorGreen forState:UIControlStateNormal];
    doneButton.titleLabel.font = XQBFontContent;
    [doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, XQBHeightElement-0.5, MainWidth, 0.5)];
    lineView.backgroundColor = XQBColorElementSeparationLine;
    [doneButton addSubview:lineView];
    
    return doneButton;
}

#pragma mark --- action
-(void)closeKeyBoard
{
    [_nickNameView textFieldResignFirstResponder];
    [_passwordView textFieldResignFirstResponder];
    [_confirmPasswordView textFieldResignFirstResponder];
}

- (void)doneButtonAction
{
    [self closeKeyBoard];
    
    if ([_nickNameView getMiddleTextFieldText].length == 0) {
        [self.view.window makeCustomToast:@"请输入昵称"];
    } else if ([_passwordView getMiddleTextFieldText].length < 6) {
        [self.view.window makeCustomToast:@"至少输入6位密码"];
    } else if ([_confirmPasswordView getMiddleTextFieldText].length < 6) {
        [self.view.window makeCustomToast:@"至少输入6位密码"];
    } else if (![[_passwordView getMiddleTextFieldText] isEqualToString:[_confirmPasswordView getMiddleTextFieldText]]) {
        [self.view.window makeCustomToast:@"密码不一致"];
    } else {
        [self requestUserSetPwdAndNickname];
    }
}

#pragma mark --- AFNetworking request
- (void)requestUserSetPwdAndNickname
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:_phomeNumberString forKey:@"pn"];
    [parameters setObject:[_nickNameView getMiddleTextFieldText] forKey:@"nickname"];
    [parameters setObject:[[_passwordView getMiddleTextFieldText] uppercaseMd5]forKey:@"pwd"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_USER_REGISTER_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            NSDictionary *dataDic = [responseObject objectForKey:XQB_NETWORK_DATA];
            
            [UserModel shareUser].userId        = [[dataDic objectForKey:@"userId"] stringValue];
            [UserModel shareUser].nickName      = [dataDic objectForKey:@"nickname"];
            [UserModel shareUser].userIcon      = [dataDic objectForKey:@"icon"];
            [UserModel shareUser].gender        = [[dataDic objectForKey:@"gender"] stringValue];
            [UserModel shareUser].signature     = [dataDic objectForKey:@"signature"];
            [UserModel shareUser].birthday      = [dataDic objectForKey:@"birthday"];
            [UserModel shareUser].email         = [dataDic objectForKey:@"email"];
            [UserModel shareUser].microblog     = [dataDic objectForKey:@"microblog"];
            [UserModel shareUser].qq            = [dataDic objectForKey:@"qq"];
            [UserModel shareUser].provinceId    = [[dataDic objectForKey:@"provinceId"] stringValue];
            [UserModel shareUser].provinceName  = [dataDic objectForKey:@"provinceName"];
            [UserModel shareUser].userType      = [dataDic objectForKey:@"userType"];
            [UserModel shareUser].residentDesc  = [dataDic objectForKey:@"residentDesc"];
            [UserModel shareUser].cityId        = [[dataDic objectForKey:@"cityId"] stringValue];
            [UserModel shareUser].cityName      = [dataDic objectForKey:@"cityName"];
            [UserModel shareUser].communityId   = [[dataDic objectForKey:@"communityId"] stringValue];
            [UserModel shareUser].communityName = [dataDic objectForKey:@"communityName"];
            
            
            [UserModel shareUser].userName = _phomeNumberString;
            [UserModel shareUser].password = [[_passwordView getMiddleTextFieldText] uppercaseMd5];
            [[UserModel shareUser] syncUserInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kXQBRegisterSucceedNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kXQBLoginSucceedNotification object:nil];
            
            XQBRegisterStepThreeViewController *registerStepThreeVc = [[XQBRegisterStepThreeViewController alloc] init];
            [self.navigationController pushViewController:registerStepThreeVc animated:YES];
            
        } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_REGISTER_USER_ALREADY_EXIST]) {
            XQBLog(@"用户已存在");
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_REGISTER_REGISTER_OUT_OF_TIME]) {
            XQBLog(@"注册已过期");
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
            
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


@end
