//
//  SortAlphabeticallyDic.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/1.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "SortAlphabeticallyDic.h"

@implementation SortAlphabeticallyDic

+ (NSArray *)SortDicReturnKeyArray:(NSDictionary *)sortedDic
{
    //获取key的arry
    NSMutableArray *keyArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in sortedDic) {
        [keyArray addObject:key];
    }
    
    //对keyArray排序
    //调用字符串数组排序方法
    NSArray *resultKeyArray = [keyArray sortedArrayUsingComparator:[self sortAlphabetically]];
    
    return resultKeyArray;
}

+ (NSArray *)SortDicReturnObjectArray:(NSDictionary *)sortedDic
{
    //获取object的arry
    NSMutableArray *objectArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in sortedDic) {
        [objectArray addObject:sortedDic[key]];
    }
    
    //对objectArray排序
    //调用字符串数组排序方法
    NSArray *resultKeyArray = [objectArray sortedArrayUsingComparator:[self sortAlphabetically]];
    
    return resultKeyArray;
}


+ (NSArray *)SortDicReturnKeyAndObjectArray:(NSDictionary *)sortedDic
{
    //获取key的arry
    NSMutableArray *keyArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in sortedDic) {
        [keyArray addObject:key];
    }
    
    //对keyArray排序
    //调用字符串数组排序方法
    NSArray *resultKeyArray = [keyArray sortedArrayUsingComparator:[self sortAlphabetically]];
    
    //拼接key+object的Array（以key的排序为基准）
    NSMutableArray *resultKeyAndObjectArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *keyString in resultKeyArray) {
        [resultKeyAndObjectArray addObject:[NSString stringWithFormat:@"%@%@", keyString, [sortedDic objectForKey:keyString]]];
    }
    
    return resultKeyAndObjectArray;
}


//排序规则
+ (NSComparator)sortAlphabetically
{
    //设定字符串数组排序选项
    NSStringCompareOptions comparisonOptions = NSLiteralSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch ;
    
    //设定字符串数组排序的方法
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    
    return sort;
}

@end
