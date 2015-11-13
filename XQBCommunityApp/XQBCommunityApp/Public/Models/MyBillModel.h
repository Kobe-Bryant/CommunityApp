//
//  MyBillModel.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/12.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBillModel : NSObject

@property (nonatomic, strong) NSString *billId;             //id
@property (nonatomic, strong) NSString *title;              //类型        水费、电费、煤气费、其他、物业管理费
@property (nonatomic, strong) NSString *total;              //应付总额
@property (nonatomic, strong) NSString *billStatus;         //状态         已缴费、待缴、 逾期
@property (nonatomic, strong) NSString *billStartTime;      //开始时间
@property (nonatomic, strong) NSString *billEndTime;        //结束时间
@property (nonatomic, strong) NSString *moneyOne;           //本期费用
@property (nonatomic, strong) NSString *oldArrears;         //上期欠费累计
@property (nonatomic, strong) NSString *oldReadings;        //上期读数
@property (nonatomic, strong) NSString *readings;           //读数
@property (nonatomic, strong) NSString *price;              //单价
@property (nonatomic, strong) NSString *count;              //本期使用数量
@property (nonatomic, strong) NSString *unit;               //单位
@property (nonatomic, strong) NSString *damage;             //毁约金累计

@end
