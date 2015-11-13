//
//  XQBHomeAdWebViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/13.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBHomeAdWebViewController.h"
#import "Global.h"
#import "BlankPageView.h"

@interface XQBHomeAdWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) BlankPageView *blankPageView;

@end

@implementation XQBHomeAdWebViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:self.adModel.title];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.adModel.link]];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
}

//空白界面
- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        __weak typeof(self) weakSelf = self;
        _blankPageView.blankPageDidClickedBlock = ^(){
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.adModel.link]];
            [weakSelf.webView loadRequest:request];
        };
    }
    return _blankPageView;
}

#pragma mark --- Action
- (void)backHandle:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
