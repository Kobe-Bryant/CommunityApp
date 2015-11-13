//
//  XQBECBuyingOrderViewController.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/17.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

typedef NS_ENUM(NSInteger, BuyingOrderVCEntance) {
    EntanceFromProductDetail = 0,
    EntanceFromCart = 1,
};

#import "XQBBaseViewController.h"

@interface XQBECBuyingOrderViewController : XQBBaseViewController

@property (nonatomic, assign) BuyingOrderVCEntance entance;

#pragma mark --- 从购物车入口进入需要传的值，其他入口不用传
@property (nonatomic, strong) NSMutableArray *productItemIDsArray;
#pragma mark --- 从商品详情入口进入需要传的值，其他入口不用传
@property (nonatomic, strong) NSString *productItemID;
@property (nonatomic, strong) NSString *itemNumber;
@end
