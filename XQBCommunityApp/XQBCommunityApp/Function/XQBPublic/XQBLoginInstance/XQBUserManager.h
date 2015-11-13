//
//  XQBUserManager.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/16.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQBUserManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,getter=isUserAvailable) BOOL userAvailable;

/**
 *  登录小区宝账户
 */
- (void)XQBLogin;

/**
 *  登出小区宝账户
 */
- (void)XQBLogout;

@end
