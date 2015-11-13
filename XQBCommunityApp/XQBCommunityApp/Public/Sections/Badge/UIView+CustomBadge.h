//
//  UIView+CustomBadge.h
//  CommunityAPP
//
//  Created by Oliver on 14-8-15.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomBadge)

- (void) setCustomBadgeValue: (NSString *) value;

- (void) setCustomBadgeValue: (NSString *) value withFrame: (CGRect) frame;

- (void) setCustomBadgeValue: (NSString *) value withFrame: (CGRect) frame withBackgroundColor:(UIColor *)backgroundColor;

- (void) setCustomBadgeValue: (NSString *) value withFrame: (CGRect) frame andFont: (UIFont *) font andFontColor: (UIColor *) color andBackgroundColor: (UIColor *) backColor;

- (void) deleteCustomBadge;

@end
