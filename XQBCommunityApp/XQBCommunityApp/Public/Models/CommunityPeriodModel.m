//
//  CommunityPeriodModel.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/8.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "CommunityPeriodModel.h"

@implementation CommunityPeriodModel

- (NSMutableArray *)builds{
    if (!_builds) {
        _builds = [[NSMutableArray alloc] init];
    }
    return _builds;
}

@end
