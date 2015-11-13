//
//  XQBMeViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeViewController.h"
#import "XQBPathHeaderTopView.h"
#import "XQBPathHeaderContentView.h"
#import "XQBPathHeaderBottomView.h"
#import "Global.h"
#import "XQBLginViewController.h"
#import "XQBMeHeaderMenuView.h"
#import "XQBMeEdittingViewController.h"
#import "XQBUserSettingViewController.h"
#import "XQBMeInviteViewController.h"
#import "XQBMeMyBillViewController.h"
#import "OpinionFeedbackViewController.h"
#import "AboutXQBViewController.h"
#import "XQBMeMyNoticeViewController.h"
#import "XQBMeMyOrderViewController.h"
#import "XQBECShippingAddressViewController.h"
#import "XQBHomeInformationListViewController.h"
#import "XQBMeSelectCityViewController.h"
#import "XQBLoginNavigationController.h"

#define ME_HEADER_HEIGHT        320

@interface XQBMeViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) XQBPathHeaderTopView *headerTopView;
@property (nonatomic, strong) XQBPathHeaderContentView *headerContentView;
@property (nonatomic, strong) XQBPathHeaderBottomView *headerBottomView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *guestMenuView;
@property (nonatomic, strong) XQBLoginNavigationController *loginNavViewController;
@property (nonatomic, strong) UIView *meTableHeaderView;
@property (nonatomic, strong) XQBMeHeaderMenuView *headerMenuView;

@end

