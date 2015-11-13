//
//  XQBHomeFeedListSectionNormalNewsView.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/12.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBHomeFeedListSectionNormalNewsView.h"
#import "Global.h"

#define FEED_LIST_CONTENT_WIDTH

@implementation XQBHomeFeedListSectionNormalNewsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *sepatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
        sepatorLineView.backgroundColor = XQBColorElementSeparationLine;
        [self addSubview:sepatorLineView];
        
        _feedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 5, 50, 50)];
        [self addSubview:_feedImageView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 210, 50)];
        _textLabel.numberOfLines = 0;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.alpha = 0.7;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = XQBFontContent;
        [self addSubview:_textLabel];
    }
    return self;
}

@end
