//
//  XQBLginViewController.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/3.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBBaseNavigationController.h"
#import "XQBBaseViewController.h"
#import "FXBlurView.h"

@interface XQBLginViewController : XQBBaseViewController

@property (nonatomic)  BOOL hiddenDismissButton;
@property (nonatomic, strong) FXBlurView *blurView;

- (void)reset;

- (void)showWithAnimation:(BOOL)animation;

- (void)dismiss;

- (void)dismissWithAnimation:(BOOL)animation;

@end
