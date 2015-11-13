//
//  XQBHomeInformationListViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/31.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBHomeInformationListViewController.h"
#import "Global.h"
#import "XQBBaseTableView.h"
#import "XQBHomeInformationListCell.h"
#import "HomeInforListModel.h"
#import "XQBHomeInformationPublishViewController.h"
#import "UMSocial.h"
#import "XQBLginViewController.h"
#import "XQBMeSelectCityViewController.h"
#import "BlankPageView.h"
#import "XQBHomeInformationDetailWebViewController.h"
#import "AMTumblrHudRefreshTopView.h"
#import "AMTumblrHudRefreshBottomView.h"
#import "XQBLoginNavigationController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

static const CGFloat kHomeFeedsCellHeigth = 140.0f;

@interface XQBHomeInformationListViewController () <UITableViewDataSource,UITableViewDelegate, RefreshControlDelegate, UMSocialUIDelegate, PhotoDisplayViewDelegate>

@property (nonatomic, strong) XQBBaseTableView *tableView;
@property (nonatomic, strong) XQBLoginNavigationController *loginNavViewController;
@property (nonatomic, strong) RefreshControl *refreshControl;
@property (nonatomic, strong) BlankPageView *blankPageView;

@property (nonatomic, strong) NSMutableArray *inforListArray;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XQBHomeInformationListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.inforListArray = [[NSMutableArray alloc] init];
        
        _loginNavViewController = [[XQBLoginNavigationController alloc] init];
        [self.navigationController addChildViewController:_loginNavViewController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:_homeFeedName];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //发布按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:XQBColorGreen forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,70,44);
    [self setRightBarButtonItem:rightBtn];
    
    [self.view addSubview:self.tableView];
    
    ///初始化
    _refreshControl=[[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    _refreshControl.autoRefreshTop = YES;
    ///注册自定义的下拉刷新view
    [_refreshControl registerClassForTopView:[AMTumblrHudRefreshTopView class]];
    [_refreshControl registerClassForBottomView:[AMTumblrHudRefreshBottomView class]];
    ///设置显示下拉刷新
    _refreshControl.topEnabled = YES;
    _refreshControl.bottomEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.currentPage = 1;
    [self requestInformationList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UI
- (XQBBaseTableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[XQBBaseTableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (BlankPageView *)blankPageView{
    if (_blankPageView == nil) {
        //空白界面
        _blankPageView = [[BlankPageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        __weak typeof(self) weakself = self;
        _blankPageView.blankPageDidClickedBlock = ^(){
            [weakself requestInformationList];
        };
    }
    return _blankPageView;
}


#pragma mark --- action
- (void)backHandle:(UIButton *)sender
{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction:(UIButton *)sender
{
    if (![UserModel isLogin]) { //未登录弹出登录页面
       [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
        return;
    }
    
    XQBHomeInformationPublishViewController *publishVC = [[XQBHomeInformationPublishViewController alloc] init];
    publishVC.homeFeedType = _homeFeedType;
    publishVC.homeFeedName = _homeFeedName;
    [self.navigationController pushViewController:publishVC animated:YES];
}

- (void)shareButtonHandle:(UIButton *)sender
{
    HomeInforListModel *model = ([_inforListArray count]>sender.tag)?[_inforListArray objectAtIndex:sender.tag]:nil;

    UIImage *tmpImage;
    if ([model.images count] > 0) {
        tmpImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[model.images objectAtIndex:0]]]];
    } else {
        tmpImage = [UIImage imageNamed:@"xqb_app_icon.png"];
    }
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:[NSString stringWithFormat:@"%@  %@", model.title, model.descp]
                                     shareImage:tmpImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQzone,nil]
                                       delegate:self];
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"小区宝[%@]", model.feedCategory];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = model.detailUrl;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"小区宝[%@]", model.feedCategory];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = model.detailUrl;
    
    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@ @小区宝", model.descp, model.detailUrl];
    
    [UMSocialData defaultData].extConfig.qzoneData.title = [NSString stringWithFormat:@"小区宝[%@]", model.feedCategory];
    [UMSocialData defaultData].extConfig.qzoneData.url = model.detailUrl;
}

- (void)commentButtonHandle:(UIButton *)sender
{
    HomeInforListModel *model = ([_inforListArray count]>sender.tag)?[_inforListArray objectAtIndex:sender.tag]:nil;
    
    XQBHomeInformationDetailWebViewController *viewController = [[XQBHomeInformationDetailWebViewController alloc] init];
    viewController.model = model;

    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)likeButtonHandle:(UIButton *)sender
{
    if (![UserModel isLogin]) { //未登录弹出登录页面
        [_loginNavViewController showInView:self.navigationController.view withAnimation:YES];
        return;
    }
    
    [self requestNeighbourFavor:sender.tag];
}

#pragma mark --- AFNetworking
- (void)requestInformationList
{
    [_blankPageView removeFromSuperview];
    [XQBLoadingView showLoadingAddedToView:self.view withOffset:UIOffsetMake(0, -HEIGHT(self.view)/2+30)];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:_homeFeedType forKey:@"feedType"];
    [parameters setObject:_homeFeedMark forKey:@"mark"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currentPage] forKey:@"page"];
    
    [parameters addSignatureKey];
    
    [manager GET:API_FEED_NEIGHBOUR_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        [XQBLoadingView hideLoadingForView:self.view];
        if (_currentPage < 2) {
            [_inforListArray removeAllObjects];
        }
        
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            NSArray *array = [data objectForKey:@"neighbour"];
            for (NSDictionary *dic in array) {
                HomeInforListModel *model = [[HomeInforListModel alloc] init];
                
                model.infoId        = [[dic objectForKey:@"id"] stringValue];
                model.likeCount     = [[dic objectForKey:@"likeCount"] stringValue];
                model.isLiked       = [[dic objectForKey:@"isLiked"] stringValue];
                
                model.title         = DealWithJSONValue([dic objectForKey:@"title"]);
                model.descp         = DealWithJSONValue([dic objectForKey:@"descp"]);
                model.time          = DealWithJSONValue([dic objectForKey:@"time"]);
                model.icon          = DealWithJSONValue([dic objectForKey:@"icon"]);
                model.nickname      = DealWithJSONValue([dic objectForKey:@"nickname"]);
                model.communityName = DealWithJSONValue([dic objectForKey:@"communityName"]);
                model.detailUrl     = DealWithJSONValue([dic objectForKey:@"detailUrl"]);
                model.feedType     = DealWithJSONValue([dic objectForKey:@"feedType"]);
                
                model.images        =  [dic objectForKey:@"images"];
                model.feedCategory  =  self.homeFeedName;
                
                [self.inforListArray addObject:model];
            }
            
            if (_inforListArray.count > 0) {
                NSDictionary *neighbourPage = [data objectForKey:@"neighbourPage"];
                if (_currentPage <= [[neighbourPage objectForKey:@"totalPage"] integerValue]) {
                    _currentPage++;
                } else {
                    [self.view makeCustomToast:@"没有更多信息"];
                }
                [_tableView reloadData];
            } else {
                [self.view addSubview:self.blankPageView];
                [_blankPageView resetImage:[UIImage imageNamed:@"no_collection.png"]];
                [_blankPageView resetTitle:[NSString stringWithFormat:@"您当前没有%@信息", _homeFeedName] andDescribe:@""];
            }
            
        } else {
            //加载服务器异常界面
            [self.view addSubview:self.blankPageView];
            [_blankPageView resetImage:[UIImage imageNamed:@"server_error.png"]];
            [_blankPageView resetTitle:SERVER_ERROR andDescribe:SERVER_ERROR_DESCRIBE];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [XQBLoadingView hideLoadingForView:self.view];
        [self.view addSubview:self.blankPageView];
        [_blankPageView resetImage:[UIImage imageNamed:@"no_network.png"]];
        [_blankPageView resetTitle:NO_NETWORK andDescribe:NO_NETWORK_DESCRIBE];
    }];
}

