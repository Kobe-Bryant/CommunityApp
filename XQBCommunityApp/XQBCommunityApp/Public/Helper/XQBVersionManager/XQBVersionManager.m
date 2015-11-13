//
//  XQBVersionManager.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/26.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBVersionManager.h"
#import "Global.h"

NSInteger tag = 1000;

static XQBVersionManager *_instance = nil;

@interface XQBVersionManager ()<UIAlertViewDelegate>

@end

@implementation XQBVersionManager

+ (instancetype)shareInstance{
    if (_instance == nil) {
        _instance = [[XQBVersionManager alloc] init];
    }
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)checkVersionUpdate{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters addSignatureKey];
    
    [manager GET:API_APP_UPDATE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            XQBLog(@"版本更新请求成功");
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSDictionary *appDic = [data objectForKey:@"app"];
            NSString *updateContent = [appDic objectForKey:@"description"];
            BOOL isLatest = [[appDic objectForKey:@"isLatest"] boolValue];
            BOOL isForceUpdate = [[appDic objectForKey:@"isForceUpdate"] boolValue];
            if (isLatest) {
                //[[UIApplication sharedApplication].keyWindow makeCustomToast:@"已是最新版本"];
            }else{
                if (isForceUpdate) {
                    UIAlertView *forceUpdtateAlertView = [[UIAlertView alloc] initWithTitle:@"亲，有新版本哟~~" message:updateContent delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    
                    forceUpdtateAlertView.tag = tag+1;
                    [forceUpdtateAlertView show];
                    
                    
                }else{
                    UIAlertView *forceUpdtateAlertView = [[UIAlertView alloc] initWithTitle:@"亲，有新版本哟~~" message:updateContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级",nil];
                    forceUpdtateAlertView.tag = tag+2;
                    [forceUpdtateAlertView show];
                }
            }
            
            
        } else {
            //加载服务器异常界面
            XQBLog(@"服务器异常");
            [[UIApplication sharedApplication].keyWindow makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        [[UIApplication sharedApplication].keyWindow makeCustomToast:TOAST_NO_NETWORK];
    }];

}


#pragma mark ---alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger alertIndex = alertView.tag - tag;
    switch (alertIndex) {
        case 1:
        {
            [self openiTunesStoreURL];
            exit(0);
        }
            
            break;
        case 2:{
            
            if (buttonIndex == 0) {
                //取消升级
                XQBLog(@"取消版本升级");
            }else{
                [self openiTunesStoreURL];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)openiTunesStoreURL{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
}

@end
