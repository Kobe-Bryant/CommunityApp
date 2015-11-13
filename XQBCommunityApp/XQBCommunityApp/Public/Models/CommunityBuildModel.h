//
//  CommunityBuildModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/8.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunityBuildUnitModel.h"

@interface CommunityBuildModel : NSObject

@property (nonatomic, strong) NSString *buildName;
@property (nonatomic, strong) NSMutableArray *unitsArray;

@end
