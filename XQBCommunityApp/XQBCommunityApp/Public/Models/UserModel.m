//
//  UserModel.m
//  CommunityAPP
//
//  Created by Stone on 14-3-11.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "UserModel.h"
#import "NSFileManager+Community.h"
#import "Global.h"
#import "XQBCoreLBS.h"
#import "CityMappingTable.h"
#import "XQBUserManager.h"


#define USER_ID                 @"xqb_userId"
#define USER_PASSWORD           @"xqb_user_password"
#define USER_NAME               @"xqb_userName"
#define NICK_NAME               @"xqb_nickName"
#define USER_ICON               @"xqb_userIcon"
#define GENDER                  @"xqb_gender"
#define USER_SIGNATURE          @"xqb_signature"
#define BIRTHDAY                @"xqb_birthday"
#define EMAIL                   @"xqb_email"
#define MICROBLOG               @"xqb_microblog"
#define QQ                      @"xqb_qq"
#define PROVINCE_ID             @"xqb_provinceId"
#define PROVINCE_NAME           @"xqb_provinceName"
#define CITY_ID                 @"xqb_cityId"
#define CITY_NAME               @"xqb_cityName"
#define COMMUNITY_ID            @"xqb_communityId"
#define COMMUNITY_NAME          @"xqb_communityName"
#define USER_TYPE               @"xqb_userType"
#define RESIDENT_DESC           @"xqb_residentDesc"

#define PROPERTY_ID             @"xqb_propertyId"
#define TOKEN                   @"xqb_token"
#define RESIDENT_TYPE           @"xqb_residentType"


static UserModel *user = nil;

@interface UserModel ()<NSMutableCopying,NSCopying>

@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, getter=isLogin)         BOOL login;

@end

@implementation UserModel

@synthesize gender = _gender;

+ (UserModel *)shareUser
{
    
    if (user == nil) {
        user = [[UserModel alloc] init];
    }
    return user;
}

+ (BOOL)isLogin{
    return [XQBUserManager shareInstance].isUserAvailable;
}



- (id)init{
    self = [super init];
    if (self) {
        [self getUserInfo];
    }
    return self;
}

- (NSString *)userName{
    if (!_userName) {
        return @"";
    }
    return _userName;
}

- (NSString *)password{
    if (!_password) {
        return @"";
    }
    return _password;
}

-(NSString *)userId{

    if (!_userId) {
        return @"";
    }
    
    return _userId;
}

- (NSString *)communityId{
    
    if (!_communityId) {
        return @"";
    }

    return _communityId;
}

- (NSString *)cityId{
    
    if (![UserModel isLogin] || _cityId.length == 0) {
        _cityId = [[CityMappingTable shareInstance] getCityId:[XQBCoreLBS shareInstance].cityName];
    }
    
    return _cityId;
}

- (NSString *)cityName{
    if (!_cityName) {
        return @"";
    }
    return _cityName;
}

- (NSString *)provinceName{
    if (!_provinceName) {
        return @"";
    }
    return _provinceName;
}

- (void)setGender:(NSString *)gender{
    if ([gender isEqualToString:@"1"] || [gender isEqualToString:@"男"]) {
        _gender = @"1";
    }else if ([gender isEqualToString:@"2"] || [gender isEqualToString:@"女"]){
        _gender = @"2";
    }else{
        _gender = gender;
    }
}


- (NSString *)getGenderChar{
    if ([_gender isEqualToString:@"1"] || [_gender isEqualToString:@"男"]) {
        return @"男";
    }else if ([_gender isEqualToString:@"2"] || [_gender isEqualToString:@"女"]){
        return @"女";
    }
    
    return @"";
}

- (NSString *)userType{
    if (_userType == nil) {
        return XQB_USER_IDENTIFY_GUEST;
    }
    return _userType;
}


#pragma mark ---
- (void)saveUserInfo{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.userName        forKey:USER_NAME];
    [userDefault setObject:self.password        forKey:USER_PASSWORD];
    /*
    [userDefault setObject:self.userId          forKey:USER_ID];
    [userDefault setObject:self.userName        forKey:USER_NAME];
    [userDefault setObject:self.nickName        forKey:NICK_NAME];
    [userDefault setObject:self.userIcon        forKey:USER_ICON];
    [userDefault setObject:self.gender          forKey:GENDER];
    [userDefault setObject:self.signature       forKey:USER_SIGNATURE];
    [userDefault setObject:self.birthday        forKey:BIRTHDAY];
    [userDefault setObject:self.email           forKey:EMAIL];
    [userDefault setObject:self.microblog       forKey:MICROBLOG];
    [userDefault setObject:self.qq              forKey:QQ];
    [userDefault setObject:self.provinceId      forKey:PROVINCE_ID];
    [userDefault setObject:self.provinceName    forKey:PROVINCE_NAME];
    [userDefault setObject:self.userType        forKey:USER_TYPE];
    [userDefault setObject:self.residentDesc    forKey:RESIDENT_DESC];
    [userDefault setObject:self.cityId          forKey:CITY_ID];
    [userDefault setObject:self.cityName        forKey:CITY_NAME];
    [userDefault setObject:self.communityId     forKey:COMMUNITY_ID];
    [userDefault setObject:self.communityName   forKey:COMMUNITY_NAME];
     */

    [NSUserDefaults resetStandardUserDefaults];

    return;
}


