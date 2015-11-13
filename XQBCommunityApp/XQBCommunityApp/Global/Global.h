//
//  Global.h
//  CommunityAPP
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#ifndef Sesame_ENVIRONMENT

#define Sesame_ENVIRONMENT 2//0:开发环境 1:测试环境 2:生产环境 3:预生产环境 999:挡板环境


#if Sesame_ENVIRONMENT==0
#define HTTPURLPREFIX @"http://192.168.1.9"
#define kHost @"192.168.1.9"

#define K_API_KEY   "0"

#elif Sesame_ENVIRONMENT==1
#define HTTPURLPREFIX @"http://192.168.1.5"
#define kHost @"192.168.1.5"
#define K_API_KEY   "1"

#elif Sesame_ENVIRONMENT==2
#define HTTPURLPREFIX @"http://i.city-media.net"               //http://xqb.city-media.net
#define kHost @"113.106.91.178"
#define K_API_KEY   "2"


#elif Sesame_ENVIRONMENT==3
#define HTTPURLPREFIX @"http://yunlaicn.oicp.net:81"
#define K_API_KEY   "3"
#endif
#endif

#define UNION_PAY_PLUGIN_ENVIRONMENT    @"00"       //00:生产环境       01:测试环境
#define kResult           @"支付结果：%@"

/*********************挡板环境*********************/
//#elif Sesame_ENVIRONMENT==999
//#define HTTPURLPREFIX @"http://192.168.0.2"
//#endif

//百度地图
#define KBaiduAppKey @""

//add vincent
#define CommunitySendBackHeight 45
#define CommunityRowcellCount 2
#define RMarginX 0
#define RMarginY 0

#import <Foundation/Foundation.h>
#include <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
#import "Macros.h"
#import "XQBUIFormatMacros.h"
#import "XQBUrlMacros.h"
#import "UIViewController+NavigationBar.h"
#import "UIImage+extra.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+BaseUrl.h"
#import "CommonParameters.h"
#import "NSMutableDictionary+SignatureKey.h"
#import "UIView+CustomToast.h"
#import "XQBErrorCodeMarcro.h"
#import "XQBVendorMarcros.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MobClick.h"
#import "UIImage+extra.h"
#import "NSObject+Time.h"
#import "tooles.h"
#import "AppConfig.h"
#import "XQBFeedTypeMacros.h"
#import "XQBBaseTableView.h"
#import "POP.h"
#import "XQBLoadingView.h"
#import "XQBMeViewController.h"

@interface Global : NSObject

+ (instancetype)shareInstance;

@end
