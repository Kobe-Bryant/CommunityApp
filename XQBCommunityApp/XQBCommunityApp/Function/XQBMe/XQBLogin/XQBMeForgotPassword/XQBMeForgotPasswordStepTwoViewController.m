//
//  XQBMeForgotPasswordStepTwoViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/8.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeForgotPasswordStepTwoViewController.h"
#import "Global.h"
#import "CustomTextField.h"
#import "XQBMeForgotPasswordStepThreeViewController.h"
#import "NSString+MD5.h"

@interface XQBMeForgotPasswordStepTwoViewController ()

@property (nonatomic, strong) CustomTextField *passwordView;
@property (nonatomic, strong) CustomTextField *confirmPasswordView;

@end

@implementation XQBMeForgotPasswordStepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"重置密码"];
    
    //自定义返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //点击退出键盘
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:closeTap];
    
    [self.view addSubview: [self passwordView]];
    [self.view addSubview: [self confirmPasswordView]];
    [self.view addSubview: [self doneButton]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark --- UI
- (UIView *)passwordView
{
    _passwordView = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBHeightElement)];
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
    _confirmPasswordView = [[CustomTextField alloc] initWithFrame:CGRectMake(0, XQBHeightElement, MainWidth, XQBHeightElement)];
    _confirmPasswordView.secureTextEntry = YES;
    _confirmPasswordView.leftLabelString = @"确认密码";
    _confirmPasswordView.middleTextFieldPlaceholder = @"再次输入一遍密码";
    _confirmPasswordView.tag = 102;
    [_confirmPasswordView changeRightButtonSelected:YES];
    
    return _confirmPasswordView;
}

- (UIView *)doneButton
{
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, XQBHeightElement*2+XQBSpaceVerticalElement, MainWidth, XQBHeightElement)];
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
    [_passwordView textFieldResignFirstResponder];
    [_confirmPasswordView textFieldResignFirstResponder];
}

- (void)doneButtonAction
{
    [self closeKeyBoard];
    
    if ([_passwordView getMiddleTextFieldText].length < 6) {
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
    [parameters setObject:self.userIdString forKey:@"userId"];
    [parameters setObject:[[_passwordView getMiddleTextFieldText] uppercaseMd5] forKey:@"newPassword"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_USER_RESET_PASSWORD parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            XQBLog(@"修改密码成功");
            
            XQBMeForgotPasswordStepThreeViewController *forgotPasswordStepThree = [[XQBMeForgotPasswordStepThreeViewController alloc] init];
            [self.navigationController pushViewController:forgotPasswordStepThree animated:YES];
            
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
