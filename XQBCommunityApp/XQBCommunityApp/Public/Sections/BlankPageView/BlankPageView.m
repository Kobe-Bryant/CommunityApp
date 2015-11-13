//
//  BlankPageView.m
//  CommunityAPP
//
//  Created by Oliver on 14-10-15.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "BlankPageView.h"
#import "Global.h"

@interface BlankPageView ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *describe;

@end

@implementation BlankPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XQBColorBackground;
        //[self setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-StateBarHeight-NavigationBarHeight)];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, 320, 255);
        [_button setImage:[UIImage imageNamed:@"no_collection.png"] forState:UIControlStateNormal];
        _button.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-70);
        _button.adjustsImageWhenHighlighted = NO;
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, _button.frame.origin.y+_button.frame.size.height+10, SCREEN_WIDTH, 17)];
        [_title setFont:[UIFont systemFontOfSize:17]];
        [_title setTextColor:XQBColorContent];
        [_title setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_title];
        
        _describe = [[UILabel alloc] initWithFrame:CGRectMake(0, _title.frame.origin.y+_title.frame.size.height+10, SCREEN_WIDTH, 12)];
        [_describe setFont:[UIFont systemFontOfSize:12]];
        [_describe setTextColor:XQBColorExplain];
        [_describe setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_describe];
    }
    return self;
}

- (void)resetImage:(UIImage *)image
{
    [_button setImage:image forState:UIControlStateNormal];
}

- (void)resetImageFrame:(CGRect)frame
{
    _button.frame = frame;
}

- (void)resetTitle:(NSString *)title andDescribe:(NSString *)describe
{
    if (title == nil) {
        _title.text = @"";
    }else{
        _title.text = title;
    }
    if (describe == nil) {
        [_describe setText:@""];
    }else{
        [_describe setText:describe];
    }
    
}

- (void)resetTitleFrame:(CGRect)titleFrame andDescribeFrame:(CGRect)describeFrame
{
    _title.frame = titleFrame;
    _describe.frame = describeFrame;
}

- (void)buttonClicked:(UIButton *)sender
{
    // 回调
    if (_blankPageDidClickedBlock) {
        _blankPageDidClickedBlock();
    }
}

@end
