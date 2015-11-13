//
//  UILabel+DiscountShow.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/15.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "UILabel+DiscountShow.h"

@implementation UILabel (DiscountShow)

- (void)setDiscount:(NSString *)discount
{
    
    if (1 <= [discount doubleValue] && [discount doubleValue] < 10) {
        self.hidden = NO;
        self.text = [NSString stringWithFormat:@"%@折", discount];
    } else if (0 < [discount doubleValue] && [discount doubleValue] < 1){
        self.hidden = NO;
        self.text = @"<1折";
    } else {
        self.hidden = YES;
        self.text = @"";
    }
}

@end
