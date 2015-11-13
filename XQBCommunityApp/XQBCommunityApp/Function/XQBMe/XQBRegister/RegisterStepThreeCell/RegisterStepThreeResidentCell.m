//
//  RegisterStepThreeResidentCell.m
//  CommunityAPP
//
//  Created by City-Online-1 on 14/11/14.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "RegisterStepThreeResidentCell.h"
#import "Global.h"

@implementation RegisterStepThreeResidentCell

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
        systemCertificationLabel.text = @"系统自动认证您是：";
        systemCertificationLabel.textColor = XQBColorContent;
        systemCertificationLabel.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:systemCertificationLabel];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 113-0.5, MainWidth-XQBMarginHorizontal*2, 0.5)];
        lineView1.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:lineView1];
        
        _userDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 113, MainWidth-XQBMarginHorizontal*2, 45)];
        _userDescLabel.textColor = XQBColorGreen;
        _userDescLabel.textAlignment = NSTextAlignmentCenter;
        _userDescLabel.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:_userDescLabel];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 158-0.5, MainWidth-XQBMarginHorizontal*2, 0.5)];
        lineView2.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:lineView2];
        
        UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 158, MainWidth-XQBMarginHorizontal*2, 40)];
        welcomeLabel.text = @"将自动在此户登记认证，欢迎您使用小区宝";
        welcomeLabel.font = [UIFont systemFontOfSize:12.0f];
        welcomeLabel.textColor = XQBColorExplain;
        [self addSubview:welcomeLabel];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 198-0.5, MainWidth, 0.5)];
        lineView3.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:lineView3];
    }
    return self;
}

@end
