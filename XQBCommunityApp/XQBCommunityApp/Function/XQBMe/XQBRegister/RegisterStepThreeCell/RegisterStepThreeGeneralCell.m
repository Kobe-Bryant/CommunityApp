//
//  RegisterStepThreeGeneralCell.m
//  CommunityAPP
//
//  Created by City-Online-1 on 14/11/14.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "RegisterStepThreeGeneralCell.h"
#import "Global.h"

@implementation RegisterStepThreeGeneralCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        UIButton *registerSuccessButton = [[UIButton alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 0, MainWidth-XQBMarginHorizontal*2, 82)];
        [registerSuccessButton setTitle:@"   恭喜您，注册成功!" forState:UIControlStateNormal];
        [registerSuccessButton.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [registerSuccessButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
        [registerSuccessButton setImage:[UIImage imageNamed:@"user_agreement.png"] forState:UIControlStateNormal];
        [registerSuccessButton setUserInteractionEnabled:NO];
        [self addSubview:registerSuccessButton];
        
        UILabel *systemCertificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 82, MainWidth-XQBMarginHorizontal*2, 17)];
        systemCertificationLabel.text = @"您可以完善您的社区身份资料";
        systemCertificationLabel.textColor = XQBColorContent;
        systemCertificationLabel.textAlignment = NSTextAlignmentCenter;
        systemCertificationLabel.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:systemCertificationLabel];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 131.5-0.5, MainWidth, 0.5)];
        lineView1.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:lineView1];
        
        UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 131.5, MainWidth, XQBSpaceVerticalElement)];
        spaceView1.backgroundColor = XQBColorBackground;
        [self addSubview:spaceView1];
        
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 131.5+XQBSpaceVerticalElement, MainWidth, 40)];
        [_playButton setTitle:@"玩转小区宝" forState:UIControlStateNormal];
        [_playButton setTitleColor:XQBColorGreen forState:UIControlStateNormal];
        _playButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:_playButton];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 171.5+XQBSpaceVerticalElement-0.5, MainWidth, 0.5)];
        lineView2.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:lineView2];
        
        UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 171.5+XQBSpaceVerticalElement, MainWidth, XQBSpaceVerticalElement)];
        spaceView2.backgroundColor = XQBColorBackground;
        [self addSubview:spaceView2];
        
        _informationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 171.5+XQBSpaceVerticalElement*2, MainWidth, 40)];
        [_informationButton setTitle:@"去完善资料" forState:UIControlStateNormal];
        [_informationButton setTitleColor:XQBColorExplain forState:UIControlStateNormal];
        _informationButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:_informationButton];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 211.5+XQBSpaceVerticalElement*2-0.5, MainWidth, 0.5)];
        lineView3.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:lineView3];
    }
    return self;
}

@end
