//
//  NSObject+Time.h
//  CommunityAPP
//
//  Created by Stone on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CMSSType)(NSInteger hour,NSInteger minute,NSInteger second);

@interface NSObject (Time)

- (NSDate *)dateFromString:(NSString *)dateString;

- (NSString *)stringFromDate:(NSDate *)date;

//获取当前时间
+(NSString *) getCurrentTime;

//字符串格式时间转成NSDate yyyy-mm-dd HH:mm:ss
+(NSDate *)fromatterDateFromStr:(NSString *)time;

//字符串格式时间转成字符串 yyyy-mm-dd HH:mm:ss
+ (NSString *)formatterDate:(NSString *)time;

/**
 
 * 计算指定时间与当前的时间差
 
 * @param compareDate   某一指定时间
 
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate;

+(NSDateComponents *)dateComponentsStr:(NSString *)dateStr;

/**
 *  任意日期 返回星期X
 *
 *  @param year  年
 *  @param month 月
 *  @param day   日
 *
 *  @return 星期X
 */
+ (NSString *)getYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end
