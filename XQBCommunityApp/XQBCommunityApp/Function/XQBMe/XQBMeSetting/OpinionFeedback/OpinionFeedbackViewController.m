//
//  OpinionFeedbackViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/11.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "OpinionFeedbackViewController.h"
#import "Global.h"
#import "ValidateNumber.h"

static const CGFloat kPhoneLabelWidth       = 55.0f;
static const CGFloat kLineMarginVertical    = 5.0f;
static const CGFloat kOpinionTextViewHeigth = 150.0f;

@interface OpinionFeedbackViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextView *opinionTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation OpinionFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"意见反馈"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kPhoneLabelWidth+XQBMarginHorizontal, kLineMarginVertical, 0.5, XQBHeightElement-kLineMarginVertical*2)];
    lineView.backgroundColor = XQBColorInternalSeparationLine;
    [phoneView addSubview:lineView];
    
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(kPhoneLabelWidth+0.5+XQBMarginHorizontal*2, 0, MainWidth-kPhoneLabelWidth-0.5-XQBMarginHorizontal*2, XQBHeightElement)];
    _phoneField.font = XQBFontContent;
    _phoneField.placeholder = @"您的手机号码";
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView addSubview:_phoneField];
    
    
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, XQBHeightElement+XQBSpaceVerticalElement*2, MainWidth-XQBMarginHorizontal*2, 12)];
    explainLabel.font = XQBFontExplain;
    explainLabel.text = @"您的意见或建议一经采纳，我们将送您丰厚的礼品！";
    explainLabel.textColor = XQBColorExplain;
    [self.view addSubview:explainLabel];
    
    
    UIView *opinionTextBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, XQBHeightElement+XQBSpaceVerticalElement*3+HEIGHT(explainLabel), MainWidth, kOpinionTextViewHeigth)];
    opinionTextBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:opinionTextBackgroundView];
    
    _opinionTextView = [[UITextView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal-5, (XQBSpaceVerticalItem-5), MainWidth-(XQBMarginHorizontal-5)*2, kOpinionTextViewHeigth-(XQBSpaceVerticalItem-5)*2)];
    _opinionTextView.font = XQBFontContent;
    _opinionTextView.delegate = self;
    _opinionTextView.returnKeyType = UIReturnKeyDone;
    [opinionTextBackgroundView addSubview:_opinionTextView];
    
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 9, WIDTH(_opinionTextView)-5*2, 14)];
    if (_opinionTextView.text.length > 0) {
        _placeHolderLabel.text = nil;
    }else{
        _placeHolderLabel.text = @"请输入详细信息";
    }
    
    _placeHolderLabel.font = XQBFontContent;
    _placeHolderLabel.textColor = XQBColorExplain;
    _placeHolderLabel.enabled = NO;//lable必须设置为不可用
    _placeHolderLabel.backgroundColor = [UIColor clearColor];
    [_opinionTextView addSubview:_placeHolderLabel];
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
    [_phoneField resignFirstResponder];
    [_opinionTextView resignFirstResponder];
    
    sender.userInteractionEnabled = NO;
    
    if ([ValidateNumber validateMobile:_phoneField.text]) {
        if (_opinionTextView.text.length > 0) {
            [self requestFeedBack];
        } else {
            [self.view.window makeCustomToast:@"请输入您的意见"];
        }
    } else {
        XQBLog(@"请输入正确手机号！");
        [self.view.window makeCustomToast:@"请输入正确手机号"];
        sender.userInteractionEnabled = YES;
    }
}

- (void)requestFeedBack
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:_phoneField.text forKey:@"phoneNumber"];
    [parameters setObject:_opinionTextView.text forKey:@"content"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_APP_FEEDBACK_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            [self.view.window makeCustomToast:@"反馈已提交"];
            [self backHandle:nil];
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

#pragma mark ---text view delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placeHolderLabel.text = @"请输入详细信息";
    }else{
        _placeHolderLabel.text = nil;
    }
}
@end
