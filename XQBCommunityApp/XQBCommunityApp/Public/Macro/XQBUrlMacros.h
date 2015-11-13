//
//  XQBUrlMacros.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//
#ifndef XQBCommunityApp_XQBUrlMacros_h
#define XQBCommunityApp_XQBUrlMacros_h


#define DynamicUrl(baseUrl,parameter1) [NSString stringWithFormat:@"%@%@",baseUrl,parameter1]
#define DynamicSepUrl(baseUrl1,parameter1,baseUrl2) [NSString stringWithFormat:@"%@%@%@",baseUrl1,parameter1,baseUrl2]

//#define XQB_DATA_TEST

//2.0版本以后新增加接口
//============================== XQBHomePage ========================
//首页-信息流
#define API_HOME_URL                                @"/api/home"
//首页-广告 (原有接口)
#define HOME_AD_URL                                 @"/api/home/ads"
//点赞(所有点赞接口)
#define API_FEED_FAVOR_URL                          @"/api/feed/favor"
//评论(所有评论接口)
#define API_HOME_FEED_COMMENT_URL                   @"/api/feed/comment"

//首页-跳蚤市场，拼车，邻居圈等列表
#define API_FEED_NEIGHBOUR_URL                      @"/api/feed/neighbour"
//首页-跳蚤市场，拼车，邻居圈等发布的文字
#define API_FEED_ADD_NEITHBOURFEED_URL              @"/api/feed/addNeighbourFeed"
//首页-跳蚤市场，拼车，邻居圈等发布的图片
#define API_FEED_ADD_NEITHBOURFEED_IMGS_URL         @"/api/feed/addNeighbourFeed/imgs"
//首页信息流块接口
#define API_HOME_FEED_LIST                          @"/api/home/feed/list"

//============================== Convenience ========================
//便民-首页列表
#define API_LIFE_URL                                @"/api/life"
//辨明-详情
#define API_LIFE_DETAIL                             @"/api/life/detail"
//============================== ElectricalCemmerce =================

//============================== XQBMe ==============================
//注册-第一步-验证手机号和验证码
#define API_USER_VERIFY_REGISTER_VCODE_URL          @"/api/user/verify_register_vcode"
//注册-第二步-注册
#define API_USER_REGISTER_URL                       @"/api/user/register"

//登录
#define API_USER_LOGIN                              @"/api/user/login"

//重置密码-第一步-验证手机号和验证码
#define API_USER_VERIFY_FIND_PASSWORD_VCODE_URL     @"/api/user/verify_find_back_password_vcode"
//重置密码-第二步-重置密码
#define API_USER_RESET_PASSWORD                     @"/api/user/reset_password"

//退出账户
#define API_UESER_LOGOUT_URL                        @"/api/user/logout"

//完善用户信息
//第一步   开通的城市
#define API_CITY_OPEN_URL                           @"/api/city/open"
//第二步   开通的小区
#define API_COMMUNITY_URL                           @"/api/commmunity"
//第三步   小区房间号
#define API_HOUSE_URL                               @"/api/house"
//完善小区资料
#define API_USER_PERFECT_COMMUNITY_INFORMATION      @"/api/user/perfect_community_information"

//设置（setting）
#define API_APP_UPDATE_URL                          @"/api/app/update"
//编辑（person info）
//编辑-获取个人信息
#define API_USER_PROFILE_URL                        @"/api/user/profile"
//编辑-编辑个人信息
#define API_USER_EDIT_PROFILE_URL                   @"/api/user/edit_profile"

//上传个人头像
#define API_USER_UPLOAD_ICON_URL                    @"/api/user/uploadIcon"

//我的通知
#define API_USER_NOTIFICATIONS_URL                  @"/api/user/notifications"

//邀请注册
#define API_USER_INVITATION_REGISTER_URL            @"/api/user/invitation_register"

//我的账单
#define API_BILL_URL                                @"/api/bill"
//我的账单-有账单的月份
#define API_BILL_YEAR_MONTH_URL                     @"/api/bill/yearMonth"

//意见反馈
#define API_APP_FEEDBACK_URL                        @"/api/app/feedback"

//FAQ
#define API_HOME_FAQ_URL                            @"/api/home/faq"

