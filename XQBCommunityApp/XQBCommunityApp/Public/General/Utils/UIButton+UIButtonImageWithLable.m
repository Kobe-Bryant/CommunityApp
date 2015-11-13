//
//  UIButton+UIButtonImageWithLable.m
//  RESwitchExample
//
//  Created by bunsman on 13-11-20.
//  Copyright (c) 2013年 Bunsman. All rights reserved.
//

#import "UIButton+UIButtonImageWithLable.h"

@implementation UIButton (UIButtonImageWithLable)

//UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
- (void) setImage:(UIImage *)image withHorizontalTitle:(NSString *)title leftTitle:(BOOL)left forState:(UIControlState)stateType
{
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    CGSize titleSize = [title sizeWithFont:self.titleLabel.font];
    UIEdgeInsets inset = UIEdgeInsetsMake(0.0, 0.0, 0.0, -titleSize.width);
    if (left) {
        inset = UIEdgeInsetsMake(0.0, -image.size.width * 2 - titleSize.width, 0.0, 0.0);
    }
    [self setTitleEdgeInsets:inset];
    [self setTitle:title forState:stateType];
}


- (void) setImage:(UIImage *)image withVerticalTitle:(NSString *)title topTitle:(BOOL)top  forState:(UIControlState)stateType
{
    
    /*
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self setImage:image forState:stateType];
    [self setTitle:title forState:stateType];
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self setNeedsLayout];
    */

    
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self setImage:image forState:stateType];
    [self setTitle:title forState:stateType];
    NSDictionary *attributes = @{NSFontAttributeName:self.titleLabel.font};
    CGSize titleSize = [title sizeWithAttributes:attributes];
    UIEdgeInsets inset = UIEdgeInsetsMake(0.0, -image.size.width, -(image.size.height + titleSize.height), 0.0);
    if (top) {
        inset = UIEdgeInsetsMake(-(image.size.height + titleSize.height), -image.size.width, 0.0, 0.0);
    }
    [self setTitleEdgeInsets:inset];
    
    NSLog(@"12313");
}

@end
