//
//  UIView+CustomBadge.m
//  CommunityAPP
//
//  Created by Oliver on 14-8-15.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "UIView+CustomBadge.h"

#define CUSTOM_BADGE_TAG 999

@implementation UIView (CustomBadge)

- (void) setCustomBadgeValue: (NSString *) value
{
    [self deleteCustomBadge];
    
    CGRect frame = CGRectMake(self.frame.size.width - 20, 3, 16, 16);
    if ([value isEqualToString:@"0"]) {
        [self deleteCustomBadge];
    } else {
        [self setCustomBadgeValue:value withFrame:frame];
    }
}


- (void) setCustomBadgeValue: (NSString *) value withFrame: (CGRect) frame
{
    [self setCustomBadgeValue:value withFrame:frame withBackgroundColor:[UIColor redColor]];
}

- (void) setCustomBadgeValue: (NSString *) value withFrame: (CGRect) frame withBackgroundColor:(UIColor *)backgroundColor
{
    UIFont *myAppFont = [UIFont systemFontOfSize:frame.size.height-2.0];
    UIColor *myAppFontColor = [UIColor whiteColor];
    UIColor *myAppBackColor = backgroundColor;
    [self setCustomBadgeValue:value withFrame:frame andFont:myAppFont andFontColor:myAppFontColor andBackgroundColor:myAppBackColor];
}


- (void) setCustomBadgeValue: (NSString *) value withFrame: (CGRect) frame andFont: (UIFont *) font andFontColor: (UIColor *) color andBackgroundColor: (UIColor *) backColor;
{
    UILabel *label = [[UILabel alloc] init];
    if ([value isEqualToString:@""]) {
        [label setFrame:CGRectMake(frame.origin.x+frame.size.width/4, frame.origin.y, frame.size.width*3/4, frame.size.height*3/4)];
        label.layer.cornerRadius = frame.size.width*3/8;
    } else {
        [label setFrame:frame];
        label.layer.cornerRadius = frame.size.width/2;
    }
    [label setFont:font];
    [label setText:value];
    [label setTextColor:color];
    [label setBackgroundColor:backColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    
    label.layer.masksToBounds = YES;
    
    [self addSubview:label];
    [label release];

    label.tag = CUSTOM_BADGE_TAG;
}


- (void) deleteCustomBadge
{
    for(UIView *sv in self.subviews)
    {
        if(sv.tag == CUSTOM_BADGE_TAG)
        {
            [sv removeFromSuperview];
            continue;
        }
    }
}


@end
