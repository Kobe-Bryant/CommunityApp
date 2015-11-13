//
//  CommunityBuildUnitModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/14.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunityHouseModel.h"

@interface CommunityBuildUnitModel : NSObject

@property (nonatomic, strong) NSString *unitName;
@property (nonatomic, strong) NSMutableArray *houseNumbers;

@end
