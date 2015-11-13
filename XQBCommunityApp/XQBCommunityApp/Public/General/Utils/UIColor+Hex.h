//
//  UIColor+Hex.h
//  ThinkDrive_iOS
//
//  Created by chen ling on 7/17/13.
//  Copyright (c) 2013 RICHINFO. All rights reserved.
//

#import <UIKit/UIKit.h>

//16进制颜色
@interface UIColor (Hex)


/**
 *	@brief	返回16进制的颜色
 *
 *	@param 	hex 	0xfffff
 *
 *	@return	返回16进制的颜色
 */
+ (UIColor *) colorWithLongHex:(long)hex;



/**
 *	@brief	返回16进制的颜色
 *
 *	@param 	hex 	0xfffff
 *	@param 	aph 	透明度
 *
 *	@return	返回16进制颜色
 */
+ (UIColor *) colorWithLongHex:(long)hex aphla:(float)aph;

/**
 *  返回RGB的颜色
 *
 *  @param color 16进制的颜色 0xffffff #ffffff
 *
 *  @return 返回RGB的颜色
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

/**
 *  返回RGB的颜色
 *
 *  @param color 16进制的颜色 0xffffff #ffffff
 *
 *  @return 返回RGB的颜色
 */
+ (UIColor *) colorWithHexString: (NSString *)color aphla:(float) alpha;



@end