@implementation XQBMeViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = @"我";
        [self.navigationController setNavigationBarHidden:YES];
        _loginNavViewController = [[XQBLoginNavigationController alloc] init];
        [self.navigationController addChildViewController:_loginNavViewController];
        [_loginNavViewController setHiddenDismissButton:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucceedNotice:) name:kXQBLoginSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutSucceedNotice:) name:kXQBLogoutSucceedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeUserCommunityInfoNotice:) name:kXQBCompleteUserInfoNotice object:nil];
    
    self.view.backgroundColor = XQBColorBackground;
    [self.view addSubview:self.headerBottomView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, WIDTH(self.view), HEIGHT(self.view)-STATUS_BAR_HEIGHT-TABBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.meTableHeaderView;
    _tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_tableView];
    
    [self.view addSubview:self.headerContentView];
    [self.view addSubview:self.headerTopView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (![UserModel isLogin]) {
        [_loginNavViewController showInView:self.navigationController.view withAnimation:NO];
    }else{
        [self refreshUserInfo];
        [_loginNavViewController dismissWithAnimation:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- net work
- (void)requestUpdateUserIcon:(UIImage *)image{
    if (!image) {
        XQBLog(@"图片不能为空");
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    [manager POST:API_USER_UPLOAD_ICON_URL parameters:parameters
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            /*
            NSData *imageData = [NSData alloc] initWithContentsOfFile:<#(NSString *)#>;
            XQBLog(@"imageData --> %ld",[imageData length]);
            */
            UIImage *fileImage = [UIImage imageWithContentsOfFile:image.filePath];
            NSData * data= UIImagePNGRepresentation(fileImage);
            [formData appendPartWithFileData:data name:@"icon" fileName:image.fileName mimeType:@"image/png"];
                }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              XQBLog(@"\nresponseObject:%@", responseObject);
              if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
                  UserModel *userModel = [UserModel shareUser];
                  userModel.userIcon = [responseObject objectForKey:@"data"];
                  
                  [self refreshUserInfo];
              } else {
                  //加载服务器异常界面
                  XQBLog(@"服务器异常");
                  [self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
              }

          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //加载网络异常界面
              XQBLog(@"网络异常Error:%@", error);
              [self.view.window makeCustomToast:TOAST_NO_NETWORK];
          }];
}

#pragma mark --- ui
- (XQBPathHeaderTopView *)headerTopView{

    if (!_headerTopView) {
        _headerTopView = [[XQBPathHeaderTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), STATUS_NAV_BAR_HEIGHT)];
        _headerTopView.titleLabel.text = @"我";
        _headerTopView.hidden = YES;
    }
    return _headerTopView;
}

- (XQBPathHeaderContentView *)headerContentView{
    if (!_headerContentView) {
        _headerContentView = [[XQBPathHeaderContentView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), ME_HEADER_HEIGHT)];
        [_headerContentView.editingButton addTarget:self action:@selector(editingButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_headerContentView.settingButton addTarget:self action:@selector(settingButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _headerContentView;
}

- (XQBPathHeaderBottomView *)headerBottomView{
    if (!_headerBottomView) {
        _headerBottomView = [[XQBPathHeaderBottomView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), ME_HEADER_HEIGHT)];
    }
    return _headerBottomView;
}

- (XQBMeHeaderMenuView *)headerMenuView{
    if (!_headerMenuView) {
        _headerMenuView = [[XQBMeHeaderMenuView alloc] initWithFrame:CGRectMake(0, 300, WIDTH(self.view), 94)];
        [_headerMenuView.myNoticeButton addTarget:self action:@selector(myNoticeButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_headerMenuView.myOrderButton addTarget:self action:@selector(myOrderButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_headerMenuView.inviteJoinButton addTarget:self action:@selector(inviteJoinButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_headerMenuView.myBillButton addTarget:self action:@selector(myBillButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerMenuView;
}

- (UIView *)meTableHeaderView{
    if (!_meTableHeaderView) {
        _meTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), ME_HEADER_HEIGHT+80+14-STATUS_BAR_HEIGHT)];
        [_meTableHeaderView addSubview:self.headerMenuView];
        
    }
    return _meTableHeaderView;
}

- (void)refreshUserInfo{
    UserModel *userModel = [UserModel shareUser];
     self.headerContentView.userInfoLabel.text = [UserModel shareUser].nickName;
    [self.headerContentView.userIconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[UserModel shareUser].userIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_avatar.png"]];
    [self.headerContentView.userIconButton addTarget:self action:@selector(pickUserIconHandle:) forControlEvents:UIControlEventTouchUpInside];
    //设置物业用户信息
    //NSString *title = @"";

//    if ([userModel.userType isEqualToString:XQB_USER_IDENTIFY_GUEST]) {
//        [self.headerContentView.userCommunityInfoButton setTitle:nil forState:UIControlStateNormal];
//    }else if ([userModel.userType isEqualToString:XQB_USER_IDENTIFY_GENERAL]){
//        [self.headerContentView.userCommunityInfoButton setTitle:@"请完善您的物业信息" forState:UIControlStateNormal];
//    }else if ([userModel.userType isEqualToString:XQB_USER_IDENTIFY_RESIDENT]){
//        //NSString *userCommunityInfoStr = [userModel.communityName stringByAppendingString:userModel.residentDesc];
//        [self.headerContentView.userCommunityInfoButton setTitle:userModel.residentDesc forState:UIControlStateNormal];
//    }
    for (UIGestureRecognizer *gesture in self.headerContentView.userCommunityInfoLabel.gestureRecognizers) {
        [self.headerContentView.userCommunityInfoLabel removeGestureRecognizer:gesture];
    }
    if ([userModel.userType isEqualToString:XQB_USER_IDENTIFY_GUEST]) {
        self.headerContentView.userCommunityInfoLabel.userInteractionEnabled = NO;
        self.headerContentView.userCommunityInfoLabel.text = nil;
    }else if ([userModel.userType isEqualToString:XQB_USER_IDENTIFY_GENERAL]){
        self.headerContentView.userCommunityInfoLabel.userInteractionEnabled = YES;
        self.headerContentView.userCommunityInfoLabel.text = @"请完善您的物业信息";
        UITapGestureRecognizer *tapGesutre = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeUserCommunityInfo:)];
        [self.headerContentView.userCommunityInfoLabel addGestureRecognizer:tapGesutre];
        //[self.headerContentView.userCommunityInfoButton setTitle:@"请完善您的物业信息" forState:UIControlStateNormal];
    }else if ([userModel.userType isEqualToString:XQB_USER_IDENTIFY_RESIDENT]){
        self.headerContentView.userCommunityInfoLabel.text = userModel.residentDesc;
    }
}

#pragma mark ---ui scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _tableView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY>=0) {
            if (fabs(-offsetY)<=1) {
                self.headerBottomView.imageView.transform = CGAffineTransformIdentity;
                self.headerContentView.transform = CGAffineTransformIdentity;
                self.headerContentView.userIconButton.alpha = 1;
                self.headerContentView.userInfoLabel.alpha = 1;
                self.headerContentView.userCommunityInfoLabel.alpha = 1;
                self.headerContentView.editingButton.alpha = 1;
                self.headerContentView.settingButton.alpha = 1;
            }else{
                self.headerBottomView.imageView.transform = CGAffineTransformMakeTranslation(0, -offsetY/2);
                self.headerContentView.transform = CGAffineTransformMakeTranslation(0,-offsetY);
                self.headerContentView.userIconButton.alpha = [self calculateAlphaWith:TOP(self.headerContentView.userIconButton)-STATUS_BAR_HEIGHT offset:offsetY];
                self.headerContentView.userInfoLabel.alpha = [self calculateAlphaWith:TOP(self.headerContentView.userInfoLabel)-STATUS_BAR_HEIGHT offset:offsetY];
                self.headerContentView.userCommunityInfoLabel.alpha = [self calculateAlphaWith:TOP(self.headerContentView.userCommunityInfoLabel)-STATUS_BAR_HEIGHT offset:offsetY];
                self.headerContentView.editingButton.alpha = [self calculateAlphaWith:TOP(self.headerContentView.editingButton)-STATUS_BAR_HEIGHT offset:offsetY]/0.5;
                self.headerContentView.settingButton.alpha = [self calculateAlphaWith:TOP(self.headerContentView.settingButton)-STATUS_BAR_HEIGHT offset:offsetY]/0.5;
                
            }
            if (ME_HEADER_HEIGHT - offsetY <= STATUS_NAV_BAR_HEIGHT) {
                self.headerTopView.hidden = NO;
                CGFloat alpha = (1 - [self calculateAlphaWith:TOP(self.headerContentView.settingButton) offset:offsetY]);
                NSLog(@"alpha-->%f",alpha);
                self.headerTopView.titleLabel.textColor = [UIColor colorWithWhite:alpha alpha:alpha];
            }else{
                self.headerTopView.hidden = YES;
            }
        }else{
            self.headerBottomView.imageView.transform = CGAffineTransformIdentity;
            self.headerContentView.transform = CGAffineTransformIdentity;
        }
    }
}

- (CGFloat)calculateAlphaWith:(CGFloat)targetSpace offset:(CGFloat)offset{
    if (targetSpace-offset > 0) {
        return (targetSpace-offset)/targetSpace;
    }else{
        return .0f;
    }
    
    return 1.0;
}

#pragma mark ---tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 4;
    }else if (section == 1){
        return 3;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.imageView.image = [self configCellImageWith:indexPath];
    cell.textLabel.text = [self configCellTextWith:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        
        switch (indexPath.row) {
            case 0:{
                XQBECShippingAddressViewController *addressAddVC = [[XQBECShippingAddressViewController alloc] init];
                addressAddVC.navigationBarHidden = YES;
                addressAddVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addressAddVC animated:YES];
            }
                
                break;
            case 1:{
                XQBHomeInformationListViewController *infoListVC = [[XQBHomeInformationListViewController alloc] init];
                infoListVC.homeFeedMark = XQB_FEED_MARK_OWN;
                infoListVC.homeFeedType = XQB_FEED_TYPE_CARPOOL;
                infoListVC.homeFeedName = XQB_FEED_NAME_CARPOOL;
                infoListVC.navigationBarHidden = YES;
                infoListVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:infoListVC animated:YES];
            }
                break;
            case 2:     //跳蚤市场
            {
                XQBHomeInformationListViewController *infoListVC = [[XQBHomeInformationListViewController alloc] init];
                infoListVC.homeFeedMark = XQB_FEED_MARK_OWN;
                infoListVC.homeFeedType = XQB_FEED_TYPE_FLEA_MARKET;
                infoListVC.homeFeedName = XQB_FEED_NAME_FLEA_MARKET;
                infoListVC.navigationBarHidden = YES;
                infoListVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:infoListVC animated:YES];
            }
                break;
            case 3:
            {
                XQBHomeInformationListViewController *infoListVC = [[XQBHomeInformationListViewController alloc] init];
                infoListVC.homeFeedMark = XQB_FEED_MARK_OWN;
                infoListVC.homeFeedType = XQB_FEED_TYPE_NEIGHBORS_HOME;
                infoListVC.homeFeedName = XQB_FEED_NAME_NEIGHBORS_HOME;
                infoListVC.navigationBarHidden = YES;
                infoListVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:infoListVC animated:YES];
            }
                break;

            default:
                break;
        }
    
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                OpinionFeedbackViewController *opinionFeedbackVC = [[OpinionFeedbackViewController alloc] init];
                opinionFeedbackVC.navigationBarHidden = YES;
                opinionFeedbackVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:opinionFeedbackVC animated:YES];
            }
                break;
            case 1:
            {
                AboutXQBViewController *aboutXQBVC = [[AboutXQBViewController alloc] init];
                aboutXQBVC.navigationBarHidden = YES;
                aboutXQBVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutXQBVC animated:YES];
            }
                break;
            case 2:
                [self opeiTunesStoreURL];
                
                break;
            default:
                break;
        }
    }


}

