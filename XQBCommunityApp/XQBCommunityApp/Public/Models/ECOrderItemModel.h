//
//  ECOrderItemModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *MOOIProductId     = @"productId";
static NSString *MOOIProductItemId = @"productItemId";
static NSString *MOOIProductName   = @"productName";
static NSString *MOOICover         = @"cover";
static NSString *MOOIMeasure       = @"measure";
static NSString *MOOIUnit          = @"unit";
static NSString *MOOIItemNumber    = @"itemNumber";
static NSString *MOOIPrice         = @"price";

@interface ECOrderItemModel : NSObject      //对应XQB V1.X(MOOrderItemModel)

@property (nonatomic, strong) NSString *productId;      //商品id
@property (nonatomic, strong) NSString *productItemId;  //商品该规格的Id
@property (nonatomic, strong) NSString *productName;    //商品名称
@property (nonatomic, strong) NSString *cover;          //商品图片地址
@property (nonatomic, strong) NSString *measure;        //规格
@property (nonatomic, strong) NSString *unit;           //单位
@property (nonatomic, strong) NSString *itemNumber;     //商品项数量
@property (nonatomic, strong) NSString *price;          //价格

@end
