//
//  ECCartShoppingModel.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/16.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *ECCSProductId     = @"productId";
static NSString *ECCSProductItemId = @"productItemId";
static NSString *ECCSProductName   = @"productName";
static NSString *ECCSCover         = @"cover";
static NSString *ECCSMeasure       = @"measure";
static NSString *ECCSUnit          = @"unit";
static NSString *ECCSItemNumber    = @"itemNumber";
static NSString *ECCSPrice         = @"price";
static NSString *ECCSOldPrice      = @"oldPrice";
static NSString *ECCSStockCount    = @"stockCount";
static NSString *ECCSFavorNumber   = @"favorNumber";

@interface ECCartShoppingModel : NSObject

@property (nonatomic, strong) NSString *productId;          //商品id
@property (nonatomic, strong) NSString *productItemId;      //商品规格的ID
@property (nonatomic, strong) NSString *productName;        //商品名称
@property (nonatomic, strong) NSString *cover;              //商品图片地址
@property (nonatomic, strong) NSString *measure;            //商品规格
@property (nonatomic, strong) NSString *unit;               //单位
@property (nonatomic, strong) NSString *itemNumber;         //商品项数量
@property (nonatomic, strong) NSString *price;              //单价
@property (nonatomic, strong) NSString *oldPrice;           //原价
@property (nonatomic, strong) NSString *stockCount;         //库存量
@property (nonatomic, strong) NSString *favorNumber;        //关注数量

@end
