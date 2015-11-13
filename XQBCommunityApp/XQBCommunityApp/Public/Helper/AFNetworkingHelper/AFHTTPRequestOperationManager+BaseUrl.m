//
//  AFHTTPRequestOperationManager+BaseUrl.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/24.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "AFHTTPRequestOperationManager+BaseUrl.h"
#import "Global.h"

@implementation AFHTTPRequestOperationManager (BaseUrl)

+ (instancetype)shareManager{
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:HTTPURLPREFIX]];
}

@end
