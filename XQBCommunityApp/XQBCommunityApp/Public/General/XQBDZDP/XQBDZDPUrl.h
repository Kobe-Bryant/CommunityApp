//
//  XQBDZDPUrl.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/29.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

//大众点评----baseUrl
#define kDPAPIDomain            @"http://api.dianping.com/v1"

//大众点评----appKey，appSecret
#define kDPAppKey               @"5284075423"
#define kDPAppSecret            @"4a1275d5e63f48148aeba4e3d7cf38c5"


//大众点评----接口
//获取支持商户搜索的最新分类列表 获取支持商户搜索的最新分类列表
#define DZDP_GET_CATEGORIES_WITH_BUSINESSES     @"/metadata/get_categories_with_businesses"
//搜索商户 按照地理位置、商区、分类、关键词等多种条件获取商户信息列表
#define DZDP_FIND_BUSINESSES                    @"/business/find_businesses"

#import <Foundation/Foundation.h>

@interface XQBDZDPUrl : NSObject

+ (NSString *)getDPBaseUrl;
+ (NSString *)getDPAppKey;
+ (NSString *)getDPAPPSecret;
//baseURL 可以是拼接好的一个连接
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;

@end