//============================== Other ==============================
//获取短信验证码
#define API_VCODE_URL                               @"/api/vcode"

//获取省市列表
#define API_CITY_PCS                                @"/api/city/pcs"

//上传百度推送信息
#define API_USER_BAIDU_REPORT                       @"/api/user/baiduReport"

//手机获取验证码的类型
#define VERIFICATION_CODE_TYPE_REGISTER             @"REGISTER"
#define VERIFICATION_CODE_TYPE_FINDBACKPASSWORD     @"FINDBACKPASSWORD"

//用到的老接口
//商城-首页"/api/ec/
#define EC_HOME_URL                     @"/api/ec/home"
//商城-购物车列表
#define EC_CART_URL                     @"/api/ec/carts"
//商城-加入购物车
#define EC_CART_ADD_URL                 @"/api/ec/carts/add"
//商城-修改购物车
#define EC_CART_UPDATE_URL              @"/api/ec/carts/update"
//商城-修改购物车(2.0)
#define EC_CART_BATCH_UPDATE_URL        @"/api/ec/carts/batch_update"


//商城-立即购买
#define EC_ORDERS_CHECKNOW_URL          @"/api/ec/orders/checknow"
//商城-确认订单
#define EC_ORDER_CONFIRMATION_URL       @"/api/ec/orders/confirmation"
//商城-确认订单(2.0)
#define EC_ORDER_NEW_CONFIRMATION_URL   @"/api/ec/orders/new_confirmation"
//商城-提交订单
#define EC_ORDERS_URL                   @"/api/ec/orders"
//商城-提交订单(2.0)
#define EC_ORDERS_NEW_ADD_URL           @"/api/ec/orders/new_add"
//商城-取消订单
#define EC_ORDERS_CANCEL_URL            @"/api/ec/orders/cancel"
//商城-删除订单
#define EC_ORDERS_DELETE_URL            @"/api/ec/orders/delete"
//商城-订单列表
#define EC_ORDERS_LIST_URL              @"/api/ec/orders/"
//商城-订单详情
#define EC_ORDER_INFO_URL(productId)                 DynamicUrl(EC_ORDERS_LIST_URL,productId)
//商城-收货地址
#define EC_SHIPPING_ADDRESS_URL         @"/api/ec/shipping/address"
//获得城市区列表
#define EC_DATA_DISTRICTS_URL           @"/i/v1/data/districts"

//商城-添加收货地址，更新收货地址
#define EC_SHIPPING_SAVE_OR_UPDATE_URL  @"/api/ec/shipping/saveOrUpdate"
//商城-删除收货地址
#define EC_SHIPPING_DELETE_URL          @"/api/ec/shipping/delete"
//商城-设置默认收货地址
#define EC_SHIPPING_SET_DEFAULT_URL     @"/api/ec/shipping/setDefault"

//老接口

//通信的URL
#define My_INTEGRAL                     @"/web/points/my/"
#define LUCKDRAW_My_LOTTERY             @"/web/lottery/"
#define VERSION_UPDATE_URL              @"/i/v1/version/update.do"
#define DATE_COMMIT_URL                 @""
#define NOTIFICATION_LIST_URL           @"/i/v1/notification/list.do"
#define BILL_LIST_URL                   @"/i/v1/bill/list.do"
#define BILL_DETAIL_URL                 @"/i/v1/bill/detail.do"
#define PROFILE_DETAIL_URL              @"/i/v1/profile/detail.do"
#define COMMUNITY_LIST_URL              @"/i/v1/community/address.do"
#define RULES_LIST_URL                  @"/i/v1/rules/list.do"
#define COMMUNITY_INFO_URL              @"/i/v1/community/info.do"
#define CONTACTS_TYPE_URL               @"/i/v1/contacts/type.do"
#define CONTACTS_LIST_URL               @"/i/v1/contacts/list.do"
#define LIVEENCYCLOPEDIA_LIST_URL       @"/i/v1/life/list.do"
#define LIVEENCYCLOPEDIA_INFO_URL       @"/i/v1/life/info.do"
#define MODIFYPASSWORD_INFO_URL         @"/i/v1/profile/setting/changePassword.do"

