//
//  ECOrderInfoModel.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/17.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShippingAddressModel.h"

static NSString *ECOIShippingFee        = @"shippingFee";
static NSString *ECOIPayFee             = @"payFee";
static NSString *ECOIShippingAddress    = @"shippingAddress";
static NSString *ECOIProductItems       = @"productItems";

@interface ECOrderInfoModel : NSObject      //对应XQB V1.X(ECOrderInfoModel)

@property (nonatomic, strong) NSString *shippingFee;            //运费
@property (nonatomic, strong) NSString *payFee;                 //订单金额

@property (nonatomic, strong) ShippingAddressModel *shippingAddress;    //收货地址
@property (nonatomic, strong) NSMutableArray *productItems;             //购买商品


@end
