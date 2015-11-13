//
//  CommunityPeriodModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/8.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunityBuildModel.h"
#import "CommunityHouseModel.h"

@interface CommunityPeriodModel : NSObject

@property (nonatomic, strong) NSString *periodName;
@property (nonatomic, strong) NSMutableArray *builds;

@end
