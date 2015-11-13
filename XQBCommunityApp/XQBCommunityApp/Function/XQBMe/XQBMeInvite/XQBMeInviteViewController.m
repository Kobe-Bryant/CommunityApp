//
//  XQBMeInviteViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/11.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeInviteViewController.h"
#import "Global.h"
#import "ValidateNumber.h"

static const CGFloat kPhoneLabelWidth       = 55.0f;
static const CGFloat kLineMarginVertical    = 5.0f;

@interface XQBMeInviteViewController ()

@property (nonatomic, strong) UITextField *phoneField;

@end

@implementation XQBMeInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"邀请注册"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"邀请" forState:UIControlStateNormal];
    [rightBtn setTitleColor:XQBColorGreen forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,70,44);
    [self setRightBarButtonItem:rightBtn];
    
    self.view.backgroundColor = XQBColorBackground;
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, XQBSpaceVerticalElement, MainWidth, XQBHeightElement)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 0, kPhoneLabelWidth, XQBHeightElement)];
    phoneLabel.font = XQBFontContent;
    phoneLabel.text = @"手机号";
    phoneLabel.textColor = XQBColorContent;
    [phoneView addSubview:phoneLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal+kPhoneLabelWidth, kLineMarginVertical, 0.5, XQBHeightElement-kLineMarginVertical*2)];
    lineView.backgroundColor = XQBColorInternalSeparationLine;
    [phoneView addSubview:lineView];
    
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(kPhoneLabelWidth+0.5+XQBMarginHorizontal*2, 0, MainWidth-kPhoneLabelWidth-0.5-XQBMarginHorizontal, XQBHeightElement)];
    _phoneField.font = XQBFontContent;
    _phoneField.placeholder = @"您的手机号码";
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView addSubview:_phoneField];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_phoneField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    if ([ValidateNumber validateMobile:_phoneField.text]) {
        [self requestInvitationRegister];
    } else {
        [self.view.window makeCustomToast:@"请输入正确手机号"];
        sender.userInteractionEnabled = YES;
    }
}

#pragma mark --- AFNetwork
- (void)requestInvitationRegister
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:_phoneField.text forKey:@"pn"];
    
    [parameters addSignatureKey];
    [manager GET:API_USER_INVITATION_REGISTER_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            [self.view.window makeCustomToast:@"发送邀请成功"];
            [self performSelector:@selector(backHandle:) withObject:nil afterDelay:1.5];
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