#define PRIVATE_CONTACTS_ADD_URL        @"/i/v1/privateContacts/add.do"
#define PRIVATE_CONTACTS_UPDATE_URL     @"/i/v1/privateContacts/update.do"
#define PRIVATE_CONTACTS_DELETE_URL     @"/i/v1/privateContacts/delete.do"
#define AUCTION_INFO_URL                @"/i/v1/auction/info.do"
#define AUCTION_LIST_URL                @"/i/v1/auction/list.do"
#define AUCTION_ADD_URL                 @"/i/v1/auction/add.do"
#define LOGIN_REGISTER_LOGIN_URL        @"/i/v1/login/login.do"

//拼车上下班
#define CARSHARING_LIST_URL             @"/i/v1/carsharing/list.do"
#define CARSHARING_INFO_URL             @"/i/v1/carsharing/info.do"
#define CARSHARING_ADD_URL              @"/i/v1/carsharing/add.do"

#define COMMENT_LIST_URL                @"/i/v1/comment/list.do"
//短信验证码
#define COMMENT_REGISTER_MSGCODE        @"/i/v1/register/msgcode.do"
#define REGISTER_SECURITY               @"/i/v1/register/validatecode.do"
#define REGISTER_STEPONE                @"/i/v1/register/stepone.do"
#define REGISTER_STEPTWO                @"/i/v1/register/steptwo.do"

//找回密码
#define SEEK_PASSWORD_TESTSTEP          @"/i/v1/login/findbackmsgcode.do"
#define SEEK_PASSWORD_ONESTEP           @"/i/v1/login/findbackStep1.do"
#define SEEK_PASSWORD_TWOSTEP           @"/i/v1/login/findbackStep2.do"
#define SEEK_PASSWORD_THREESTEP         @"/i/v1/login/findbackStep3.do"
//获取邀请码
#define GET_INVITE                      @"/i/v1/invitecode/getInviteCode.do"
//邀请码历史记录
#define INVITE_HISTORY                  @"/i/v1/invitecode/inviteCodeHistory.do"
//添加评论
#define ADD_COMMENT                     @"/i/v1/comment/add.do"
//添加点赞
#define ADD_LOVE                        @"/i/v1/favour/add.do"
//取消点赞
#define DELE_LOVE                       @"/i/v1/favour/cancel.do"
//删除评论
#define DELEGATE_COMMENT                @"/i/v1/comment/delete.do"
//添加收藏
#define ADD_COLLECTION                  @"/i/v1/collect/add.do"
//取消收藏
#define CANCEL_COLLECTION               @"/i/v1/collect/cancel.do"
//我的评论
#define SEEK_MYCOMMENT                  @"/i/v1/activity/myComment.do"
//我的收藏
#define SEEK_MYCOLLECTION               @"/i/v1/activity/myCollect.do"
//我的发布
#define SEEK_MYPUBLISH                  @"/i/v1/activity/myPublish.do"
//删除我的发布
#define DELEGATE_MYPUBLISH              @"/i/v1/activity/delete.do"
//首页广告(移动到下面了)
//#define HOME_AD_URL                     @"/i/v1/ad/info.do"
//个人资料头像上传
#define MY_MEANS_POST                   @"/i/v1/profile/uploadResidentImg.do"
//修改个人资料
#define PROFILE_UPDATE_URL              @"/i/v1/profile/update.do"

#define MARQUEE_INFO_URL                @"/i/v1/marquee/info.do"
//签到 add vincent
#define REGISTRATION_ADD                @"/i/v1/registration/add.do"
//获奖记录
#define LOTTERY_RECODE                  @"/i/v1/lottery/recode.do"
//奖品列表和详情
#define LOTTERY_PRODUCT                 @"/i/v1/lottery/product.do"
//收货地址列表和详情
#define PROFILE_ADRESS_INFO             @"/i/v1/profile/address/info.do"
//新增和修改地址
#define PROFILE_ADRESS_EDIT             @"/i/v1/profile/address/edit.do"
//删除收货地址
#define PROFILE_ADDRESS_DEL             @"/i/v1/profile/address/del"
//区域地址
#define DATA_LOCATION                   @"/i/v1/data/location.do"
//消息推送数据上报
#define SUBSCRIBER_MSG_URL              @"/i/v1/data/subscriber/msg.do"
//意见反馈
#define MY_ADDVICE_POST                 @"/i/v1/settings/feedback"

