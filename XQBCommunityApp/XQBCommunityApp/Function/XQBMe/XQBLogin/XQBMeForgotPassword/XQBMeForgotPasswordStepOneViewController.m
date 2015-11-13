//
//  XQBMeForgotPasswordStepOneViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/8.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeForgotPasswordStepOneViewController.h"
#import "Global.h"
#import "CustomTextField.h"
#import "ValidateNumber.h"
#import "UserModel.h"
#import "XQBMeForgotPasswordStepTwoViewController.h"

@interface XQBMeForgotPasswordStepOneViewController () <CustomTextFieldDelegate>

@property (nonatomic, strong) CustomTextField *phoneTextField;
@property (nonatomic, strong) CustomTextField *verificationCodeTextField;

@end

@implementation XQBMeForgotPasswordStepOneViewController

- (void)dealloc{
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"重置密码"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //点击退出键盘
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:closeTap];
    
    [self.view addSubview:[self phoneView]];
    [self.view addSubview:[self authCodeView]];
    [self.view addSubview:[self doneButton]];
    [self.view addSubview:[self userAgreementView]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_phoneTextField textFieldBecomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self closeKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UI
- (UIView *)phoneView
{
    _phoneTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBHeightElement)];
    _phoneTextField.textFieldType = CustomTextFieldTypeNone;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.leftLabelString = @"手机号";
    _phoneTextField.middleTextFieldPlaceholder = @"输入手机号码";
    _phoneTextField.bottomLineView.backgroundColor = XQBColorInternalSeparationLine;
    
    return _phoneTextField;
}

- (UIView *)authCodeView
{
    _verificationCodeTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, XQBHeightElement, MainWidth, XQBHeightElement)];
    _verificationCodeTextField.textFieldType = CustomTextFieldTypeAuthCode;
    _verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _verificationCodeTextField.leftLabelString = @"验证码";
    _verificationCodeTextField.middleTextFieldPlaceholder = @"输入验证码";
    _verificationCodeTextField.delegate = self;
    
    return _verificationCodeTextField;
}

- (UIView *)doneButton
{
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, XQBHeightElement*2+XQBSpaceVerticalElement, MainWidth, XQBHeightElement)];
    doneButton.backgroundColor = [UIColor whiteColor];
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton setTitleColor:XQBColorGreen forState:UIControlStateNormal];
    doneButton.titleLabel.font = XQBFontHeadline;
    [doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, XQBHeightElement-0.5, MainWidth, 0.5)];
    lineView.backgroundColor = XQBColorElementSeparationLine;
    [doneButton addSubview:lineView];
    
    return doneButton;
}

- (UIView *)userAgreementView
{
    UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementButton.frame = CGRectMake(XQBMarginHorizontal, XQBHeightElement*3+XQBSpaceVerticalElement+5, MainWidth-XQBMarginHorizontal*2, XQBHeightLabelContent);
    agreementButton.titleLabel.font = XQBFontTabbarItem;
    [agreementButton setTitle:@"  我已同意《用户使用协议》" forState:UIControlStateNormal];
    [agreementButton setTitleColor:XQBColorExplain forState:UIControlStateNormal];
    [agreementButton setImage:[UIImage imageNamed:@"user_agreement"] forState:UIControlStateNormal];
    [agreementButton setUserInteractionEnabled:NO];
    [agreementButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    return agreementButton;
}

#pragma mark --- action
- (void)leftBtnAction
{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)closeKeyBoard
{
    [_phoneTextField textFieldResignFirstResponder];
    [_verificationCodeTextField textFieldResignFirstResponder];
}

- (void)doneButtonAction
{
    [self closeKeyBoard];
    
    if ([_phoneTextField getMiddleTextFieldText].length == 0) {
        [self.view.window makeCustomToast:@"请输入正确手机号"];
    } else if (![ValidateNumber validateMobile:[_phoneTextField getMiddleTextFieldText]]) {
        [self.view.window makeCustomToast:@"请输入正确手机号"];
    } else if ([_verificationCodeTextField getMiddleTextFieldText].length == 0) {
        [self.view.window makeCustomToast:@"请输入正确的验证码"];
    } else {
        [self requestUsersRegistrationPhone];
    }
}

#pragma mark --- AFNetworking request
- (void)requestUsersRegistrationVcode
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:[_phoneTextField getMiddleTextFieldText] forKey:@"pn"];
    [parameters setObject:VERIFICATION_CODE_TYPE_FINDBACKPASSWORD forKey:@"serviceType"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_VCODE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            XQBLog(@"发送验证码成功");
            
        } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_VCODE_PHONE_INCORRECT]) {
            XQBLog(@"手机号格式有问题");
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
            [_verificationCodeTextField stopAuthCodeTimmer];
        } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_VCODE_USER_ALREADY_EXIST]) {
            XQBLog(@"用户已存在");
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
            [_verificationCodeTextField stopAuthCodeTimmer];
        } else {
            //加载服务器异常界面
            XQBLog(@"服务器异常");
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
            [_verificationCodeTextField stopAuthCodeTimmer];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [_verificationCodeTextField stopAuthCodeTimmer];
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
}

- (void)requestUsersRegistrationPhone
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:[_phoneTextField getMiddleTextFieldText] forKey:@"phoneNumber"];
    [parameters setObject:[_verificationCodeTextField getMiddleTextFieldText] forKey:@"vcode"];
    
    
    [parameters addSignatureKey];
    
    [manager POST:API_USER_VERIFY_FIND_PASSWORD_VCODE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            XQBLog(@"验证成功");
            NSDictionary *dataDic = [responseObject objectForKey:XQB_NETWORK_DATA];
    
            XQBMeForgotPasswordStepTwoViewController *forgotPasswordStepTwo = [[XQBMeForgotPasswordStepTwoViewController alloc] init];
            forgotPasswordStepTwo.userIdString = [[dataDic objectForKey:@"userId"] stringValue];
            [self.navigationController pushViewController:forgotPasswordStepTwo animated:YES];
            
        } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_RESET_PASSWORD_USER_NOT_EXIST]) {
            XQBLog(@"用户名不存在");
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_RESET_PASSWORD_OUT_OF_TIMEE]) {
            XQBLog(@"重置密码已过期");
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        } else {
            //加载服务器异常界面
            XQBLog(@"服务器异常");
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
}

#pragma mark --- customTextField delegate
- (void)customTextField:(UITextField *)textField rightButtonClicked:(UIButton *)button
{
    if ([ValidateNumber validateMobile:[_phoneTextField getMiddleTextFieldText]]) {
        [_verificationCodeTextField startAuthCodeTimmer];
        [_phoneTextField textFieldResignFirstResponder];
        [_verificationCodeTextField textFieldBecomeFirstResponder];
        [self requestUsersRegistrationVcode];
    } else {
        XQBLog(@"请输入正确手机号！");
        [self.view.window makeCustomToast:@"请输入正确手机号"];
        [_verificationCodeTextField stopAuthCodeTimmer];
    }
}


@end
