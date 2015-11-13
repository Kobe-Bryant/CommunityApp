//
//  CommonParameters.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/24.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonParameters : NSObject

+ (NSDictionary *)CPUserIdDic;          //用户id
+ (NSDictionary *)CPCommunityIdDic;     //小区id
+ (NSDictionary *)CPPropertyIdDic;      //物业id
+ (NSDictionary *)CPOSVersionDic;       //操作系统版本
+ (NSDictionary *)CPDeviceDic;          //设备名称（iPhone4，iPhone5，iPad等等）
+ (NSDictionary *)CPTokenDic;           //秘钥
+ (NSDictionary *)CPVersionCodeDic;     //程序当前版本
+ (NSDictionary *)CPProductIdDic;       //当前产品
+ (NSDictionary *)CPUuidDic;            //设备唯一标识
+ (NSDictionary *)getCommonParameters;  //获取住户的公共参数

@end
