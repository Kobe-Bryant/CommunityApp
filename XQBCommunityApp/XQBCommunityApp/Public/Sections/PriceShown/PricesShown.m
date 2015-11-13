//
//  PricesShown.m
//  CommunityAPP
//
//  Created by Oliver on 14-10-8.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "PricesShown.h"

@implementation PricesShown

+ (NSString *)priceOfShorthand:(double)doublePrice
{
    return [NSString stringWithFormat:@"￥%.2f", doublePrice];
}

@end
