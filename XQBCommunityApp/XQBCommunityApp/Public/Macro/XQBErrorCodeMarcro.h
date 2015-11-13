//
//  XQBErrorCodeMarcro.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/27.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#ifndef XQBCommunityApp_XQBErrorCodeMarcro_h
#define XQBCommunityApp_XQBErrorCodeMarcro_h

#define XQB_NETWORK_DATA                        @"data"
#define XQB_NETWORK_ERROR_CODE                  @"code"
#define XQB_NETWORK_ERROR_MESSAGE               @"message"

//code的取值
#define XQB_NETWORK_ERROR_CODE_OK                           @"ok"                               //表示操作成功
#define XQB_NETWORK_ERROR_CODE_SERVER_ERROR                 @"oops"                             //服务器出错

//============================== XQBMe ==============================
//注册-第一步-获取验证码
#define XQB_NETWORK_VCODE_PHONE_INCORRECT                   @"PHONE_INCORRECT"                  //手机格式不正确
#define XQB_NETWORK_VCODE_USER_ALREADY_EXIST                @"USER_ALREADY_EXIST"               //用户已存在
//注册-第一步-验证手机号和验证码
#define XQB_NETWORK_VRV_VERIFICATION_CODE_INCORRECT         @"VERIFICATION_CODE_INCORRECT"      //验证码不正确
#define XQB_NETWORK_VRV_VERIFICATION_CODE_NOT_EXISTT        @"VERIFICATION_CODE_NOT_EXISTT"     //验证码不存在
//注册-第二步-注册
#define XQB_NETWORK_REGISTER_USER_ALREADY_EXIST             @"USER_ALREADY_EXIST"               //用户已存在
#define XQB_NETWORK_REGISTER_REGISTER_OUT_OF_TIME           @"REGISTER_OUT_OF_TIME"             //注册已过期

//登录
#define XQB_NETWORK_LOGIN_USER_NOT_EXIST                    @"USER_NOT_EXIST"                   //用户不存在
#define XQB_NETWORK_LOGIN_PASSWORD_EMPTY                    @"PASSWORD_EMPTY"                   //密码为空
#define XQB_NETWORK_LOGIN_PASSWORD_INCORRETC                @"PASSWORD_INCORRETC"               //密码不正确

//找回密码
#define XQB_NETWORK_RESET_PASSWORD_USER_NOT_EXIST           @"USER_NOT_EXIST"                   //用户不存在
#define XQB_NETWORK_RESET_PASSWORD_OUT_OF_TIMEE             @"RESET_PASSWORD_OUT_OF_TIMEE"      //重置密码已过期 




///////////////////////////////////////////
// old
///////////////////////////////////////////
#define NETWORK_RETURN_ERROR_CODE               @"errorCode"
#define NETWORK_RETURN_ERROR_MSG                @"errorMsg"

#define NETWORK_RETURN_CODE_S_OK                @"000"          //表示操作成功
#define NETWORK_RETURN_CODE_S_FAIL              @"001"          //未捕获的系统级错误
#define NETWORK_RETURN_PARA_ERROR               @"002"          //参数错误
#define NETWORK_RETURN_CHECK_FAILED             @"003"          //验证失败
#define NETWORK_RETURN_DB_EXCEPTION             @"004"          //数据库异常
#define NETWORK_RETURN_AUTHCODE_ERROR           @"005"          //验证码有误
#define NETWORK_RETURN_UPLOAD_EXCEPTION         @"006"          //文件上传异常
#define NETWORK_RETURN_INVCODE_ERROR            @"007"          //邀请码错误
#define NETWORK_RETURN_MESSAGE_CODE_ERROR       @"008"          //短信验证码发送失败

#define NETWORK_RETURN_POWER_AUTH_ERROR         @"010"          //权限认证失败
#define NETWORK_RETURN_USER_INFO_ERROR          @"011"          //登录信息有误

#define NETWORK_RETURN_USERINFO_ERROR           @"018"          //强制用户重新登录

#define NETWORK_RETURN_USER_REGIRESTED          @"021"          //用户已经注册
#define NETWORK_RETURN_USER_UNINVITED           @"022"          //该用户还没有被邀请

#define NETWORK_RETURN_NO_MUTUAL_ATTENTION      @"024"          //没有相互关注

#define NETWORK_RETURN_DB_404                   @"404_DB"       //数据不存在

#define NETWORK_STOCK_AMOUNT_NOT_ENOUGH         @"STOCK_AMOUNT_NOT_ENOUGH"      //库存不足
#define NETWORK_LIMITED_BUYNUMBER_EXCEED        @"LIMITED_BUYNUMBER_EXCEED"     //超出限购

#endif
