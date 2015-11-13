//
//  XQBMeHeaderMenuView.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/3.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeHeaderMenuView.h"
#import "Global.h"

#define MENU_ITEM_WIDTH     80
#define MENU_ITME_HEIGHT    80

@implementation XQBMeHeaderMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XQBColorBackground;
        
        _myNoticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _myNoticeButton.frame = CGRectMake(0, 0, MENU_ITEM_WIDTH, MENU_ITME_HEIGHT);
        [_myNoticeButton setImage:[UIImage imageNamed:@"me_notification_button.png"] forState:UIControlStateNormal];
        [_myNoticeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_myNoticeButton setTitle:@"我的通知" forState:UIControlStateNormal];
        _myNoticeButton.backgroundColor = [UIColor whiteColor];
        _myNoticeButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_myNoticeButton setImageEdgeInsets:UIEdgeInsetsMake(-20, 18, 0, 0)];
        [_myNoticeButton setTitleEdgeInsets:UIEdgeInsetsMake(45, -33, 0, 0)];
        [self addSubview:_myNoticeButton];
        
        _myOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _myOrderButton.frame = CGRectMake(MENU_ITEM_WIDTH*1, 0, MENU_ITEM_WIDTH, MENU_ITME_HEIGHT);
        [_myOrderButton setImage:[UIImage imageNamed:@"me_order_button.png"] forState:UIControlStateNormal];
        [_myOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_myOrderButton setTitle:@"闪购订单" forState:UIControlStateNormal];
        _myOrderButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _myOrderButton.backgroundColor = [UIColor whiteColor];
        [_myOrderButton setImageEdgeInsets:UIEdgeInsetsMake(-20, 18, 0, 0)];
        [_myOrderButton setTitleEdgeInsets:UIEdgeInsetsMake(45, -33, 0, 0)];
        [self addSubview:_myOrderButton];
        
        
        _inviteJoinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteJoinButton.frame = CGRectMake(MENU_ITEM_WIDTH*2, 0, MENU_ITEM_WIDTH, MENU_ITME_HEIGHT);
        [_inviteJoinButton setImage:[UIImage imageNamed:@"me_invite_reg_button.png"] forState:UIControlStateNormal];
        [_inviteJoinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_inviteJoinButton setTitle:@"邀请注册" forState:UIControlStateNormal];
        _inviteJoinButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _inviteJoinButton.backgroundColor = [UIColor whiteColor];
        [_inviteJoinButton setImageEdgeInsets:UIEdgeInsetsMake(-20, 18, 0, 0)];
        [_inviteJoinButton setTitleEdgeInsets:UIEdgeInsetsMake(45, -33, 0, 0)];
        [self addSubview:_inviteJoinButton];
        
        _myBillButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _myBillButton.frame = CGRectMake(MENU_ITEM_WIDTH*3, 0, MENU_ITEM_WIDTH, MENU_ITME_HEIGHT);
        [_myBillButton setImage:[UIImage imageNamed:@"me_bill_button.png"] forState:UIControlStateNormal];
        [_myBillButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_myBillButton setTitle:@"物业账单" forState:UIControlStateNormal];
        _myBillButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _myBillButton.backgroundColor = [UIColor whiteColor];
        [_myBillButton setImageEdgeInsets:UIEdgeInsetsMake(-20, 18, 0, 0)];
        [_myBillButton setTitleEdgeInsets:UIEdgeInsetsMake(45, -33, 0, 0)];
        [self addSubview:_myBillButton];
        
        [self addSubview:[self verticalSeparationLine:1]];
        [self addSubview:[self verticalSeparationLine:2]];
        [self addSubview:[self verticalSeparationLine:3]];
        
        UIView *horLine = [[UIView alloc] initWithFrame:CGRectMake(0, 80-0.5, WIDTH(self), 0.5)];
        horLine.backgroundColor = XQBColorElementSeparationLine;
        [self addSubview:horLine];
        
    }
    return self;
}


- (UIView *)verticalSeparationLine:(NSInteger)index{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(MENU_ITEM_WIDTH*index, 10, 0.5, 60)];
    view.backgroundColor = XQBColorInternalSeparationLine;
    
    return view;
}

@end
