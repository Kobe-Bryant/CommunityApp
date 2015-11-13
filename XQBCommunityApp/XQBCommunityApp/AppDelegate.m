//
//  AppDelegate.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/17.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"
#import "XQBCoreLBS.h"
#import "MobClick.h"
#import "XQBVendorMarcros.h"
#import "UserModel.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "XQBDataLocation.h"
#import "APIKey.h"
#import <MAMapKit/MAMapKit.h>
#import "BPush.h"
#import "JSONKit.h"
#import "XQBUserManager.h"
#import "XQBPush.h"
#import "XQBVersionManager.h"
#import "XQBPayManager.h"

@interface AppDelegate ()

@property (nonatomic, retain) NSString *channelId;
@property (nonatomic, retain) NSString *subscriberId;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [application setApplicationIconBadgeNumber:0];
    
    [self registerPushNotification:launchOptions];
    
    //获取用户缓存信息
    [UserModel shareUser];
    [[XQBUserManager shareInstance] XQBLogin];
    
    //开启高德服务
    [self configureAPIKey];
    
    //开启定位服务
    [XQBCoreLBS shareInstance];
    
    //开启友盟统计
    [self initaliseUmengAnalytics];
    
    //开启友盟分享
    [self initaliseUmengShare];
    
    //检查是否最新版本
    [[XQBVersionManager shareInstance] checkVersionUpdate];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //获取省市列表
        [XQBDataLocation shareInstance];
        [XQBPush shareInstance];

    });
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ---viewController
- (XQBTabBarController *)tabBarController{
    
    if (!_tabBarController) {
        //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        //由storyboard根据myView的storyBoardID来获取我们要切换的视图
        _tabBarController = [story instantiateViewControllerWithIdentifier:@"XQBTabBarController"];
    }
    return _tabBarController;

}

#pragma mark ----
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //如果极简SDK不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
           
            [[NSNotificationCenter defaultCenter] postNotificationName:kXQBAlipayResultSucceedNotice object:resultDic];
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark ---AMAP
//配置apiKey
- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *name   = [NSString stringWithFormat:@"\nSDKVersion:%@\nFILE:%s\nLINE:%d\nMETHOD:%s", [MAMapServices sharedServices].SDKVersion, __FILE__, __LINE__, __func__];
        NSString *reason = [NSString stringWithFormat:@"请首先配置APIKey.h中的APIKey, 申请APIKey参考见 http://api.amap.com"];
        
        @throw [NSException exceptionWithName:name
                                       reason:reason
                                     userInfo:nil];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

#pragma mark --- umeng
- (void)initaliseUmengAnalytics{
    [self umengTrack];
}

- (void)umengTrack {
    //[MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
#if DEBUG
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
#endif
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (void)initaliseUmengShare{
    [UMSocialData setAppKey:UMENG_APPKEY];
    //设置微信
    [UMSocialWechatHandler setWXAppId:WEIXIN_API_KEY appSecret:WEIXIN_API_SECRET url:WEIXIN_REDIRECT_URI];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaHandler openSSOWithRedirectURL:SINA_WEIBO_REDIRECT_URL];
    //设置QQ空间
    [UMSocialQQHandler setQQWithAppId:QZONE_API_KEY appKey:QZONE_API_SECRET url:QZONE_REDIRECT_URI];
}

#pragma mark  login & logout notice
- (void)userLoginSucceedNotice:(NSNotification *)notice{
    XQBLog();
    [BPush bindChannel];
    
}

- (void)userLogoutSucceedNotice:(NSNotification *)notice{
    XQBLog();
    [BPush unbindChannel];
}

#pragma mark -- Push Notification
- (void)registerPushNotification:(NSDictionary *)launchOptions{
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];

#ifdef __IPHONE_8_0
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
#endif

}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken: deviceToken];
    [BPush bindChannel];    //必须的
}

- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
        
        //        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        //        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        //        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];x
        
        self.subscriberId = userid;
        self.channelId = channelid;
        [self reportBPushNoticefication];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucceedNotice:) name:kXQBLoginSucceedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutSucceedNotice:) name:kXQBLogoutSucceedNotification object:nil];
        NSLog(@"%@",res);
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            // do something
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        XQBLog(@"The application received this remote notification while it was running:\n%@", alert);
    }
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
    
}

- (void)reportBPushNoticefication{
    if ([UserModel isLogin]) {
        [self requestBPUshNotification];
    }else{
        [BPush unbindChannel];
    }
}

- (void)requestBPUshNotification{
    if (self.subscriberId && self.channelId) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
        if ([UserModel shareUser].communityId.length > 0) {
            [parameters setObject:[UserModel shareUser].communityId forKey:@"communityId"];
        }
        
        [parameters setObject:[UserModel shareUser].userId forKey:@"userId"];
        [parameters setObject:self.subscriberId forKey:@"baiduUserId"];
        [parameters setObject:self.channelId forKey:@"channelId"];
        [parameters setObject:@"4" forKey:@"deviceNumber"];    //1：浏览器设备；2：PC设备；3：Andriod设备；4：iOS设备；5：Windows Phone
        
        [manager POST:API_USER_BAIDU_REPORT parameters:parameters
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]){
            XQBLog(@"百度云推送上报成功");
        }else{
            XQBLog(@"百度云推送上报失败%@",responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XQBLog(@"网络异常:%@",error);
    }];
    }

    
}

@end
