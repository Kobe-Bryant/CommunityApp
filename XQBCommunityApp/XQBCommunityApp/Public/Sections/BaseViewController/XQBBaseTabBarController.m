//
//  XQBBaseTabBarController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/18.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBBaseTabBarController.h"

@interface XQBBaseTabBarController ()

@end

@implementation XQBBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)addCenterView:(UIView *)cneterView{
    
    CGFloat heightDifference = cneterView.frame.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        cneterView.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = self.tabBar.frame.size.height-cneterView.frame.size.height/2.0;
        cneterView.center = center;
    }
    
    [self.tabBar addSubview:cneterView];
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = button.frame.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = self.tabBar.frame.size.height-button.frame.size.height/2.0;
        button.center = center;
    }
    
    [self.tabBar addSubview:button];
}

@end
