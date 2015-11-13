//
//  XQBUserManager.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/16.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBUserManager.h"
#import "Global.h"
#import "NSString+MD5.h"

static XQBUserManager *_instance = nil;

@implementation XQBUserManager

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)shareInstance{
    if (_instance == nil) {
        _instance = [[XQBUserManager alloc] init];
    }
    
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.userAvailable = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucceedNotice:) name:kXQBLoginSucceedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutSucceedNotice:) name:kXQBLogoutSucceedNotification object:nil];
    }
    return self;
}


- (void)XQBLogin{
    if ([UserModel shareUser].userName.length == 0 || [UserModel shareUser].password.length == 0) {
        
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    [parameters setObject:[UserModel shareUser].userName forKey:@"username"];
    NSString *md5Password = [UserModel shareUser].password;
    [parameters setObject:md5Password forKey:@"password"];
    
    [parameters addSignatureKey];
    
    [manager POST:API_USER_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            XQBLog(@"登录成功");
            NSDictionary *dataDic = [responseObject objectForKey:XQB_NETWORK_DATA];
            
            [UserModel shareUser].userId        = [[dataDic objectForKey:@"userId"] stringValue];
            [UserModel shareUser].nickName      = [dataDic objectForKey:@"nickname"];
            [UserModel shareUser].userName      = [dataDic objectForKey:@"userName"];
            [UserModel shareUser].userIcon      = [dataDic objectForKey:@"icon"];
            [UserModel shareUser].gender        = [[dataDic objectForKey:@"gender"] stringValue];
            [UserModel shareUser].signature     = [dataDic objectForKey:@"signature"];
            [UserModel shareUser].birthday      = [dataDic objectForKey:@"birthday"];
            [UserModel shareUser].email         = [dataDic objectForKey:@"email"];
            [UserModel shareUser].microblog     = [dataDic objectForKey:@"microblog"];
            [UserModel shareUser].qq            = [dataDic objectForKey:@"qq"];
            [UserModel shareUser].provinceId    = [[dataDic objectForKey:@"provinceId"] stringValue];
            [UserModel shareUser].provinceName  = [dataDic objectForKey:@"provinceName"];
            [UserModel shareUser].userType      = [dataDic objectForKey:@"userType"];
            [UserModel shareUser].residentDesc  = [dataDic objectForKey:@"residentDesc"];
            [UserModel shareUser].cityId        = [[dataDic objectForKey:@"cityId"] stringValue];
            [UserModel shareUser].cityName      = [dataDic objectForKey:@"cityName"];
            [UserModel shareUser].communityId   = [[dataDic objectForKey:@"communityId"] stringValue];
            [UserModel shareUser].communityName = [dataDic objectForKey:@"communityName"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kXQBLoginSucceedNotification object:nil];
            
        }  else {
            self.userAvailable = NO;
            //加载服务器异常界面
            if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_LOGIN_USER_NOT_EXIST]) {
                self.userAvailable = NO;
                XQBLog(@"%@", [responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]);
                //[self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
            } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_LOGIN_PASSWORD_EMPTY]) {
                XQBLog(@"%@", [responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]);
                //[self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
            } else if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_LOGIN_PASSWORD_INCORRETC]) {
                XQBLog(@"%@", [responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]);
                //[self.view.window makeCustomToast:[responseObject objectForKey:XQB_NETWORK_ERROR_MESSAGE]];
            }else{
                XQBLog(@"服务器异常");
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
        self.userAvailable = NO;
        
    }];

}

- (void)XQBLogout{

}

- (void)userLoginSucceedNotice:(NSNotification *)notice{
    self.userAvailable = YES;
}

- (void)userLogoutSucceedNotice:(NSNotification *)notice{
    self.userAvailable = NO;
}

@end
