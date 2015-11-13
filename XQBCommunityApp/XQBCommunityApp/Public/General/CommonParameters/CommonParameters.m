//
//  CommonParameters.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/24.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "CommonParameters.h"
#import "UserModel.h"
#import "Global.h"

@implementation CommonParameters


+ (NSDictionary *)CPUserIdDic
{
    return [NSDictionary dictionaryWithObject:[UserModel shareUser].userId forKey:@"userId"];
}

+ (NSDictionary *)CPCommunityIdDic
{
    return [NSDictionary dictionaryWithObject:[UserModel shareUser].communityId forKey:@"communityId"];
}


+ (NSDictionary *)CPOSVersionDic
{
    return [NSDictionary dictionaryWithObject:[[UIDevice currentDevice] systemVersion] forKey:@"osversion"];
}

+ (NSDictionary *)CPDeviceDic
{
    return [NSDictionary dictionaryWithObject:[[UIDevice currentDevice] model] forKey:@"device"];
}

+ (NSDictionary *)CPVersionCodeDic
{
    return [NSDictionary dictionaryWithObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"versionCode"];
}

+ (NSDictionary *)CPProductIdDic
{
    return [NSDictionary dictionaryWithObject:APP_ID forKey:@"productId"];
}

+ (NSString *)CPUuidString{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}

+ (NSDictionary *)CPUuidDic
{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return [NSDictionary dictionaryWithObject:idfv forKey:@"uuid"];
}

+ (NSDictionary *)getCommonParameters
{
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc] initWithCapacity:7];
    [parametersDic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osversion"];
    [parametersDic setObject:[[UIDevice currentDevice] model] forKey:@"device"];
    [parametersDic setObject:APP_VERSION forKey:@"versionCode"];
    [parametersDic setObject:[self CPUuidString] forKey:@"deviceId"];
    [parametersDic setObject:@"ios" forKey:@"deviceType"];
    [parametersDic setObject:[UserModel shareUser].cityId forKey:@"cityId"];
    
    if ([UserModel isLogin]) {
        [parametersDic setObject:[UserModel shareUser].userId forKey:@"userId"];
        [parametersDic setObject:[UserModel shareUser].communityId forKey:@"communityId"];
    }
    
    /*
    if ([UserModel shareUser].token) {
        [parametersDic setObject:[UserModel shareUser].token forKey:@"token"];
    } else {
        //token为空也不传
    }
     */
    
    return parametersDic;
}

@end
