//
//  CommunityModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/7.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityModel : NSObject

@property (nonatomic, strong) NSString *communityId;
@property (nonatomic, strong) NSString *communityName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) BOOL hasHouse;

@end