//分组列表
#define NEIGHBORHOOD_GROUP_LIST         @"/i/v1/roster/group/list/"
//邻居列表
#define NEIGHBORHOOD_ROSTER_LIST        @"/i/v1/roster/list/"

//积分变更
#define POINT_CHANGE_URL                @"/i/v1/point/change.do"
//获取推送设置
#define SETTINGS_FEEDBACK_LIST          @"/i/v1/settings/feedback/list/"
//推送设置
#define SETTINGS_PUSH                   @"/i/v1/settings/push"

#define INVITE_USER_URL                 @"/i/v1/invite/inviteUser.do"

#define REGISTER_ONE_URL                @"/i/v1/register/registerone.do"

#define REGISTER_TWO_URL                @"/i/v1/register/registertwo.do"

#define REGISTER_THREE_URL              @"/i/v1/register/registerthree.do"

#define INVITE_USER_HISTORY             @"/i/v1/invitecode/inviteUserHistory.do"
//重新邀请用户
#define INVITE_USER_PHONENUMBER         @"/i/v1/invite/inviteUserPhoneNumber.do"
//访问个人主页登记
#define SAVE_VISIT_URL                  @"/i/v1/profile/saveVisit"
//访问个人主页
#define GET_HOME_PAGE_URL               @"/i/v1/profile/getHomePage"
//获取最近访客
#define QUERY_VISITORS_URL              @"/i/v1/profile/queryVisitors"
//获得职业列表
#define OCCUPATION_LIST_URL             @"/i/v1/occupation/list.do"
//发留言
#define LEAVING_MESSAGE_ADD_URL         @"/i/v1/leavingmessage/add.do"
//留言用户列表
#define LEAVING_MESSAGE_USERLIST_URL    @"/i/v1/leavingmessage/userList.do"
//留言内容列表
#define LEAVING_MESSAGE_MSGLIST_URL     @"/i/v1/leavingmessage/msgList.do"
//保存浏览记录
#define READINGS_SAVEREADING_URL        @"/i/v1/readings/saveReading"
//添加预约
#define REPAIR_ADD_URL                  @"/i/v1/repair/add"
//预约列表
#define REAPIR_LIST_URL                 @"/i/v1/repair/list"
//维修评分
#define REPAIR_COMMENT_URL              @"/i/v1/repair/comment"
//获取商店类型列表
#define SHOP_LIST_TYPE_URL              @"/i/v1/shop/listType"
//获取商店列表
#define SHOP_LIST_SHOP_URL              @"/i/v1/shop/listShop"
//获取商店详情
#define SHOP_DETAIL_URL                 @"/i/v1/shop/detail"
//预约上报
#define SHOP_REPORT_URL                 @"/i/v1/shop/report"
//商店评分
#define SHOP_COMMENT_URL                @"/i/v1/shop/comment"
//获取所有最新记录
#define RECORD_LIST_URL                 @"/i/v1/record/list"
//获取表扬或投诉的列表
#define REVIEW_LIST_URL                 @"/i/v1/property/review/reviewList"
//获取表扬或投诉详情
#define REVIEW_INFO_URL                 @"/i/v1/property/review/reviewInfo"
//添加表扬活投诉
#define ENVIEW_ADD_URL                  @"/i/v1/property/review/reviewAdd"
//获取最近动态列表
#define USER_FEED_LIST_URL              @"/i/v1/user/feed/list"
//我的粉丝列表
#define MY_FANS_LIST_URL                @"/i/v1/fans/list"
//验证小区代码
#define VALIDATION_CMU_URL              @"/i/v1/register/validation/cmu"
//小区栋列表
#define CMU_BUILDING_GROUP_URL          @"/i/v1/register/cmu/groups"
//小区房间列表
#define CMU_BUILDING_HOUSE_URL          @"/i/v1/register/cmu/houses"
//验证姓氏（注册）
#define VALIDATION_LASTNAME_URL         @"/i/v1/register/validation/lastname"
//添加或者取消关注
#define ADD_OR_DEL_ATTENTION_URL        @"/i/v1/fans/addOrDelAttention"
//用户登录上报
#define ADD_REPOTRED_USER_LOG_URL       @"/i/v1/reportedUserLog/addReportedUserLog"
//宠物秀列表
#define PET_LIST_URL                    @"/i/v1/pet/petList"
//宠物秀详情
#define PET_INFO_URL                    @"/i/v1/pet/petInfo"
//添加宠物秀
#define ADD_PET_URL                     @"/i/v1/pet/addPet"
//验证用户合法性
#define USER_VALIDATION_URL             @"/i/v1/user/validation"


