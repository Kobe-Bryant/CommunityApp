//
//  XQBPathHeaderBottomView.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/3.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBPathHeaderBottomView.h"

@implementation XQBPathHeaderBottomView

- (void)dealloc{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"me_top_background.png"];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
    }
    return self;
}

@end
