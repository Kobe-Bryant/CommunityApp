//
//  CommentInputViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 15/1/15.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "CommentInputViewController.h"
#import "Global.h"

@interface CommentInputViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UILabel *wordLimitedLabel;

@end

@implementation CommentInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = XQBColorBackground;
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"发评论"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //提交按钮
    //右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn setTitleColor:XQBColorGreen forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,70,44);
    [self setRightBarButtonItem:rightBtn];
    
    [self.view addSubview:self.textView];
    
    [self.view addSubview:self.wordLimitedLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---textView
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 15, 320, 77+30)];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.returnKeyType = UIReturnKeyDone;
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 6, 120, 20)];
        if (_textView.text.length > 0) {
            _placeHolderLabel.text = nil;
        }else{
            _placeHolderLabel.text = @"写评论...";
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
        [_wordLimitedLabel setText:@"200字"];
        [_wordLimitedLabel setFont:[UIFont systemFontOfSize:10]];
    }
    return _wordLimitedLabel;
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendComment:(UIButton *)sender{
    if (0 == _textView.text.length) {
        [self.view.window makeCustomToast:@"评论不能为空"];
    } else if (201 < _textView.text.length) {
        [self.view.window makeCustomToast:@"评论不能超过200个字"];
    } else {
        [self requestSendComment];
    }
}

#pragma mark --- AFNetworking
- (void)requestSendComment
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:_feedId forKey:@"feedId"];
    [parameters setObject:_feedType forKey:@"feedType"];
    [parameters setObject:_textView.text forKey:@"content"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_HOME_FEED_COMMENT_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            [self.view.window makeCustomToast:@"评论发送成功"];
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

#pragma mark --- text view delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placeHolderLabel.text = @"写评论...";
    }else{
        _placeHolderLabel.text = nil;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //限制字符在200个以内
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([aString length] > 200) {
        if (range.length>0) {
            return YES;
        }
        [self.view.window makeCustomToast:@"评论不能超过200个字"];
        return NO;
    } else if ([aString length] == 0) {
        _wordLimitedLabel.text = [NSString stringWithFormat:@"200字"];
    }else {
        _wordLimitedLabel.text = [NSString stringWithFormat:@"%ld字", 200-[aString length]];
    }
    return YES;
}


@end
