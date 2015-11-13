//
//  GmailRefreshView.h
//  PullRefreshControl
//
//  Created by City-Online on 14/12/17.
//  Copyright (c) 2014年 YDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GmailLikeLoadingView.h"
#import "RefreshViewDelegate.h"
#import "RefreshControl.h"

@interface GmailRefreshView : UIView<RefreshViewDelegate>

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
