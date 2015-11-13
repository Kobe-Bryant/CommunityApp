//
//  XQBHomeIconImageWithLable.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/31.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBHomeIconImageWithLable.h"

@implementation XQBHomeIconImageWithLable

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _kImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-40)/2, 10, 40, 40)];
        [self addSubview:_kImageView];
        
        _kLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_kImageView.frame), self.bounds.size.width, 20)];
        _kLabel.textAlignment = NSTextAlignmentCenter;
        _kLabel.backgroundColor = [UIColor clearColor];
        _kLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_kLabel];
    }
    return self;
}

@end
