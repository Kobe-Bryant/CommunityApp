//
//  XQBLginViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/3.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBLginViewController.h"
#import "Global.h"
#import "XQBGuestSettingViewController.h"
#import "XQBRegisterStepOneViewController.h"
#import "XQBMeForgotPasswordStepOneViewController.h"
#import "ValidateNumber.h"
#import "NSString+MD5.h"
#import "XQBMeViewController.h"
#import "XQBLoginNavigationController.h"

static const CGFloat kSpaceVerticalLarge        = 70.0f;
static const CGFloat kSpaceVerticalMiddle       = 50.0f;
static const CGFloat kSpaceVerticalLittle       = 20.0f;

@interface XQBLginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *dismissButton;

@property (nonatomic, strong) UIView *phoneContentView;
@property (nonatomic, strong) UIView *passwordContentView;

@end

@implementation XQBLginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutSucceedNotice:) name:kXQBLogoutSucceedNotification object:nil];
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:closeTap];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"unlogin_blur_background.jpg"];
    [self.view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kSpaceVerticalLarge, MainWidth, 25)];
    titleLabel.font = [UIFont systemFontOfSize:24.0f];
    titleLabel.text = @"玩转小区宝";
    titleLabel.shadowColor = XQBColorExplain;
    titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *titleExplainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y(titleLabel)+HEIGHT(titleLabel)+10, MainWidth, 17)];
    titleExplainLabel.font = [UIFont systemFontOfSize:15.0f];
    titleExplainLabel.text = @"来!注册后解锁更多乐趣";
    titleExplainLabel.shadowColor = XQBColorExplain;
    titleExplainLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    titleExplainLabel.textColor = [UIColor whiteColor];
    titleExplainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleExplainLabel];
    
    
    _phoneContentView = [[UIView alloc] initWithFrame:CGRectMake(50, BOTTOM(titleExplainLabel)+kSpaceVerticalMiddle-5, 220, 35)];
    _phoneContentView.backgroundColor = RGBA(255, 255, 255, 0.2);
    _phoneContentView.layer.cornerRadius = 5.0f;
    [self.view addSubview:_phoneContentView];
    
    UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 20, 20)];
    phoneImageView.image = [UIImage imageNamed:@"me_account.png"];
    [_phoneContentView addSubview:phoneImageView];
    
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(RIGHT(phoneImageView)+15, Y(phoneImageView), 215-WIDTH(phoneImageView)-15, HEIGHT(phoneImageView))];
    _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入登录手机号" attributes:@{NSForegroundColorAttributeName: XQBColorContent}];
    _phoneField.font = [UIFont systemFontOfSize:17.0f];
    _phoneField.textColor = XQBColorContent;//[UIColor whiteColor];
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneContentView addSubview:_phoneField];
    
    /*
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(50, BOTTOM(phoneImageView)+5, 220, 1)];
    lineView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView1];
    */
    
    _passwordContentView = [[UIView alloc] initWithFrame:CGRectMake(50, BOTTOM(_phoneContentView)+5, 220, 35)];
    _passwordContentView.backgroundColor = RGBA(255, 255, 255, 0.2);
    _passwordContentView.layer.cornerRadius = 5.0f;
    [self.view addSubview:_passwordContentView];
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 20, 20)];
    passwordImageView.image = [UIImage imageNamed:@"me_password.png"];
    [_passwordContentView addSubview:passwordImageView];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(RIGHT(passwordImageView)+15, 8, 215-WIDTH(passwordImageView)-15, HEIGHT(passwordImageView))];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName: XQBColorContent}];
    _passwordField.font = [UIFont systemFontOfSize:17.0f];
    _passwordField.textColor = XQBColorContent;//[UIColor whiteColor];
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    [_passwordContentView addSubview:_passwordField];
    
    /*
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(50, Y(passwordImageView)+HEIGHT(passwordImageView)+5, 220, 1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView2];
    */
    UIButton *forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotPasswordButton.frame = CGRectMake(50, BOTTOM(_passwordContentView)+10, MainWidth-100, 15);
    forgotPasswordButton.titleLabel.font = XQBFontExplain;
    forgotPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgotPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
    [forgotPasswordButton addTarget:self action:@selector(forgotPasswordHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotPasswordButton];
    
    UIButton *logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logInButton.backgroundColor = XQBColorGreen;
    logInButton.frame = CGRectMake(50, BOTTOM(_passwordContentView)+kSpaceVerticalMiddle, 220, 40);
    logInButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [logInButton setTitle:@"登录" forState:UIControlStateNormal];
    [logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logInButton.layer setCornerRadius:5.0f];
    [logInButton addTarget:self action:@selector(logInHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logInButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = [UIColor clearColor];
    registerButton.frame = CGRectMake(50, Y(logInButton)+HEIGHT(logInButton)+kSpaceVerticalLittle, 220, 40);
    registerButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:XQBColorOrange forState:UIControlStateNormal];
    [registerButton.layer setCornerRadius:5.0f];
    [registerButton.layer setBorderWidth:0.5f];
    [registerButton.layer setBorderColor:[XQBColorOrange CGColor]];
    [registerButton addTarget:self action:@selector(registerHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.backgroundColor = [UIColor clearColor];
    settingButton.frame = CGRectMake(MainWidth-80, 25, 80, 30);
    settingButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [settingButton setTitle:@"  设置" forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [settingButton setImage:[UIImage imageNamed:@"me_setting_icon.png"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dismissButton.frame = CGRectMake(XQBMarginHorizontal-5, 20, 35, 35);
    [_dismissButton setImage:[UIImage imageNamed:@"home_menu_play_close.png"] forState:UIControlStateNormal];
    [_dismissButton addTarget:self action:@selector(dismissHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dismissButton];
    _dismissButton.hidden = self.hiddenDismissButton;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self closeKeyBoard];
}

#pragma mark --- action
-(void)closeKeyBoard
{
    [_phoneField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)logInHandle:(UIButton *)sender{
    if (_phoneField.text.length == 0) {
        [self.view.window makeCustomToast:@"请输入正确的手机号"];
    } else if (![ValidateNumber validateMobile:_phoneField.text]) {
        [self.view.window makeCustomToast:@"请输入正确的手机号"];
    } else if (_passwordField.text.length == 0) {
        [self.view.window makeCustomToast:@"密码不能为空"];
    } else {
        [self requestLogin];
    }
}

- (void)registerHandle:(UIButton *)sender
{
    XQBRegisterStepOneViewController *registerStepOneVc = [[XQBRegisterStepOneViewController alloc] init];
    registerStepOneVc.navigationBarHidden = YES;
    registerStepOneVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerStepOneVc animated:YES];
}


- (void)forgotPasswordHandle:(UIButton *)sender
{
    XQBMeForgotPasswordStepOneViewController *forgotPasswordStepOne = [[XQBMeForgotPasswordStepOneViewController alloc] init];
    forgotPasswordStepOne.navigationBarHidden = YES;
    forgotPasswordStepOne.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:forgotPasswordStepOne animated:YES];
}


- (void)settingHandle:(UIButton *)sender{
    XQBGuestSettingViewController *guestSettingVC = [[XQBGuestSettingViewController alloc] initWithNibName:nil bundle:nil];
    guestSettingVC.navigationBarHidden = YES;
    guestSettingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guestSettingVC animated:YES];
}

- (void)dismissHandle:(UIButton *)sender{
    [self dismiss];
}

- (void)reset{
    self.phoneField.text = nil;
    self.passwordField.text = nil;
}

- (void)setHiddenDismissButton:(BOOL)hiddenDismissButton{
    _hiddenDismissButton = hiddenDismissButton;
    _dismissButton.hidden = hiddenDismissButton;
}

#pragma mark --- blurView
- (FXBlurView *)blurView{
    if (!_blurView) {
        /*
         _blurView = [[FXBlurView alloc] initWithFrame:self.view.bounds];
         _blurView.backgroundColor = RGBA(150, 150, 150, 1);
         _blurView.blurRadius = 100;
         _blurView.dynamic = YES;
         */
    }
    
    return _blurView;
}

- (void)showWithAnimation:(BOOL)animation{

    self.view.transform = CGAffineTransformMakeTranslation(0, HEIGHT(self.view));
    if (animation) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.view.transform = CGAffineTransformIdentity;
                             //self.blurView.transform = CGAffineTransformIdentity;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }else{
        self.view.transform = CGAffineTransformIdentity;
    }
}


- (void)dismiss{
    [self dismissWithAnimation:YES];
}

- (void)dismissWithAnimation:(BOOL)animation{
    self.phoneField.text = nil;
    self.passwordField.text = nil;
    
    if ([self.navigationController respondsToSelector:@selector(dismissWithAnimation:)]) {
        [(XQBLoginNavigationController*)(self.navigationController) dismissWithAnimation:animation];
    }
    
    
}

#pragma mark --- AFNetworking request
- (void)requestLogin
{
    [self closeKeyBoard];
    [XQBLoadingView showLoadingAddedToView:self.view.window withOffset:UIOffsetMake(0, -30)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:_phoneField.text forKey:@"username"];
    NSString *md5Password = [_passwordField.text uppercaseMd5];
    [parameters setObject:md5Password forKey:@"password"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_USER_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            XQBLog(@"登录成功");
            [self.view.window makeCustomToast:@"登录成功" ];
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
            
            [UserModel shareUser].userName      = _phoneField.text;
            [UserModel shareUser].password      = [_passwordField.text uppercaseMd5];
            
            [[UserModel shareUser] syncUserInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kXQBLoginSucceedNotification object:nil];
            
            [self dismiss];
            
        } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_LOGIN_USER_NOT_EXIST]) {
            XQBLog(@"%@", [responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]);
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_LOGIN_PASSWORD_EMPTY]) {
            XQBLog(@"%@", [responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]);
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_LOGIN_PASSWORD_INCORRETC]) {
            XQBLog(@"%@", [responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]);
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        } else {
            //加载服务器异常界面
            XQBLog(@"服务器异常");
            [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        }
        sleep(2);
        [XQBLoadingView hideLoadingForView:self.view.window];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [XQBLoadingView hideLoadingForView:self.view.window];
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestLogin];
    return YES;
}

#pragma mark --- notice
- (void)userLogoutSucceedNotice:(NSNotification *)notice{
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

@end
