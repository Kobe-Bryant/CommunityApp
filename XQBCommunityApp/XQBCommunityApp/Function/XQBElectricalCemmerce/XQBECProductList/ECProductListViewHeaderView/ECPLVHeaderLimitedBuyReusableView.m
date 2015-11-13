//
//  ECPLVHeaderLimitedBuyReusableView.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "ECPLVHeaderLimitedBuyReusableView.h"
#import "XQBUIFormatMacros.h"

static const CGFloat kHeaderItemHight       = 35.0f;
static const CGFloat kHorizontalMargin      = 14.0f;

@implementation ECPLVHeaderLimitedBuyReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBSpaceVerticalElement)];
        spaceView.backgroundColor = XQBColorBackground;
        
        UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 0.5)];
        lineView0.backgroundColor = XQBColorInternalSeparationLine;
        [spaceView addSubview:lineView0];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, XQBSpaceVerticalElement-0.5, MainWidth, 0.5)];
        lineView1.backgroundColor = XQBColorInternalSeparationLine;
        [spaceView addSubview:lineView1];
        
        
        [self addSubview:spaceView];

        
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, XQBSpaceVerticalElement, MainWidth, kHeaderItemHight)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHorizontalMargin, 0, 50, kHeaderItemHight)];
        titleLabel.text = @"特价商品";
        titleLabel.font = [UIFont systemFontOfSize:12.0f];
        titleLabel.textColor = XQBColorContent;
        [itemView addSubview:titleLabel];

        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+10, (kHeaderItemHight-13)/2, 33, 13)];
        iconView.image = [UIImage imageNamed:@"sale_icon"];
        [itemView addSubview:iconView];

        
        UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth-kHorizontalMargin-14, (kHeaderItemHight-14)/2, 14, 14)];
        accessoryView.image = [UIImage imageNamed:@"arrow_right_icon.png"];
        [itemView addSubview:accessoryView];

        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderItemHight-0.5, MainWidth, 0.5)];
        lineView.backgroundColor = XQBColorInternalSeparationLine;
        [itemView addSubview:lineView];

        
        [self addSubview:itemView];
    }
    return self;
}

@end
