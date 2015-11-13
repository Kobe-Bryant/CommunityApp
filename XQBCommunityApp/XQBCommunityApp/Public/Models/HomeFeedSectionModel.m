//
//  HomeFeedSectionModel.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/12.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "HomeFeedSectionModel.h"

@implementation HomeFeedSectionModel

- (NSMutableArray *)homeFeedDetails{
    if (!_homeFeedDetails) {
        _homeFeedDetails = [[NSMutableArray alloc] init];
    }
    return _homeFeedDetails;
}

@end
