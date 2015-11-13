//
//  AMTumblrHudRefreshTopView.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 15/1/16.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMTumblrHud.h"
#import "RefreshViewDelegate.h"
#import "RefreshControl.h"

@interface AMTumblrHudRefreshTopView : UIView <RefreshViewDelegate>

///重新布局
- (void)resetLayoutSubViews;

///松开可刷新
- (void)canEngageRefresh;
///松开返回
- (void)didDisengageRefresh;
///开始刷新
- (void)startRefreshing;
///结束
- (void)finishRefreshing;

@end
