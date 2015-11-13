//
//  NSDictionary+JSON.m
//  CommunityAPP
//
//  Created by Stone on 14-7-23.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

-(NSDictionary *)removeNullValues{
    NSMutableDictionary *mutDictionary = [self mutableCopy];
    NSMutableArray *keysToDelete = [NSMutableArray array];
    [mutDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) {
            [keysToDelete addObject:key];
        }
    }];
    [mutDictionary removeObjectsForKeys:keysToDelete];
    return [mutDictionary copy];
}

@end
