//
//  XQBPayManager.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBPayManager.h"
#import "Global.h"
#import "CommonParameters.h"
#import "Order.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "NSObject_extra.h"

@interface XQBPayManager ()

//@property (nonatomic, strong) CommunityHttpRequest *request;
@property (nonatomic) NSInteger orderId;    //订单Id
@property (nonatomic) NSString *orderPaySn;    //订单编号

@property (nonatomic, strong) NSString *unionPayTn;

@property (nonatomic, strong) NSString *orderPayFee;       //订单金额
@property (nonatomic, strong) NSString *alipayOrderSubject;     //订单标题
@property (nonatomic, strong) NSString *alipayOrderBody;        //订单描述
@property (nonatomic, strong) NSString *alipayOrderNotifyUrl;   //服务器异步通知页面路径

@end

@implementation XQBPayManager

+(instancetype)shareInstance{
    static XQBPayManager *instance = nil;
    if (instance == nil) {
        instance = [[XQBPayManager alloc] init];
    }
    return instance;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPayResultSucceedNotice:) name:kXQBAlipayResultSucceedNotice object:nil];
    }
    return self;
}

- (void)orderUnionPay:(NSString *)orderId{
    if (orderId.length == 0) {
        NSLog(@"银联支付,orderId不能为空");
        return;
    }
    [self requestUniondPayOrderInfo:orderId];
}

- (void)orderAlipay:(NSString *)orderId{
    if (orderId.length == 0) {
        NSLog(@"阿里支付,orderId不能为空");
        return;
    }
    
    [self requestOrderAlipay:orderId];
}

#pragma mark ---network

#pragma mark ---pay

//支付宝支付
- (void)requestOrderAlipay:(NSString *)orderId{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:orderId forKey:@"orderId"];
    [parameters addSignatureKey];
    
    [manager POST:ALIPAY_ORDER_INFO_URL
       parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

           if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]){
               self.orderId = [[responseObject objectForKey:@"orderId"] integerValue];
               self.orderPaySn = [responseObject objectForKey:@"orderSn"];
               self.orderPayFee = [responseObject objectForKey:@"payFee"];
               self.alipayOrderSubject = [responseObject objectForKey:@"subject"];
               self.alipayOrderBody = [responseObject objectForKey:@"body"];
               self.alipayOrderNotifyUrl = [responseObject objectForKey:@"notifyUrl"];
               [self callAlipayPlugIn];
           } else {
               NSLog(@"获取支付宝订单信息失败");
           }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           XQBLog(@"银联签名网络异常");
       }];
}

- (void)requestUniondPayOrderInfo:(NSString *)orderId{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    [parameters setObject:orderId forKey:@"orderId"];
    [parameters addSignatureKey];
    
    [manager POST:EC_PAY_UP_ORDERINFO_URL
       parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           if ([[responseObject objectForKey:NETWORK_RETURN_ERROR_CODE] isEqualToString:NETWORK_RETURN_CODE_S_OK]) {
               self.unionPayTn = DealWithJSONValue([responseObject objectForKey:@"tn"]) ;
               if (self.unionPayTn.length > 0) {
                   [self callunionPayPlugIn:self.unionPayTn];
               }else{
                   [[UIApplication sharedApplication].keyWindow makeCustomToast:@"订单异常"];
               }
           }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           XQBLog(@"银联订单信息请求,网络异常:%@",error);
       }];
}

- (void)reportPayResult:(NSString *)resmg{
    
     if (resmg.length == 0) {
         NSLog(@"支付结果报文为空");
         return;
     }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager shareManager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[CommonParameters getCommonParameters]];
    
    NSString *orderId = [[NSNumber numberWithInteger:self.orderId] stringValue];
    [parameters setObject:orderId forKey:@"orderId"];
    [parameters setObject:resmg forKey:@"reMsg"];
    [parameters addSignatureKey];
    
    [manager POST:EC_PAY_RESULT_URL
       parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
           

       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
       }];

}


- (void)callunionPayPlugIn:(NSString *)reMsg{
    if (reMsg.length == 0) {
        NSLog(@"三要素+签名不合法");
        return;
    }
    NSString * order = reMsg;
    if (self.paymentUnionCallBackBlock) {
        self.paymentUnionCallBackBlock(order);
    }
}

//银联支付后的回调，在支付的委托delegate的类中实现
/*
//银联支付结果回调
- (void) returnWithResult:(NSString *)strResult{
    if (strResult) {
        //上报服务器结果
        if (self.paymentUnionResultBlock) {
            self.paymentUnionResultBlock(strResult);
        }
    }
}
 */

#pragma mark ---alipay

- (void)callAlipayPlugIn{
    
    NSString *alipayScheme = APP_BUNDLEID;
    if (alipayScheme == nil) {
        return;
    }
    NSString* orderSpec = [self getOrderInfo];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if (self.paymentAliResultBlock) {
                self.paymentAliResultBlock(resultDic);
            }
            
        }];
    }
}


-(NSString*)getOrderInfo
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = [NSString stringWithFormat:@"%@",self.orderPaySn];
    order.productName = self.alipayOrderSubject; //商品标题
    order.productDescription = self.alipayOrderBody; //商品描述
    order.amount = self.orderPayFee;//_orderInfoModel.payFee; //商品价格
    order.notifyURL =  self.alipayOrderNotifyUrl; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    return [order description];
    
}

#pragma mark --- notice
- (void)alipayPayResultSucceedNotice:(NSNotification *)notice{

    if (self.paymentAliResultBlock) {
        NSDictionary *resultDic = notice.userInfo;
        self.paymentAliResultBlock(resultDic);
    }
}

@end
