//
//  CityMappingTable.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/25.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityMappingTable : NSObject

+ (instancetype)shareInstance;

- (NSString *)getCityId:(NSString *)cityString;

@end
