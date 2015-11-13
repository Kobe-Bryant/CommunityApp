//
//  XQBMeNavigationController.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/21.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBMeNavigationController.h"
#import "Global.h"
#import "XQBLoginNavigationController.h"

@interface XQBMeNavigationController ()

@property (nonatomic, strong) XQBLoginNavigationController *loginNavViewController;

@end

@implementation XQBMeNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _loginNavViewController = [[XQBLoginNavigationController alloc] init];
    [self addChildViewController:_loginNavViewController];
    [_loginNavViewController setHiddenDismissButton:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![UserModel isLogin]) {
        [_loginNavViewController showInView:self.view withAnimation:NO];
    }else{
        [_loginNavViewController dismissWithAnimation:NO];
    }
}

@end
