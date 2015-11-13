//
//  XQBBaseTabBarController.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/18.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQBBaseTabBarController : UITabBarController

//添加中间的center button
- (void)addCenterView:(UIView *)cneterView;

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

@end
