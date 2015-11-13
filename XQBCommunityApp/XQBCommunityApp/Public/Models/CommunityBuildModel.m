//
//  CommunityBuildModel.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/8.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "CommunityBuildModel.h"

@implementation CommunityBuildModel

- (NSMutableArray *)unitsArray{
    if (!_unitsArray) {
        _unitsArray = [[NSMutableArray alloc] init];
    }
    return _unitsArray;
}

@end