- (void)requestNeighbourFavor:(NSInteger)index
{
    HomeInforListModel *model = ([_inforListArray count]>index)?[_inforListArray objectAtIndex:index]:nil;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:model.infoId forKey:@"feedId"];
    [parameters setObject:model.feedType forKey:@"feedType"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_FEED_FAVOR_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            NSString *feedId = [[responseObject objectForKey:@"data"] stringValue];
            
            for (HomeInforListModel *model in _inforListArray) {
                if ([model.infoId isEqualToString:feedId]) {
                    if ([model.isLiked boolValue]) {
                        //                        model.isLiked = @"0";
                        //                        model.likeCount = [NSString stringWithFormat:@"%ld", [model.likeCount integerValue] - 1 ];
                    } else {
                        model.isLiked = @"1";
                        model.likeCount = [NSString stringWithFormat:@"%ld", [model.likeCount integerValue] + 1 ];
                    }
                }
            }
            [_tableView reloadData];
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

#pragma mark --- RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (direction==RefreshDirectionTop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl finishRefreshingDirection:RefreshDirectionTop];
        });
        self.currentPage = 1;
        [self requestInformationList];
        [XQBLoadingView hideLoadingForView:self.view];
    } else if (direction == RefreshDirectionBottom) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        });
        [self requestInformationList];
        [XQBLoadingView hideLoadingForView:self.view];
    }
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //去掉UItableview的section的headerview黏性
    CGFloat sectionHeaderHeight = XQBSpaceVerticalElement;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark --- tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _inforListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeInforListModel *model = ([_inforListArray count]>indexPath.section)?[_inforListArray objectAtIndex:indexPath.section]:nil;
    
    static NSString *identify = @"identify";
    XQBHomeInformationListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[XQBHomeInformationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
#ifdef __IPHONE_8_0
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
#endif
    }
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageWithColor:XQBColorDefaultImage size:cell.iconView.frame.size]];
    [cell.titleLabel setText:model.nickname];
    [cell.timeLabel setText:[NSString stringWithFormat:@"%@    来自%@", model.time, model.communityName]];
    [cell.contentLabel setText:[NSString stringWithFormat:@"%@    %@", model.title, model.descp]];
    CGSize size=[model.descp boundingRectWithSize:CGSizeMake(MainWidth-XQBMarginHorizontal*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XQBFontContent} context:nil].size;
    if (size.height < XQBHeightLabelContent) {
        size.height = XQBHeightLabelContent;
    }
    cell.contentLabel.frame = CGRectMake(XQBMarginHorizontal, 15+cell.iconView.frame.size.height+15, MainWidth-XQBMarginHorizontal*2, size.height);
    
    if (model.images.count > 0) {
        cell.photosView.hidden = NO;
        for (UIView *subView in cell.photosView.subviews) {
            [subView removeFromSuperview];
        }
        [cell.photosView setPhotoUrls:model.images];
        [cell.photosView setFrame:CGRectMake(XQBMarginHorizontal, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+10, cell.photosView.frame.size.width, cell.photosView.frame.size.height)];
        cell.shareCommentLike.frame = CGRectMake(0, cell.photosView.frame.origin.y+cell.photosView.frame.size.height+10, cell.shareCommentLike.frame.size.width, cell.shareCommentLike.frame.size.height);
        cell.photosView.delegate = self;
    } else {
        cell.photosView.hidden = YES;
        for (UIView *subView in cell.photosView.subviews) {
            [subView removeFromSuperview];
        }
        cell.shareCommentLike.frame = CGRectMake(0, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+10, cell.shareCommentLike.frame.size.width, cell.shareCommentLike.frame.size.height);
    }
    [cell.shareCommentLike setIsLiked:[model.isLiked boolValue]];
    [cell.shareCommentLike setLikeCout:[model.likeCount integerValue]];
    [cell.shareCommentLike.shareButton setTag:indexPath.section];
    [cell.shareCommentLike.commentButton setTag:indexPath.section];
    [cell.shareCommentLike.likeButton setTag:indexPath.section];
    [cell.shareCommentLike.shareButton addTarget:self action:@selector(shareButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareCommentLike.commentButton addTarget:self action:@selector(commentButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    if (![model.isLiked boolValue]) {
        [cell.shareCommentLike.likeButton addTarget:self action:@selector(likeButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [cell.shareCommentLike.likeButton removeTarget:self action:@selector(likeButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

#pragma mark --- tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeInforListModel *model = ([_inforListArray count]>indexPath.section)?[_inforListArray objectAtIndex:indexPath.section]:nil;
    
    CGSize size=[model.descp boundingRectWithSize:CGSizeMake(MainWidth-XQBMarginHorizontal*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XQBFontContent} context:nil].size;
    
    CGFloat tmpHeight = 0;
    
    if (model.images.count > 0) {
        tmpHeight = MAX(kHomeFeedsCellHeigth+70.0f, kHomeFeedsCellHeigth+size.height-XQBHeightLabelContent+70.0f); //kHomeFeedsCellHeigth是整个cell没有图片的高度，80是图片+间隔的高度
    } else {
        tmpHeight = MAX(kHomeFeedsCellHeigth, kHomeFeedsCellHeigth+size.height-XQBHeightLabelContent);
    }
    
    return tmpHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    HomeInforListModel *model = ([_inforListArray count]>indexPath.section)?[_inforListArray objectAtIndex:indexPath.section]:nil;
    
    XQBHomeInformationDetailWebViewController *viewController = [[XQBHomeInformationDetailWebViewController alloc] init];
    viewController.model = model;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return XQBSpaceVerticalElement;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBSpaceVerticalElement)];
    backgroundView.backgroundColor = XQBColorBackground;
    
    return backgroundView;
}

#pragma mark --- PhotoDisplayViewDelegate
- (void)photoDisplayView:(PhotoDisplayView *)photoView tappedAtIndex:(NSInteger)index
{
    
    if ([photoView.photoUrls count] == 0) {
        return;
    }else{
        
        //小区图片
        NSArray *imgArr = photoView.photoUrls;
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imgArr.count];
        for (int i = 0; i<imgArr.count; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            NSString *strUrl = [imgArr objectAtIndex:i];
            photo.url = [NSURL URLWithString:strUrl]; // 图片路径
            photo.srcImageView = photoView.subviews[i]; // 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
}

#pragma mark --- UMSocialUIDelegate
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
@end
