//
//  ECOrderDetailModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECOrderDetailModel : NSObject        //对应XQB V1.X(MOOrderModel、DODetailOrderModel)

@property (nonatomic, strong) NSString *orderId;            //订单ID
@property (nonatomic, strong) NSString *orderSn;            //订单编号
@property (nonatomic, strong) NSString *orderStatus;        //订单状态
@property (nonatomic, strong) NSString *payFee;             //订单总金额
@property (nonatomic, strong) NSString *payNote;            //付款方式
@property (nonatomic, strong) NSString *payTime;            //付款时间
@property (nonatomic, strong) NSString *paySn;              //第三方支付单号
@property (nonatomic, strong) NSString *shippingFee;        //运费
@property (nonatomic, strong) NSString *shippingNote;       //配送方式
@property (nonatomic, strong) NSString *shippingSn;         //物流单号
@property (nonatomic, strong) NSString *shippingTime;       //发货时间
@property (nonatomic, strong) NSString *weight;             //总重量
@property (nonatomic, strong) NSString *consignee;          //收货人
@property (nonatomic, strong) NSString *address;            //收货人详细地址
@property (nonatomic, strong) NSString *phone;              //收货人联系电话
@property (nonatomic, strong) NSString *email;              //收货人邮箱
@property (nonatomic, strong) NSString *zipcode;            //收货邮编
@property (nonatomic, strong) NSString *createTime;         //下单时间
@property (nonatomic, strong) NSMutableArray *orderItems;   //订单项

@end
