//
//  SortAlphabeticallyDic.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/1.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortAlphabeticallyDic : NSObject

+ (NSArray *)SortDicReturnKeyArray:(NSDictionary *)sortedDic;               //对参数进行字典排序，返回key的数组

+ (NSArray *)SortDicReturnObjectArray:(NSDictionary *)sortedDic;            //对参数进行字典排序，返回object的数组

+ (NSArray *)SortDicReturnKeyAndObjectArray:(NSDictionary *)sortedDic;      //对参数进行字典排序，返回key+object的数组（以key的排序为基准）


@end
