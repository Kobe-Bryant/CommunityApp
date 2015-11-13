//
//  CityMappingTable.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/25.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "CityMappingTable.h"

@interface CityMappingTable ()

@property (nonatomic, strong) NSMutableDictionary *cityMappingTableDic;

@end


@implementation CityMappingTable

+ (instancetype)shareInstance
{
    static CityMappingTable *instance = nil;
    if (instance == nil) {
        instance = [[CityMappingTable alloc] init];
    }
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CityMappingTable" ofType:@"txt"];
        NSString *fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [fileString componentsSeparatedByString:@"\n"];
        
        NSMutableArray *objectArray = [[NSMutableArray alloc] init];
        NSMutableArray *keyArray = [[NSMutableArray alloc] init];
        
        for (NSString *lineString in lines) {
            [objectArray addObject:[lineString substringToIndex:6]];                                    //截取是从0开始算的
            [keyArray addObject:[[[lineString substringFromIndex:7]
                                  stringByReplacingOccurrencesOfString:@"\r" withString:@""]            //去掉最后的空白符
                                 stringByReplacingOccurrencesOfString:@"\n" withString:@""]];           //去掉最后的换行符
        }
        
        _cityMappingTableDic = [[NSMutableDictionary alloc] initWithObjects:objectArray forKeys:keyArray];
    }
    return self;
}

- (NSString *)getCityId:(NSString *)cityString
{
    for (NSString *key in _cityMappingTableDic) {
        if ([cityString hasPrefix:key]) {
            return _cityMappingTableDic[key];
        }
    }
    return @"440300";
}

@end
