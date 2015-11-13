//
//  XQBLoginNavigationController.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/19.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBBaseNavigationController.h"

@interface XQBLoginNavigationController : XQBBaseNavigationController

@property (nonatomic)  BOOL hiddenDismissButton;

- (void)showInView:(UIView *)view withAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;


@end