//商城-广告展示列表
#define EC_ADS_URL                      @"/api/ec/ads/products"
//商城-商品列表
#define EC_PRODUCTS_URL                 @"/api/ec/products"
//商城-限购商品列表
#define EC_LIMITED_BUY_PRODUCTS_URL     @"/api/ec/limitedBuyProducts"
//商城-抢购商品列表
#define EC_RUSH_BUY_PRODUCTS_URL        @"/api/ec/rushBuyProducts"
//商城-商品详情(从商品列表入口进入)
#define EC_PRODUCT_INFO_STATIC_URL      @"/api/ec/products/"
#define EC_PRODUCT_INFO_DYNAMIC_URL(productId)       DynamicUrl(EC_PRODUCT_INFO_STATIC_URL,productId)
//商城-商品详情(从商品项列表入口进入)
#define EC_PRODUCT_INFO_ITEM_URL        @"/api/ec/products/info"
//商城-商品项
#define EC_PRODUCT_ITEM_STATIC_URL      @"/api/ec/products/items/"
#define EC_PRODUCT_ITEM_DYNAMIC_URL(productId)       DynamicUrl(EC_PRODUCT_ITEM_STATIC_URL,productId)
//商城-猜你喜欢列表
#define EC_PRODUCT_GUESS_STATIC_URL     @"/api/ec/products/guess/"
#define EC_PRODUCT_GUESS_DYNAMIC_URL(productId)      DynamicUrl(EC_PRODUCT_GUESS_STATIC_URL,productId)


//商城-购物车商品数量
#define EC_CARTS_ITEMCOUNT_URL          @"/api/ec/carts/itemCount"
//商城-支付
#define EC_PAY_ORDER_URL                @"/api/ec/pay/order"
//商城-支付结果上报
#define EC_PAY_RESULT_URL               @"/api/ec/pay/result"
//模糊查询小区名
#define COMMUNITY_SEARCH_URL            @"/i/v1/community/search"
//小区单元-房间列表
#define COMMUNITY_UNITS_HOUSES_URL      @"/i/v1/community/units_houses"
//商城-支付宝订单信息
#define ALIPAY_ORDER_INFO_URL           @"/api/ec/pay/alipay/orderInfo"
//商城-关注商品
#define EC_PRODUCT_FAVOR_URL(productId)   DynamicSepUrl(@"/api/ec/products/",productId,@"/favor")
//商城-银联订单信息
#define EC_PAY_UP_ORDERINFO_URL         @"/api/ec/pay/up/orderInfo"
//商城-是否开放
#define EC_CITYS_ISOPEN_URL             @"/api/ec/citys/isOpen"
//商城-开放城市列表
#define EC_CITYS_OPENS_URL              @"/api/ec/citys/opens"

//大社区-用户注册-获取短信验证码
#define USERS_REGISTRATION_VCODE_URL    @"/i/v1/users/registration/vcode"
//城市-用户所在城市 (可以去掉，已改成本地映射表的方式CityMappingTableview)
#define CITYS_GPS_URL                   @"/i/v1/citys/gps"
//大社区-用户注册-手机号
#define USERS_REGISTRATION_PHONE_URL    @"/i/v1/users/registration/phone"
//大社区-用户注册-密码
#define USERS_SETTINGS_PASSWORD_URL     @"/i/v1/users/settings/password"

//大众点评
//获取支持商户搜索的最新分类列表 获取支持商户搜索的最新分类列表
#define DZDP_GET_CATEGORIES_WITH_BUSINESSES  @"/metadata/get_categories_with_businesses"
// 搜索商户 按照地理位置、商区、分类、关键词等多种条件获取商户信息列表
#define DZDP_FIND_BUSINESSES  @"/business/find_businesses"

#endif
