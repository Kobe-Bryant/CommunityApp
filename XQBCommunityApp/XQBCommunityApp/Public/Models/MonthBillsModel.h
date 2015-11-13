//
//  MonthBillsModel.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/12.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthBillsModel : NSObject

@property (nonatomic, strong) NSString *year;           //年份
@property (nonatomic, strong) NSString *month;          //月份
@property (nonatomic, strong) NSString *isNeedPay;      //是否需要缴费
@property (nonatomic, strong) NSString *totalMoney;     //账单合计
@property (nonatomic, strong) NSString *needPayMoney;   //待缴费用

@property (nonatomic, strong) NSMutableArray *myBills;  //动态列表

@end
