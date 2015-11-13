//
//  UIColor+Hex.m
//  ThinkDrive_iOS
//
//  Created by chen ling on 7/17/13.
//  Copyright (c) 2013 RICHINFO. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *) colorWithLongHex:(long) hex;
{
    return [UIColor colorWithLongHex:hex aphla:1.f];
}

+ (UIColor *) colorWithLongHex:(long) hex aphla:(float) aph;
{
    float red = (float) ((hex & 0xFF0000) >> 16) / 255.0 ;
    float green = (float) ((hex & 0xFF00) >> 8) / 255.0;
    float blue = (float) (hex & 0xFF) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:aph];
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    return [UIColor colorWithHexString:color aphla:1.0];
}

+ (UIColor *) colorWithHexString: (NSString *)color aphla:(float) alpha{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