- (NSString *)configCellTextWith:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                return @"收货地址";
                break;
            case 1:
                return @"我的拼车";
                break;
            case 2:
                return @"我的跳蚤";
                break;
            case 3:
                return @"我的邻居圈";
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:
                return @"意见反馈";
                break;
            case 1:
                return @"关于小区宝";
                break;
            case 2:
                return @"亲~给个好评";
                break;
            default:
                break;
        }
    }

    
    return nil;
}

- (UIImage *)configCellImageWith:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                return [UIImage imageNamed:@"me_recieve_address_button.png"];
                break;
            case 1:
                return [UIImage imageNamed:@"me_carsharing_button.png"];
                break;
            case 2:
                return [UIImage imageNamed:@"me_fleamarket_button.png"];
                break;
            case 3:
                return [UIImage imageNamed:@"me_neighbour_button.png"];
                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 1){
        switch (indexPath.row) {

            case 0:
                return [UIImage imageNamed:@"me_feedback_button.png"];
                break;
            case 1:
                return [UIImage imageNamed:@"me_about_xqb_button.png"];
                break;
            case 2:
                return [UIImage imageNamed:@"me_good_comment_icon.png"];
                break;
            default:
                break;
        }
    }

    
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark --- action
- (void)editingButtonHandle:(UIButton *)sender
{
    XQBMeEdittingViewController *edittingVC = [[XQBMeEdittingViewController alloc] init];
    edittingVC.navigationBarHidden = YES;
    edittingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:edittingVC animated:YES];
}

