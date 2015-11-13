//
//  ECProductItemModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/16.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ECProductItemModel : NSObject

@property (nonatomic, strong) NSString *productItemId;  //该规格商品的Id
@property (nonatomic, strong) NSString *measure;        //规格
@property (nonatomic, strong) NSString *unit;           //单位
@property (nonatomic, strong) NSString *price;          //价格
@property (nonatomic, strong) NSString *oldPrice;       //原价
@property (nonatomic, strong) NSString *stockCount;     //库存量
@property (nonatomic, strong) NSString *favorNumber;    //关注数量
@property (nonatomic) BOOL isProductDefault;            //是否默认规格
@property (nonatomic, strong) NSString *discount;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) NSUInteger selectedCount;

@end
