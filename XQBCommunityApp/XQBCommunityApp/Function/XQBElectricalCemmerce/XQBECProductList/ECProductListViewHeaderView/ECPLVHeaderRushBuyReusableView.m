//
//  ECPLVHeaderRushBuyReusableView.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "ECPLVHeaderRushBuyReusableView.h"
#import "XQBUIFormatMacros.h"

static const CGFloat kHeaderAdHight         = 150.0f;
static const CGFloat kHeaderItemHight       = 35.0f;
static const CGFloat kHorizontalMargin      = 14.0f;


@implementation ECPLVHeaderRushBuyReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _adsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, kHeaderAdHight)];
        [self addSubview:_adsView];
        
        
        _rushBuyHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderAdHight, MainWidth, kHeaderItemHight+XQBSpaceVerticalElement)];
        
        UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 0.5)];
        lineView0.backgroundColor = XQBColorInternalSeparationLine;
        [_rushBuyHeaderView addSubview:lineView0];
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, XQBSpaceVerticalElement)];
        spaceView.backgroundColor = XQBColorBackground;
        [_rushBuyHeaderView addSubview:spaceView];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, XQBSpaceVerticalElement-0.5, MainWidth, 0.5)];
        lineView1.backgroundColor = XQBColorInternalSeparationLine;
        [_rushBuyHeaderView addSubview:lineView1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHorizontalMargin, XQBSpaceVerticalElement, 50, kHeaderItemHight)];
        titleLabel.text = @"限时抢购";
        titleLabel.font = [UIFont systemFontOfSize:12.0f];
        titleLabel.textColor = XQBColorContent;
        [_rushBuyHeaderView addSubview:titleLabel];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+10, (kHeaderItemHight-20)/2+XQBSpaceVerticalElement, 18, 20)];
        iconView.image = [UIImage imageNamed:@"watch_icon"];
        [_rushBuyHeaderView addSubview:iconView];
        
        [_rushBuyHeaderView addSubview:self.timeView];
        _timeView.frame = CGRectMake(iconView.frame.origin.x+iconView.frame.size.width+10, XQBSpaceVerticalElement+(kHeaderItemHight-15)/2, 80, 15);
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeView.frame.origin.x+_timeView.frame.size.width+10, XQBSpaceVerticalElement, 60, kHeaderItemHight)];
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        _dateLabel.textColor = XQBColorExplain;
        [_rushBuyHeaderView addSubview:_dateLabel];
        
        _rushBuyStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth-kHorizontalMargin-60, XQBSpaceVerticalElement, 60, kHeaderItemHight)];
        _rushBuyStatusLabel.font = [UIFont systemFontOfSize:12.0f];
        _rushBuyStatusLabel.textAlignment = NSTextAlignmentRight;
        [_rushBuyHeaderView addSubview:_rushBuyStatusLabel];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, XQBSpaceVerticalElement+kHeaderItemHight-0.5, MainWidth, 0.5)];
        lineView2.backgroundColor = XQBColorInternalSeparationLine;
        [_rushBuyHeaderView addSubview:lineView2];
        
        [self addSubview:_rushBuyHeaderView];
    }
    return self;
}

- (CMSSTimerView *)timeView{
    if (!_timeView) {
        _timeView = [[CMSSTimerView alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
    }
    
    return _timeView;
    
}

- (CMSSCountTimer *)countTimer{
    if (!_countTimer) {
        _countTimer = [[CMSSCountTimer alloc] init];
        
    }
    
    return _countTimer;
}

@end
