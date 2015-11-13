//
//  XQBLoginNavigationController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/19.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBLoginNavigationController.h"
#import "XQBLginViewController.h"
#import "Global.h"

@interface XQBLoginNavigationController ()

@property (nonatomic, strong) XQBLginViewController *loginViewController;

@end

@implementation XQBLoginNavigationController



- (instancetype)init{
    self = [super initWithRootViewController:self.loginViewController];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (XQBLginViewController *)loginViewController{
    if (!_loginViewController) {
        _loginViewController = [[XQBLginViewController alloc] init];
    }
    return _loginViewController;
}

- (void)showInView:(UIView *)view withAnimation:(BOOL)animation{
    [view addSubview:self.view];
    if (animation) {
        self.view.transform = CGAffineTransformMakeTranslation(0, HEIGHT(self.view));
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.view.transform = CGAffineTransformIdentity;
                             //self.blurView.transform = CGAffineTransformIdentity;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }else{
        self.view.transform = CGAffineTransformIdentity;
    }
}
- (void)dismissWithAnimation:(BOOL)animation{

    if (animation) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.view.transform = CGAffineTransformMakeTranslation(0, HEIGHT(self.view));
                             //self.blurView.transform = CGAffineTransformMakeTranslation(0, HEIGHT(self.blurView));
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 self.view.transform = CGAffineTransformIdentity;
                                 //self.blurView.transform = CGAffineTransformIdentity;
                                 [self.loginViewController reset];
                                 [self.view removeFromSuperview];
                                 //if (self.blurView.superview) {
                                 //    [self.blurView removeFromSuperview];
                                 //}
                             }
                         }];
    }else{
        [self.loginViewController reset];
        [self.view removeFromSuperview];
    }
    
}

- (void)setHiddenDismissButton:(BOOL)hiddenDismissButton{
    [self.loginViewController setHiddenDismissButton:hiddenDismissButton];
}

@end
