//
//  CityModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/13.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic, strong) NSString *cityId;     //城市 Id
@property (nonatomic, strong) NSString *pid;        //省 Id
@property (nonatomic, strong) NSString *cityName;   //城市名称
@property (nonatomic, strong) NSString *leavel;     //城市级别
@property (nonatomic, strong) NSString *zipcode;    //编码

@end
