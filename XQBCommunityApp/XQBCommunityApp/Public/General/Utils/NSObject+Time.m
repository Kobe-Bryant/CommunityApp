//
//  NSObject+Time.m
//  CommunityAPP
//
//  Created by Stone on 14-3-21.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "NSObject+Time.h"

@implementation NSObject (Time)

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}



- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

+(NSString *) getCurrentTime {
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [dateFormatter stringFromDate:nowDate];
    return timeString;
}

+(NSDate *)fromatterDateFromStr:(NSString *)time{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    //inputFormatter.dateStyle = kCFDateFormatterMediumStyle;
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:time];
    
    return inputDate;
}

+ (NSString *)formatterDate:(NSString *)time{
    //Mar 7, 2014 7:03:03 PM
    //[dFormate setDateFormat:@"MM dd, yyyy hh:mm:mma"];
   
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    //inputFormatter.dateStyle = kCFDateFormatterMediumStyle;
    [inputFormatter setDateFormat:@"MMM dd, yyyy HH:mm:ss aa"];
    NSDate *inputDate = [inputFormatter dateFromString:time];
    
    NSDateFormatter *outPutFormatter = [[NSDateFormatter alloc] init];
    [outPutFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [outPutFormatter stringFromDate:inputDate];
    
    return timeString;
}

+(NSDateComponents *)dateComponentsStr:(NSString *)dateStr{
    
    NSDate *date = [NSObject fromatterDateFromStr:dateStr];
    NSDateComponents *dateComponents = nil;
    if (date) {
        dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday fromDate:date];
        
        NSLog(@"year:%d month:%ld day:%ld hour:%ld minute:%ld second:%ld",dateComponents.year,dateComponents.month,dateComponents.day,dateComponents.hour,dateComponents.minute,dateComponents.second);
    }
    
    return dateComponents;
}

+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    
    timeInterval = -timeInterval;
    
    int temp = 0;
    
    NSString *result;
    
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp];
    }
    
    return  result;
    
}

//计算星期
- (int)getMonthWeekday:(CFGregorianDate)date
{
    CFTimeZoneRef tz = CFTimeZoneCopyDefault();
    CFGregorianDate month_date;
    month_date.year=date.year;
    month_date.month=date.month;
    month_date.day=date.day;
    month_date.hour=0;
    month_date.minute=0;
    month_date.second=1;
    return (int)CFAbsoluteTimeGetDayOfWeek(CFGregorianDateGetAbsoluteTime(month_date,tz),tz);
}

+ (NSString *)getYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    
    CFAbsoluteTime	currentTime=CFAbsoluteTimeGetCurrent();
    CFGregorianDate currentSelectDate=CFAbsoluteTimeGetGregorianDate(currentTime,CFTimeZoneCopyDefault());
    currentSelectDate.year = year;
    currentSelectDate.month = month;
    currentSelectDate.day = day;
    
    NSInteger x = [self getMonthWeekday:currentSelectDate];
    NSLog(@"xxxxx =%d", x);
    
    switch (x) {
        case 0:
            return @"星期日";
            break;
        case 1:
            return @"星期一";
            break;
        case 2:
            return @"星期二";
            break;
        case 3:
            return @"星期三";
            break;
        case 4:
            return @"星期四";
            break;
        case 5:
            return @"星期五";
            break;
        case 6:
            return @"星期六";
            break;
        default:
            break;
    }
    return @" ";
}



@end
