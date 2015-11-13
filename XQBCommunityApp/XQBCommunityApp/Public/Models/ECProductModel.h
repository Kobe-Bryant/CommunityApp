//
//  ECProductModel.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/13.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kXQBProductTagTypeRushBuy            @"RUSH_BUY"
#define kXQBProductTagTypeLimitedBuy         @"LIMITED_BUY"
#define kXQBProductTagTypeNew                @"NEW"
#define kXQBProductTagTypeHot                @"HOT"
#define kXQBProductTagNormal                 @"NORMAL"

typedef NS_ENUM(NSInteger,XQBECProductRushByStatus){
    XQBECProductRushByStatusUnBuying     = -1,          //没开始
    XQBECProductRushByStatusBuying       = 0,           //抢购中
    XQBECProductRushByStatusEnd          = 1,           //已结束
};

@interface ECProductModel : NSObject

@property (nonatomic, strong) NSString *productId;      //商品Id
@property (nonatomic, strong) NSString *name;           //商品名称
@property (nonatomic, strong) NSString *cover;          //商品图片地址
@property (nonatomic, strong) NSString *measure;        //商品规格
@property (nonatomic, strong) NSString *unit;           //单位
@property (nonatomic, strong) NSString *price;          //价格
@property (nonatomic, strong) NSString *oldPrice;       //原价
@property (nonatomic, strong) NSString *stockCount;     //库存量
@property (nonatomic, strong) NSString *isPostFree;     //是否免邮
@property (nonatomic, strong) NSString *createTime;     //创建时间
@property (nonatomic, strong) NSString *sortOrder;      //权重   数字越大越靠前
@property (nonatomic, strong) NSString *favorNumber;    //关注数量
@property (nonatomic, strong) NSString *summary;        //描述
@property (nonatomic, strong) NSString *discount;       //折扣

#pragma mark rush by
@property (nonatomic, strong) NSString *tagType;        //RUSH_BUY：抢购，LIMITED_BUY：限购，NEW：新品，HOT：热卖，NORMAL：正常商品
@property (nonatomic, strong) NSString *rushBuyStart;   //抢购开始时间
@property (nonatomic, strong) NSString *rushBuyEnd;     //抢购结束时间
@property (nonatomic) XQBECProductRushByStatus rushBuyStatus;  //抢购状态  -1，0，1表示抢购未开始，正在进行，已结束
@property (nonatomic, strong) NSString *rushBuyCountDown;          //距抢购结束倒计时（秒）   适用于抢购正在进行
@property (nonatomic, strong) NSString *limitedBuyNumber;          //限购数量





@property (nonatomic, strong) NSMutableArray *images;   //商品展示图
@property (nonatomic, strong) NSString *detailUrl;        //详情的url


@property (nonatomic, strong) NSString *shippingFee;    //运费
@property (nonatomic, strong) NSString *cityName;       //城市名


@property (nonatomic, strong) NSString *measureItemTotalCount;      //规格种类数量

@end
