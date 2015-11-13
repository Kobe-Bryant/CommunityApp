//
//  ShippingAddressModel.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/17.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *SAShippingAddressId    = @"id";
static NSString *SAConsignee            = @"consignee";
static NSString *SAAddress              = @"address";
static NSString *SAPhone                = @"phone";
static NSString *SAZipCode              = @"zipcode";
static NSString *SAEmail                = @"email";
static NSString *SAProvince             = @"province";
static NSString *SACity                 = @"city";
static NSString *SAArea                 = @"district";
static NSString *SAPcd                  = @"pcd";
static NSString *SAIsDefault            = @"isDefault";

@interface ShippingAddressModel : NSObject

@property (nonatomic, strong) NSString *shippingAddressId;
@property (nonatomic, strong) NSString *consignee;          //收货人
@property (nonatomic, strong) NSString *address;            //地址
@property (nonatomic, strong) NSString *phone;              //电话
@property (nonatomic, strong) NSString *zipCode;            //邮编
@property (nonatomic, strong) NSString *email;              //邮箱
@property (nonatomic, strong) NSString *province;           //省id
@property (nonatomic, strong) NSString *city;               //市id
@property (nonatomic, strong) NSString *area;               //区域id
@property (nonatomic, strong) NSString *pcd;                //表示省市区的地址
@property (nonatomic, strong) NSString *isDefault;          //是否默认

@end
