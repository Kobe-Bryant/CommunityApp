//
//  XQBDataLocation.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProvinceModel.h"
#import "CityModel.h"

@interface XQBDataLocation : NSObject

@property (nonatomic, strong) NSMutableArray *pcList;

+ (instancetype)shareInstance;

@end
