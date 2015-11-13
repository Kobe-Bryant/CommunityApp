//
//  CommunityBuildUnitModel.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/14.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "CommunityBuildUnitModel.h"

@implementation CommunityBuildUnitModel

- (NSMutableArray *)houseNumbers{
    if (!_houseNumbers) {
        _houseNumbers = [[NSMutableArray alloc] init];
    }
    return _houseNumbers;
}

@end
