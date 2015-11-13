//
//  XQBMeEditingSummaryViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/10.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBMeEditingSummaryViewController.h"
#import "Global.h"

@interface XQBMeEditingSummaryViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *wordLimitedLabel;

@end

@implementation XQBMeEditingSummaryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"编辑简介"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //提交按钮
    //右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:XQBColorGreen forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(submitUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,70,44);
    [self setRightBarButtonItem:rightBtn];
    
    [self.view addSubview:self.textView];
    
    [self.view addSubview:self.wordLimitedLabel];
}


#pragma mark ---textView
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 15, 320, 77+30)];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.text = _muCopyUserModel.signature;
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 6, 120, 20)];
        if (_textView.text.length > 0) {
            _placeHolderLabel.text = nil;
        }else{
            _placeHolderLabel.text = @"介绍一下自己";
        }
        _placeHolderLabel.font = [UIFont systemFontOfSize:15];
        _placeHolderLabel.enabled = NO;//lable必须设置为不可用
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        [_textView addSubview:_placeHolderLabel];
        
    }

    return _textView;
}

- (UILabel *)wordLimitedLabel{
    if (!_wordLimitedLabel) {
        _wordLimitedLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 92+30, 60, 18)];
        [_wordLimitedLabel setText:[NSString stringWithFormat:@"%lu字", 70-_textView.text.length]];
        [_wordLimitedLabel setFont:[UIFont systemFontOfSize:10]];
    }
    return _wordLimitedLabel;
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitUserInfo:(UIButton *)sender{
    [_textView resignFirstResponder];
    _muCopyUserModel.signature = self.textView.text;
    [self requestEditUserProfile];
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
    if (50 < userModel.microblog.length) {
        [self.view.window makeCustomToast:@"邮箱不能超出50个字"];
        return;
    }
    NSString *strEmail = (userModel.email.length > 0)?userModel.email:@"";
    [parameters setObject:strEmail forKey:@"email"];
    //microblog
    if (50 < userModel.microblog.length) {
        [self.view.window makeCustomToast:@"微博不能超出50个字"];
        return;
    }
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
            
            [self.navigationController popViewControllerAnimated:YES];
            
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //限制字符在70个以内
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([aString length] > 70) {
        if (range.length>0) {
            return YES;
        }
        [self.view.window makeCustomToast:@"不能超过70个字"];
        return NO;
    } else if ([aString length] == 0) {
        _wordLimitedLabel.text = [NSString stringWithFormat:@"70字"];
    }else {
        _wordLimitedLabel.text = [NSString stringWithFormat:@"%ld字", 70-[aString length]];
    }
    return YES;
}


@end
