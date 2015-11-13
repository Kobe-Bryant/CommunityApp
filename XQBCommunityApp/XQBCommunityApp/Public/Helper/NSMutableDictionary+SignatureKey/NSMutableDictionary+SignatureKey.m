//
//  NSMutableDictionary+SignatureKey.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/2.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "NSMutableDictionary+SignatureKey.h"
#import "SortAlphabeticallyDic.h"
#import "NSString+MD5.h"
#import "Macros.h"
#import "AppConfig.h"

@implementation NSMutableDictionary (SignatureKey)

- (void)addSignatureKey
{
    NSArray *keyAndObjectArray = [SortAlphabeticallyDic SortDicReturnObjectArray:self]; //对参数进行字典排序，返回object的数组
    NSMutableString *signatureString = [[NSMutableString alloc] init];                  //声明带有MD5签名的可变字符串
    for (NSString *arrayString in keyAndObjectArray) {                                  //拼接参数数组
        [signatureString appendString:arrayString];
    }
    [signatureString appendString:MD5_SIGNATURE_KEY];                                   //拼接MD5签名
    
    [self setObject:[signatureString uppercaseMd5] forKey:@"signal"];                         //对拼接后的值用MD5加密，并加到字典中
}

@end
