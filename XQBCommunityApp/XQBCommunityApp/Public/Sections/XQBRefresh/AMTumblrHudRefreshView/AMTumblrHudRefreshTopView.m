//
//  AMTumblrHudRefreshTopView.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 15/1/16.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "AMTumblrHudRefreshTopView.h"

@interface AMTumblrHudRefreshTopView()

@property (nonatomic, strong) AMTumblrHud *tumblrHUD;

@end


@implementation AMTumblrHudRefreshTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (AMTumblrHud *)tumblrHUD{
    if (!_tumblrHUD) {
        _tumblrHUD = [[AMTumblrHud alloc] initWithFrame:CGRectMake(self.frame.size.width/2-25, self.frame.size.height/2+18, 55, 30)];
        //_tumblrHUD.hudColor = UIColorFromRGB(0xF1F2F3);
        _tumblrHUD.hudColor = [UIColor colorWithRed:75.0/255.0 green:200.0/255.0 blue:160.0/255.0 alpha:1.0];
    }
    return _tumblrHUD;
}

///重新布局
- (void)resetLayoutSubViews{
    
}

///松开可刷新
- (void)canEngageRefresh{
    
}
///松开返回
- (void)didDisengageRefresh{
    
}
///开始刷新
- (void)startRefreshing{
    [self addSubview:self.tumblrHUD];
    [self.tumblrHUD showAnimated:YES];
}
///结束
- (void)finishRefreshing{
    [self.tumblrHUD performSelector:@selector(hide) withObject:nil afterDelay:0.3];
}

@end
