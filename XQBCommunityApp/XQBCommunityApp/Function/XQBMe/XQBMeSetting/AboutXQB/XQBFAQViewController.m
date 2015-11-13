//
//  XQBFAQViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/2/6.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBFAQViewController.h"
#import "Global.h"
#import "BlankPageView.h"

@interface XQBFAQViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *faqUrl;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) BlankPageView *blankPageView;

@end

@implementation XQBFAQViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
        self.faqUrl = [HTTPURLPREFIX stringByAppendingString:API_HOME_FAQ_URL];
    }
    return self;
}

- (void)dealloc{
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"关于小区宝"];
    
    
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

    CGRect rect = CGRectMake(0, 0, MainWidth, MainHeight);
    _webView = [[UIWebView alloc] initWithFrame:rect];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.faqUrl]];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
    
}

#pragma mark --- life style

//空白界面
- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        __weak typeof(self) weakSelf = self;
        _blankPageView.blankPageDidClickedBlock = ^(){
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.faqUrl]];
            [weakSelf.webView loadRequest:request];
        };
    }
    return _blankPageView;
}

#pragma mark --- uiwebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_blankPageView removeFromSuperview];
    [XQBLoadingView showLoadingAddedToView:_webView withOffset:UIOffsetMake(0, -HEIGHT(_webView)/2+30)];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [XQBLoadingView hideLoadingForView:_webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [XQBLoadingView hideLoadingForView:_webView];
    [self.view addSubview:self.blankPageView];
    [_blankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
    [_blankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
}

#pragma mark --- action
- (void)backHandle:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
