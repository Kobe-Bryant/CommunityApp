//
//  VersionIntroductionViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 15/1/9.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "VersionIntroductionViewController.h"
#import "Global.h"
#import "XQBGuidePageView.h"

@interface VersionIntroductionViewController ()

@property (nonatomic, strong) XQBGuidePageView *guidePageView;

@end

@implementation VersionIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES];
    
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"版本介绍"];
    
    //自定义返回按钮
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = XQBColorBackground;
    
    
    [self.view addSubview:self.guidePageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backHandle:(UIButton *)sender{
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (XQBGuidePageView *)guidePageView
{
    if (!_guidePageView) {
        UIImage *imagePage1 = [UIImage imageNamed:@"guide_page_1.png"];
        UIImage *imagePage2 = [UIImage imageNamed:@"guide_page_2.png"];
        UIImage *imagePage3 = [UIImage imageNamed:@"guide_page_3.png"];
        NSArray *imagesArray = [NSArray arrayWithObjects:imagePage1, imagePage2, imagePage3, nil];
        
        if (Is3_5Inches()) {
            self.guidePageView = [[XQBGuidePageView alloc] initWithImages:imagesArray andMargin:[[UIScreen mainScreen] bounds].size.height*0.11];
        } else {
            self.guidePageView = [[XQBGuidePageView alloc] initWithImages:imagesArray];
        }
        [_guidePageView.startButton addTarget:self action:@selector(startButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _guidePageView;
}

#pragma mark --- action
- (void)startButtonHandle:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
