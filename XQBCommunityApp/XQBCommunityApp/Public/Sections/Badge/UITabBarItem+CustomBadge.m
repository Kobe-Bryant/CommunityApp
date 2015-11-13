//
//  UITabBarItem+CustomBadge.m
//  CityGlance
//
//  Created by Enrico Vecchio on 18/05/14.
//  Copyright (c) 2014 Cityglance SRL. All rights reserved.
//

#import "UITabBarItem+CustomBadge.h"


#define CUSTOM_BADGE_TAG 99


@implementation UITabBarItem (CustomBadge)


-(void) setCustomBadgeValue: (NSString *) value
{
    UIFont *myAppFont = [UIFont systemFontOfSize:10.0];
    UIColor *myAppFontColor = [UIColor whiteColor];
    UIColor *myAppBackColor = [UIColor redColor];
    if ([value isEqualToString:@"0"]) {
        [self deleteCustomBadge];
    } else {
        [self setCustomBadgeValue:value withFont:myAppFont andFontColor:myAppFontColor andBackgroundColor:myAppBackColor];
    }
}



-(void) setCustomBadgeValue: (NSString *) value withFont: (UIFont *) font andFontColor: (UIColor *) color andBackgroundColor: (UIColor *) backColor
{
    
    UIView *v = [self valueForKey:@"view"];
    [self setBadgeValue:value];
    
    // REMOVE PREVIOUS IF
    for(UIView *sv in v.subviews)
    {
        if(sv.tag == CUSTOM_BADGE_TAG)
        {
            [sv removeFromSuperview];
            continue;
        }
    }
    
    for(UIView *sv in v.subviews)
    {
        NSString *str = NSStringFromClass([sv class]);
        if([str isEqualToString:@"_UIBadgeView"])
        {
            UILabel *label = [[UILabel alloc] init];
            if ([value isEqualToString:@""]) {
                [label setFrame:CGRectMake(sv.frame.origin.x+2, sv.frame.origin.y, sv.frame.size.width/2, sv.frame.size.height/2)];
            } else {
                [label setFrame:sv.frame];
            }
            [label setFont:font];
            [label setText:value];
            [label setBackgroundColor:backColor];
            [label setTextColor:color];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            label.layer.cornerRadius = label.frame.size.height/2;
            label.layer.masksToBounds = YES;
            
            [v addSubview:label];
            [label release];
            [sv setHidden:YES];
            
            label.tag = CUSTOM_BADGE_TAG;
        }
    }
}

- (void)deleteCustomBadge
{
    UIView *v = [self valueForKey:@"view"];
    // REMOVE PREVIOUS IF
    for(UIView *sv in v.subviews)
    {
        if(sv.tag == CUSTOM_BADGE_TAG)
        {
            [sv removeFromSuperview];
            continue;
        }
    }
}

@end
