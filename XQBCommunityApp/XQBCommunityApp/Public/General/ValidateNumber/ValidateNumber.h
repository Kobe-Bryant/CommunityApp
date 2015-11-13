//
//  ValidateNumber.h
//  CommunityAPP
//
//  Created by Oliver on 14-9-3.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateNumber : NSObject


+ (BOOL) validateMobile:(NSString *)mobile;          //手机号码验证
+ (BOOL) validatePassword:(NSString *)passWord;      //密码
+ (BOOL) validateNickname:(NSString *)nickname;      //昵称
+ (BOOL) validateHanzi:(NSString *)hanzi;            //中文字符

@end
