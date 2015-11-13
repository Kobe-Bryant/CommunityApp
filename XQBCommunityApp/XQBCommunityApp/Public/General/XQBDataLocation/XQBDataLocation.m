//
//  XQBDataLocation.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBDataLocation.h"
#import "Global.h"


static XQBDataLocation *_instance = nil;
@interface XQBDataLocation ()


@end

@implementation XQBDataLocation

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
};

- (instancetype)init{
    self = [super init];
    if (self) {
        _pcList = [[NSMutableArray alloc] init];
        [self requestDataLocation];
        
        
    }
    return self;
}

- (void)requestDataLocation{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [manager GET:API_CITY_PCS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //XQBLog(@"\nresponseObject:%@", responseObject);
        if ([[responseObject objectForKey:XQB_NETWORK_ERROR_CODE] isEqualToString:XQB_NETWORK_ERROR_CODE_OK]) {
            XQBLog(@"获取省市列表成功");
            NSMutableArray *pcArray = [responseObject objectForKey:XQB_NETWORK_DATA];
            for (NSDictionary *pDic in pcArray) {
                
                ProvinceModel *pModel = [[ProvinceModel alloc] init];
                pModel.name = [pDic objectForKey:@"name"];
                NSArray *cityArray = [pDic objectForKey:@"cities"];
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *cityDic in cityArray) {
                    CityModel *cityModel = [[CityModel alloc] init];
                    pModel.pid = [[cityDic objectForKey:@"pid"] stringValue];
                    cityModel.pid = [[cityDic objectForKey:@"pid"] stringValue];
                    cityModel.cityId = [[cityDic objectForKey:@"id"] stringValue];
                    cityModel.leavel = [[cityDic objectForKey:@"leavel"] stringValue];
                    cityModel.cityName = [cityDic objectForKey:@"name"];
                    cityModel.zipcode = [cityDic objectForKey:@"zipcode"];
                    
                    [array addObject:cityModel];
                }
                pModel.cities = array;
                [_pcList addObject:pModel];
            }
        } else {
            //加载服务器异常界面
            XQBLog(@"服务器异常");
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //加载网络异常界面
        XQBLog(@"网络异常Error:%@", error);
    }];
}

@end
