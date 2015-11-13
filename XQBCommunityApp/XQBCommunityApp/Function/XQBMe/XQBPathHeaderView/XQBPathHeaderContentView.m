//
//  XQBPathHeaderContentView.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/3.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBPathHeaderContentView.h"
#import "Global.h"

@implementation XQBPathHeaderContentView

- (void)dealloc{
    
}

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _userIconButton = [[UIButton alloc] initWithFrame:CGRectMake(132, 90, 55, 55)];
        _userIconButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _userIconButton.layer.borderWidth = 3.0f;
        _userIconButton.layer.cornerRadius = 3.0f;
        _userIconButton.backgroundColor = XQBColorDefaultImage;
        [self addSubview:_userIconButton];
        
        _userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_userIconButton.frame), 325, 25)];
        _userInfoLabel.font = [UIFont systemFontOfSize:14];
        _userInfoLabel.backgroundColor = [UIColor clearColor];
        _userInfoLabel.textColor = [UIColor whiteColor];
        _userInfoLabel.shadowColor = [UIColor blackColor];
        _userInfoLabel.shadowOffset = CGSizeMake(0.5, 0.5);
        _userInfoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_userInfoLabel];
        
        _userCommunityInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_userInfoLabel.frame), 225, 20)];
        _userCommunityInfoLabel.font = [UIFont systemFontOfSize:12];
        _userCommunityInfoLabel.backgroundColor = [UIColor clearColor];
        _userCommunityInfoLabel.textColor = [UIColor whiteColor];
        _userCommunityInfoLabel.shadowColor = [UIColor blackColor];
        _userCommunityInfoLabel.shadowOffset = CGSizeMake(0.5, 0.5);
        _userCommunityInfoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_userCommunityInfoLabel];

        
        _editingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editingButton.frame = CGRectMake(14, 274, 140, 36);
        [_editingButton setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        _editingButton.layer.cornerRadius = 3.0f;
        [_editingButton setImage:[UIImage imageNamed:@"me_edit_icon.png"] forState:UIControlStateNormal];
        _editingButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_editingButton setTitle:@"  编辑" forState:UIControlStateNormal];
        [self addSubview:_editingButton];
        
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingButton.frame = CGRectMake(167, 274, 140, 36);
        [_settingButton setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        _settingButton.layer.cornerRadius = 3.0f;
        [_settingButton setImage:[UIImage imageNamed:@"me_setting_icon.png"] forState:UIControlStateNormal];
        _settingButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_settingButton setTitle:@"  设置" forState:UIControlStateNormal];
        [self addSubview:_settingButton];
        
    }
    return self;
}

@end
