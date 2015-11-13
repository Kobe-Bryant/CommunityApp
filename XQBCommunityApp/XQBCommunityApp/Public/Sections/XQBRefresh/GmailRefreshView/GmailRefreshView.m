//
//  GmailRefreshView.m
//  PullRefreshControl
//
//  Created by City-Online on 14/12/17.
//  Copyright (c) 2014年 YDJ. All rights reserved.
//

#import "GmailRefreshView.h"

@interface GmailRefreshView ()

@property (nonatomic, strong) GmailLikeLoadingView *gmailLoadingView;

@end

@implementation GmailRefreshView

- (void)dealloc{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _gmailLoadingView=[[GmailLikeLoadingView alloc] initWithFrame:CGRectMake(frame.size.width/2-15, frame.size.height/2+15, 30, 30)];
        [self addSubview:_gmailLoadingView];
    }
    return self;
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
    [_gmailLoadingView startAnimating];
}
///结束
- (void)finishRefreshing{
    [_gmailLoadingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.5];
    
}



@end
