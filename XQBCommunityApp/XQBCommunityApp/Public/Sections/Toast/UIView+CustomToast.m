//
//  UIView+CustomToast.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/2.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "UIView+CustomToast.h"

@implementation UIView (CustomToast)

- (void)makeCustomToast:(NSString *)message
{
    [self makeToast:message duration:0.8 position:CSToastPositionCenter];
}

- (void)makeCustomToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position
{
    [self makeToast:message duration:interval position:position];
}

@end
