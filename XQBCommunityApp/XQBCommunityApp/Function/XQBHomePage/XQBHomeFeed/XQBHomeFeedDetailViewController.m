//
//  XQBHomeFeedDetailViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/13.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBHomeFeedDetailViewController.h"
#import "Global.h"
#import "ShareCommentLike.h"
#import "CommentInputViewController.h"
#import "XQBLoginNavigationController.h"
#import "UMSocial.h"
#import "BlankPageView.h"

@interface XQBHomeFeedDetailViewController () <UIWebViewDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) BlankPageView *blankPageView;
@property (nonatomic, strong) ShareCommentLike *shareCommentLike;

@property (nonatomic, strong) XQBLoginNavigationController *loginNavViewController;

@end

@implementation XQBHomeFeedDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _loginNavViewController = [[XQBLoginNavigationController alloc] init];
        [self.navigationController addChildViewController:_loginNavViewController];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:self.feedDetailModel.feedCategory];
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight-XQBHeightElement)];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    _shareCommentLike = [[ShareCommentLike alloc] initWithFrame:CGRectMake(0, HEIGHT(self.view)-STATUS_NAV_BAR_HEIGHT-XQBHeightElement, MainWidth, XQBHeightElement)];
        [_shareCommentLike setIsLiked:[_feedDetailModel.isLiked boolValue]];
        [_shareCommentLike setLikeCout:[_feedDetailModel.likeCount integerValue]];
    [_shareCommentLike.shareButton addTarget:self action:@selector(shareButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    [_shareCommentLike.commentButton addTarget:self action:@selector(commentButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    if (![_feedDetailModel.isLiked boolValue]) {
        [_shareCommentLike.likeButton addTarget:self action:@selector(likeButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_shareCommentLike.likeButton removeTarget:self action:@selector(likeButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:_shareCommentLike];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.feedDetailModel.detailUrl]];
    [_webView loadRequest:request];
}

//空白界面
- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        __weak typeof(self) weakSelf = self;
        _blankPageView.blankPageDidClickedBlock = ^(){
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.feedDetailModel.detailUrl]];
            [weakSelf.webView loadRequest:request];
        };
    }
    return _blankPageView;
}

#pragma mark --- Action
- (void)backHandle:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonHandle:(UIButton *)sender
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:_feedDetailModel.title
                                     shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_feedDetailModel.feedIcon]]]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQzone,nil]
                                       delegate:self];
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"小区宝[%@]", _feedDetailModel.feedCategory];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = _feedDetailModel.detailUrl;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"小区宝[%@]", _feedDetailModel.feedCategory];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _feedDetailModel.detailUrl;
    
    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@ @小区宝", _feedDetailModel.title, _feedDetailModel.detailUrl];
    
    [UMSocialData defaultData].extConfig.qzoneData.title = [NSString stringWithFormat:@"小区宝[%@]", _feedDetailModel.feedCategory];
    [UMSocialData defaultData].extConfig.qzoneData.url = _feedDetailModel.detailUrl;
}

- (void)commentButtonHandle:(UIButton *)sender
{
    if (![UserModel isLogin]) { //未登录弹出登录页面
        [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
        return;
    }
    CommentInputViewController *viewController = [[CommentInputViewController alloc] init];
    viewController.feedId = _feedDetailModel.feedId;
    viewController.feedType = _feedDetailModel.feedType;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)likeButtonHandle:(UIButton *)sender
{
    if (![UserModel isLogin]) { //未登录弹出登录页面
        [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
        return;
    }
    if (![_feedDetailModel.isLiked boolValue]) {
        [self requestHomeFavor];
    }
}

- (void)requestHomeFavor
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:_feedDetailModel.feedId forKey:@"feedId"];
    [parameters setObject:_feedDetailModel.feedType forKey:@"feedType"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_FEED_FAVOR_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            if (![_feedDetailModel.isLiked boolValue]) {
                _feedDetailModel.isLiked = @"1";
                [_shareCommentLike setIsLiked:[_feedDetailModel.isLiked boolValue]];
            }
        } else {
            //加载服务器异常界面
            [self.view.window makeCustomToast:@"服务器出错，点赞失败"];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [self.view.window makeCustomToast:TOAST_NO_NETWORK];
    }];
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
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