- (void)clearUserInfo{
    
    self.userName       = nil;
    self.password       = nil;
    
    
    self.userId         = nil;
    self.nickName       = nil;
    self.userIcon       = nil;
    self.gender         = nil;
    self.signature      = nil;
    self.birthday       = nil;
    self.email          = nil;
    self.microblog      = nil;
    self.qq             = nil;
    self.provinceId     = nil;
    self.provinceName   = nil;
    self.userType       = nil;
    self.residentDesc   = nil;
    self.cityId         = nil;
    self.cityName       = nil;
    self.communityId    = nil;
    self.communityName  = nil;
    
    [self saveUserInfo];
    
    /*
    //清楚签到数据信息
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault synchronize];
    */
}

- (void)getUserInfo{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.userName       = [userDefault objectForKey:USER_NAME];
    self.password       = [userDefault objectForKey:USER_PASSWORD];
    /*
    self.userName       = [userDefault objectForKey:USER_NAME];
    self.nickName       = [userDefault objectForKey:NICK_NAME];
    self.userIcon       = [userDefault objectForKey:USER_ICON];
    self.gender         = [userDefault objectForKey:GENDER];
    self.signature      = [userDefault objectForKey:USER_SIGNATURE];
    self.birthday       = [userDefault objectForKey:BIRTHDAY];
    self.email          = [userDefault objectForKey:EMAIL];
    self.microblog      = [userDefault objectForKey:MICROBLOG];
    self.qq             = [userDefault objectForKey:QQ];
    self.provinceId     = [userDefault objectForKey:PROVINCE_ID];
    self.provinceName   = [userDefault objectForKey:PROVINCE_NAME];
    self.userType       = [userDefault objectForKey:USER_TYPE];
    self.residentDesc   = [userDefault objectForKey:RESIDENT_DESC];
    self.cityId         = [userDefault objectForKey:CITY_ID];
    self.cityName       = [userDefault objectForKey:CITY_NAME];
    self.communityId    = [userDefault objectForKey:COMMUNITY_ID];
    self.communityName  = [userDefault objectForKey:COMMUNITY_NAME];
    */
    return;
}

- (void)syncUserInfo{

    //修改个人资料的临时model保存本地
    [self saveUserInfo];
    
    //同步到单例类
    UserModel *userModel = [UserModel shareUser];
    [userModel getUserInfo];
}

- (void)copyUserInfoToInstance{
    if (self != [UserModel shareUser] && self) {
        UserModel *userModel = [UserModel shareUser];
        userModel.userId         = self.userId;
        userModel.userName       = self.userName;
        userModel.password       = self.password;
        userModel.nickName       = self.nickName;
        userModel.userIcon       = self.userIcon;
        userModel.gender         = self.gender;
        userModel.signature      = self.signature;
        userModel.birthday       = self.birthday;
        userModel.email          = self.email;
        userModel.microblog      = self.microblog;
        userModel.qq             = self.qq;
        userModel.provinceId     = self.provinceId;
        userModel.provinceName   = self.provinceName;
        userModel.userType       = self.userType;
        userModel.residentDesc   = self.residentDesc;
        userModel.cityId         = self.cityId;
        userModel.cityName       = self.cityName;
        userModel.communityId    = self.communityId;
        userModel.communityName  = self.communityName;
        
        [userModel saveUserInfo];
    }


}

- (id)copyWithZone:(NSZone *)zone{
    UserModel *copyUserModel = [[UserModel allocWithZone:zone] init];
    
    copyUserModel.userId         = self.userId;
    copyUserModel.userName       = self.userName;
    copyUserModel.password       = self.password;
    copyUserModel.nickName       = self.nickName;
    copyUserModel.userIcon       = self.userIcon;
    copyUserModel.gender         = self.gender;
    copyUserModel.signature      = self.signature;
    copyUserModel.birthday       = self.birthday;
    copyUserModel.email          = self.email;
    copyUserModel.microblog      = self.microblog;
    copyUserModel.qq             = self.qq;
    copyUserModel.provinceId     = self.provinceId;
    copyUserModel.provinceName   = self.provinceName;
    copyUserModel.userType       = self.userType;
    copyUserModel.residentDesc   = self.residentDesc;
    copyUserModel.cityId         = self.cityId;
    copyUserModel.cityName       = self.cityName;
    copyUserModel.communityId    = self.communityId;
    copyUserModel.communityName  = self.communityName;
    
    return copyUserModel;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    
    //深拷贝的实现
    UserModel *mutableCopyUserModel = [[UserModel allocWithZone:zone] init];
    
    mutableCopyUserModel.userId         = [self.userId copy];
    mutableCopyUserModel.userName       = [self.userName copy];
    mutableCopyUserModel.password       = [self.password copy];
    mutableCopyUserModel.nickName       = [self.nickName copy];
    mutableCopyUserModel.userIcon       = [self.userIcon copy];
    mutableCopyUserModel.gender         = [self.gender copy];
    mutableCopyUserModel.signature      = [self.signature copy];
    mutableCopyUserModel.birthday       = [self.birthday copy];
    mutableCopyUserModel.email          = [self.email copy];
    mutableCopyUserModel.microblog      = [self.microblog copy];
    mutableCopyUserModel.qq             = [self.qq copy];
    mutableCopyUserModel.provinceId     = [self.provinceId copy];
    mutableCopyUserModel.provinceName   = [self.provinceName copy];
    mutableCopyUserModel.userType       = [self.userType copy];
    mutableCopyUserModel.residentDesc   = [self.residentDesc copy];
    mutableCopyUserModel.cityId         = [self.cityId copy];
    mutableCopyUserModel.cityName       = [self.cityName copy];
    mutableCopyUserModel.communityId    = [self.communityId copy];
    mutableCopyUserModel.communityName  = [self.communityName copy];
    
    
    return mutableCopyUserModel;
}

@end
