//
//  AppConfig.h
//  CommunityAPP
//
//  Created by liuzhituo on 14-3-8.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#ifndef CommunityAPP_AppConfig_h
#define CommunityAPP_AppConfig_h

//JSON
#define DealWithJSONValue(_JSONVALUE)         (_JSONVALUE != [NSNull null]) ? _JSONVALUE:@""
#define DealWithJSONBoolValue(_JSONVALUE)     (_JSONVALUE != [NSNull null]) ? [_JSONVALUE boolValue]:0
#define DealWithJSONIntValue(_JSONVALUE)     (_JSONVALUE != [NSNull null]) ? [_JSONVALUE integerValue]:0

//MD5 signature key
#define MD5_SIGNATURE_KEY           @"_xiaoqubao!*_client^*"

#define XQB_CUSTOME_SERVICE                 @"小区宝官方客服"
#define XQB_PROPERTY_CUSTOME_SERVICE        @"物业客服"

#define XQB_CUSTOME_SERVICE_PHONE_NUMBER    @"4008338528"

#define XQBHomePageCacheFile                @"kXQBHomePageCacheKey.plist"

#define kXQBLoginSucceedNotification                        @"kXQBLoginSucceedNotification"
#define kXQBUserCertificationSucceedNotification            @"kXQBUserCertificationSucceedNotification"
#define kXQBLogoutSucceedNotification                       @"kXQBLogoutSucceedNotification"
#define kXQBRegisterSucceedNotification                     @"kXQBRegisterSucceedNotification"

#define ERROR_CODE                      @"errorCode"
#define ERROR_MSG                       @"errormsg"

#define DEF_UPDATE_TIME                 @"1"
#define MY_PRIVATE_CONTACTS_TYPE_ID     @"-10010"
#define MY_RECENTLY_TYPE_ID             @"-1"

//网络返回code定义
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

#define NETWORK_CITY_NOT_OPEN                   @"CITY_NOT_OPEN"            //城市未开通商城
#define NETWORK_EMPTY_PRODUCT                   @"EMPTY_PRODUCT"            //商品不存在或已下架
#define NETWORK_STOCK_AMOUNT_NOT_ENOUGH         @"STOCK_AMOUNT_NOT_ENOUGH"  //库存不足
#define NETWORK_LIMITED_BUYNUMBER_EXCEED        @"LIMITED_BUYNUMBER_EXCEED"

//友盟统计页面
#define UM_LOGIN_PAGE                                   @"um_login_page"
#define UM_HOME_ROOT_PAGE                               @"um_home_root_page"
#define UM_CONVIENCE_ROOT_PAGE                          @"um_convience_root_page"
#define UM_NEIGHBOUR_ROOT_PAGE                          @"um_neighbour_root_page"
#define UM_MY_ROOT_PAGE                                 @"um_my_root_page"
#define UM_HOME_NOTICE_PAGE                             @"um_home_notice_page"
#define UM_HOME_TRAFFIC_PAGE                            @"um_home_traffic_page"
#define UM_HOME_PROPERTY_PAGE                           @"um_home_property_page"
#define UM_HOME_NEIGHBOUR_PAGE                          @"um_home_neighbour_page"
#define UM_HOME_LIVE_PAGE                               @"um_home_live_page"
#define UM_HOME_PHONEBOOK_PAGE                          @"um_home_phonebook_page"
#define UM_HOME_LOTTERY_PAGE                            @"um_home_lottery_page"
#define UM_HOME_BUSINESS_PAGE                           @"um_home_bussiness_page"


//一级菜单
#define UM_LOGIN_EVENT                                   @"um_login"
#define UM_HOME_ROOT_EVENT                               @"um_home_root"                        //首页
#define UM_CONVIENCE_ROOT_EVENT                          @"um_convience_root"                   //便民
#define UM_NEIGHBOUR_ROOT_EVENT                          @"um_neighbour_root"                   //邻居
#define UM_MY_ROOT_EVENT                                 @"um_my_root"                          //我的


//首页二级菜单
#define UM_HOME_NOTICE_EVENT                             @"um_home_notice"                      //小区通知
#define UM_HOME_TRAFFIC_EVENT                            @"um_home_traffic"                     //小区交通
#define UM_HOME_PROPERTY_EVENT                           @"um_home_property"                    //物业服务
#define UM_HOME_NEIGHBOUR_EVENT                          @"um_home_neighbour"                   //邻里之间
#define UM_HOME_LIVE_EVENT                               @"um_home_live"                        //生活百科
#define UM_HOME_PHONEBOOK_EVENT                          @"um_home_phonebook"                   //电话本
#define UM_HOME_LOTTERY_EVENT                            @"um_home_lottery"                     //积分消费
#define UM_HOME_BUSINESS_EVENT                           @"um_home_bussiness"                   //小区商业
#define UM_HOME_EC_EVENT                                 @"um_home_ec"
#define UM_HOME_EC_DETAIL_EVENT                          @"um_home_ec_detail"
//首页邻里之间三级菜单
#define UM_HOME_NEIGHBOUR_CARPOOLING_EVENT               @"um_home_neighbour_carpooling"        //拼车上下班
#define UM_HOME_NEIGHBOUR_AUCTION_EVENT                  @"um_home_neighbour_auction"           //随手拍了卖

