//
//  XQBCommonButton.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/15.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBCommonButton.h"

@implementation XQBCommonButton

- (void)dealloc{
    self.actionHandleBlock = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(handleClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)handleClicked:(UIButton *)sender{
    if (self.actionHandleBlock) {
        self.actionHandleBlock(self.tag);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
