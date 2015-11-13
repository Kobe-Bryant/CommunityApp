//
//  UIButtonWithImageAndLabel.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/25.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "UIButtonWithImageAndLabel.h"

@implementation UIButtonWithImageAndLabel

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGFloat offset = (self.frame.size.height - self.imageView.frame.size.height - self.titleLabel.frame.size.height)/2;
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2+offset;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = CGRectGetMaxY(self.imageView.frame) + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