- (void)settingButtonHandle:(UIButton *)sender
{
    XQBUserSettingViewController *userSettingVC = [[XQBUserSettingViewController alloc] init];
    userSettingVC.navigationBarHidden = YES;
    userSettingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userSettingVC animated:YES];
}

- (void)myNoticeButtonHandle:(UIButton *)sender
{
    if ([[UserModel shareUser].userType isEqualToString:XQB_USER_IDENTIFY_RESIDENT]) {
        XQBMeMyNoticeViewController *myNoticeVC = [[XQBMeMyNoticeViewController alloc] init];
        myNoticeVC.navigationBarHidden = YES;
        myNoticeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myNoticeVC animated:YES];
    } else {
        XQBMeSelectCityViewController *viewController = [[XQBMeSelectCityViewController alloc] init];
        viewController.navigationBarHidden = YES;
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.hiddenNavigationBarWhenPoped = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)myOrderButtonHandle:(UIButton *)sender{
    XQBMeMyOrderViewController *myOrderVC = [[XQBMeMyOrderViewController alloc] init];
    myOrderVC.navigationBarHidden = YES;
    myOrderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myOrderVC animated:YES];
}

- (void)inviteJoinButtonHandle:(UIButton *)sender
{
    XQBMeInviteViewController *inviteVC = [[XQBMeInviteViewController alloc] init];
    inviteVC.navigationBarHidden = YES;
    inviteVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inviteVC animated:YES];
}

