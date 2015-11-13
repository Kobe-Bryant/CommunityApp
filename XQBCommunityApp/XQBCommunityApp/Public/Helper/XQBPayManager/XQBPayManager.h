//
//  XQBPayManager.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kXQBAlipayResultSucceedNotice       @"kXQBAlipayResultSucceedNotice"

typedef void(^PaymentPlugInCallBackBlock)(NSString *remsg);
typedef void(^PaymentResultBlock)(NSString *result);
typedef void(^PaymentAliResultBlock)(NSDictionary *result);

@interface XQBPayManager : NSObject

@property (nonatomic, strong) PaymentPlugInCallBackBlock paymentUnionCallBackBlock;
@property (nonatomic, strong) PaymentResultBlock paymentUnionResultBlock;
@property (nonatomic, strong) PaymentPlugInCallBackBlock paymentAliCallBackBlock;
@property (nonatomic, strong) PaymentAliResultBlock paymentAliResultBlock;

- (void)orderUnionPay:(NSString *)orderId;

- (void)orderAlipay:(NSString *)orderId;

@end
