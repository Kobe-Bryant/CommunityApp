//
//  ProvinceModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/13.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject

@property (nonatomic, strong) NSString *pid;    //省 Id
@property (nonatomic, strong) NSString *name;   //省 名称
@property (nonatomic, strong) NSMutableArray *cities;  //省 下属城市

@end