//物业服务三级菜单
#define UM_HOME_PROPERTY_BUSSUBWAY_EVENT                 @"um_home_property_bussubway"          //公交地铁
#define UM_HOME_PROPERTY_COMMUNITYINTRO_EVENT            @"um_home_property_communityintro"     //小区介绍
#define UM_HOME_PROPERTY_RULES_EVENT                     @"um_home_property_rules"              //规章制度
#define UM_HOME_PROPERTY_REPAIR_EVENT                    @"um_home_property_repair"             //维修
#define UM_HOME_PROPERTY_PRAISE_EVENT                    @"um_home_property_praise"             //表扬
#define UM_HOME_PROPERTY_CRITICIZE_EVENT                 @"um_home_property_criticize"          //投诉

//我:二级菜单
#define UM_MY_BILL_EVENT                                 @"um_my_bill"                          //我的账单
#define UM_MY_POINT_EVENT                                @"um_my_point"                         //我的积分
#define UM_MY_PUBLISH_EVENT                              @"um_my_publish"                       //我的发布
#define UM_MY_COMMENT_EVENT                              @"um_my_comment"                       //我的评论
#define UM_MY_COLLECTION_EVENT                           @"um_my_collection"                    //我的收藏
#define UM_MY_INVITE_REGISTER                            @"um_my_invite_register"               //邀请注册
#define UM_MY_ORDER_EVENT                                @"um_my_order"


//无数据页面提示

#define NO_DATA_MY_BILL                         @"亲，您还没有账单!"
#define NO_DATA_MY_PUBLISH                      @"亲，您还没有发布信息!"
#define NO_DATA_MY_COMMENT                      @"亲，您还没有评论信息!"
#define NO_DATA_MY_COLLECTION                   @"亲，您还没有收藏信息!"
#define NO_DATA_MY_FANS                         @"亲，您还没有粉丝!"
#define NO_DATA_CAR_POOLING                     @"亲，您还没有拼车信息!"
#define NO_DATA_AUCTION                         @"亲，您还没有随手拍了买信息!"
#define NO_DATA_REPAIRS                         @"亲，您还有预约维修信息!"
#define NO_DATA_COMMUNITY_BUSINESS              @"亲，您还没有小区商业信息!"
#define NO_DATA_NOTICE                          @"亲，还没有通知信息!"
#define NO_DATA_DP_LIST                         @"亲，还没有便民数据!"
#define NO_DATA_LIVE_ENCYCLOPEDIA               @"亲，还没有生活详情信息!"
#define NO_DATA_RULES                           @"亲，还没有规章制度信息!"
#define NO_DATA_LEAVING_MESSAGE                 @"亲，还没有留言信息!"
#define NO_DATA_CONVIENCE                       @"亲，还没有便民数据！"
#define NO_CONTACTS                             @"亲，您还没有联系人!"
#define NO_DATA_AWARD_RECORDING                 @"亲，还没有获奖记录!"
#define NO_DATA_LUCK_DRAW                       @"抽奖没有加载出来!"
#define NO_DATA_AWARD_VIEW                      @"亲，还没有奖品详情!"
#define NO_DATA_PRAISE                          @"亲，还没有表扬信息!"
#define NO_DATA_CRITICIZE                       @"亲，您还没有物业信箱信息!"
#define NO_DATA_PERSON_DYNAMIC                  @"亲，还没有个人动态信息!"
#define NO_DATA_PET_DETAIL                      @"亲，您还有我型我秀信息!"

//无数据页面提示
#define NO_NETWORK                              @"木有WiFi和信号的人生好忧桑~"
#define NO_NETWORK_DESCRIBE                     @"请确保网络或移动数据连接哦~"
#define SERVER_ERROR                            @"服务器被外星人抢走啦！"
#define SERVER_ERROR_DESCRIBE                   @"请使劲刷新几次重试~"
#define MALL_CITY_NOT_OPEN                      @"商城暂未开通！"
#define MALL_NO_LIST_DATA                       @"商城列表没有数据~"
#define MALL_NO_LIST_DATA_DESCRIBE              @"请刷新重试一下~"
#define MALL_NO_ORDER_ALL                       @"糟糕，什么订单都没有~"
#define MALL_NO_ORDER_ALL_DESCRIBE              @"快去逛逛吧，喜欢就下单哦~"
#define MALL_NO_ORDER_WAIT_PAYMENT              @""
#define MALL_NO_ORDER_WAIT_PAYMENT_DESCRIBE     @""
#define MALL_NO_ORDER_WAIT_SHIPPING             @""
#define MALL_NO_ORDER_WAIT_SHIPPING_DESCRIBE    @""
#define MALL_SHOPPING_CART_EMPTY                @"购物车空空如也，好饿好饿~"
#define MALL_SHOPPING_CART_EMPTY_DESCRIBE       @"去看看有什么好吃的好吗？~"
#define MALL_NO_CITY_AREAR_LIST_DATA            @"没有所在地区信息"

//Toast提示
#define TOAST_NO_NETWORK                        @"当前网络异常"
#define TOAST_SERVER_ERROR                      @"服务器异常"

#endif