- (void)myBillButtonHandle:(UIButton *)sender
{
    if ([[UserModel shareUser].userType isEqualToString:XQB_USER_IDENTIFY_RESIDENT]) {
        XQBMeMyBillViewController *myBillVC = [[XQBMeMyBillViewController alloc] init];
        myBillVC.navigationBarHidden = YES;
        myBillVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myBillVC animated:YES];
    } else {
        XQBMeSelectCityViewController *viewController = [[XQBMeSelectCityViewController alloc] init];
        viewController.navigationBarHidden = YES;
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.hiddenNavigationBarWhenPoped = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


- (void)opeiTunesStoreURL{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
}

#pragma mark

//从相册获取头像
-(void)pickUserIconHandle:(UIButton *)sender
{
    UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [mySheet showInView:[UIApplication sharedApplication].keyWindow];
}
//选择照相，或者照片库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
        BOOL iscamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (!iscamera) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
            return;
        }
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        pick.delegate = self;
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.allowsEditing = YES;
        [self presentViewController:pick animated:YES completion:NULL];

    }
    if (buttonIndex == 1) {
        UIImagePickerController *pick  =[[UIImagePickerController alloc] init];
        pick.allowsEditing = YES;
        //设置委托
        pick.delegate=self;
        pick.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pick animated:YES completion:NULL];
    }
}

#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSString *str = (NSString*)kCGImagePropertyTIFFDictionary;
        NSDictionary *dic = [[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:str];
        image.fileName = [[dic objectForKey:@"DateTime"] stringByAppendingPathExtension:@"jpg"];
        
        UIImage *newImage = [UIImage writeImageToSandBox:image name:image.fileName];
        image = nil;
        //上传头像 请求
        [self requestUpdateUserIcon:newImage];

    }else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        //NSString *str = (NSString*)kCGImagePropertyTIFFDictionary;
        //NSDictionary *dic = [[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:str];
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *asset)
        {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            NSString *fileName = [representation filename];
            NSLog(@"fileName : %@",fileName);
            
            image.fileName = fileName;//[[dic objectForKey:@"DateTime"] stringByAppendingPathExtension:@"jpg"];
            UIImage *newImage = [UIImage writeImageToSandBox:image name:image.fileName];
            //上传头像 请求
            [self requestUpdateUserIcon:newImage];
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        
    }

}

#pragma mark ---
- (void)userLoginSucceedNotice:(NSNotification *)notice
{
    [self refreshUserInfo];
}

- (void)userLogoutSucceedNotice:(NSNotification *)notice
{
    [self refreshUserInfo];
}

- (void)completeUserCommunityInfo:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        //do something
        [self completeUserInfo];
    }
}

- (void)completeUserCommunityInfoNotice:(NSNotification *)notice{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self completeUserInfo];
    });
    
}

- (void)completeUserInfo{
    XQBMeSelectCityViewController *viewController = [[XQBMeSelectCityViewController alloc] init];
    viewController.navigationBarHidden = YES;
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.hiddenNavigationBarWhenPoped = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
