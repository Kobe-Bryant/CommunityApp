//
//  UserModel.h
//  CommunityAPP
//
//  Created by Stone on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ResidentType) {
    XQB_USER_IDENTIFY_GUEST           = 0,              //游客
    XQB_USER_IDENTIFY_GENERAL         = 1,              //普通注册用户
    XQB_USER_IDENTIFY_RESIDENT        = 2,

};

#define XQB_USER_IDENTIFY_GUEST         @"GUEST"    //游客
#define XQB_USER_IDENTIFY_GENERAL       @"GENERAL"  //普通注册用户
#define XQB_USER_IDENTIFY_RESIDENT      @"RESIDENT" //物业用户

@interface UserModel : NSObject

+ (UserModel *)shareUser;
+ (BOOL)isLogin;

@property (nonatomic, strong) NSString *userId;             //用户Id
@property (nonatomic, strong) NSString *password;           //密码
@property (nonatomic, strong) NSString *userName;           //用户名 电话号码
@property (nonatomic, strong) NSString *nickName;           //昵称
@property (nonatomic, strong) NSString *userIcon;           //用户头像
@property (nonatomic, strong) NSString *gender;             //用户性别  1男，2女
@property (nonatomic, strong) NSString *signature;          //用户简介
@property (nonatomic, strong) NSString *birthday;           //用户生日
@property (nonatomic, strong) NSString *email;              //邮箱
@property (nonatomic, strong) NSString *microblog;          //微博
@property (nonatomic, strong) NSString *qq;                 //qq
@property (nonatomic, strong) NSString *provinceId;         //省Id
@property (nonatomic, strong) NSString *provinceName;       //省名称
@property (nonatomic, strong) NSString *cityId;             //城市Id
@property (nonatomic, strong) NSString *cityName;           //城市名称
@property (nonatomic, strong) NSString *communityId;        //社区Id
@property (nonatomic, strong) NSString *communityName;      //小区名称
@property (nonatomic, strong) NSString *userType;           //用户类型：住户；非住户
@property (nonatomic, strong) NSString *residentDesc;       //住户的小区信息

- (NSString *)getGenderChar;

- (void)saveUserInfo;

- (void)getUserInfo;

- (void)clearUserInfo;

/**
 *  修改个人资料成功后同步到 单例及持久化存储
 */
- (void)syncUserInfo;

/**
 *  复制用户个人资料
 */

- (void)copyUserInfoToInstance;

@end
