//
//  ECPLVHeaderSpaceReusableView.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "ECPLVHeaderSpaceReusableView.h"
#import "XQBUIFormatMacros.h"

@implementation ECPLVHeaderSpaceReusableView

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
    }
    return self;
}

@end
