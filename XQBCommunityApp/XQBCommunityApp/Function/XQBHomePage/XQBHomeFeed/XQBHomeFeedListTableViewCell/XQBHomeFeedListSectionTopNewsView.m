//
//  XQBHomeFeedListSectionTopNewsView.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/12.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBHomeFeedListSectionTopNewsView.h"
#import "Global.h"

#define FEED_LIST_CONTENT_WIDTH         270

@implementation XQBHomeFeedListSectionTopNewsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _feedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, FEED_LIST_CONTENT_WIDTH, 150)];
        
        [self addSubview:_feedImageView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_feedImageView.frame)-20, FEED_LIST_CONTENT_WIDTH, 20)];
        _textLabel.backgroundColor = [UIColor blackColor];
        _textLabel.alpha = 0.7;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = XQBFontContent;
        [self addSubview:_textLabel];
        
    }
    return self;
}

@end
