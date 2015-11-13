//
//  XQBMeForgotPasswordStepThreeViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/8.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeForgotPasswordStepThreeViewController.h"
#import "Global.h"

@interface XQBMeForgotPasswordStepThreeViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *playButton;

@end

@implementation XQBMeForgotPasswordStepThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //自适应iOS的导航栏、状态栏
    [self adjustiOS7NaviagtionBar];
    [self setNavigationTitle:@"注册"];
    
    //自定义返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBackBarButtonItem:backButton];
    
    self.view.backgroundColor = XQBColorBackground;
    
    //右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:XQBColorGreen forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(280,0,70,44);
    [self setRightBarButtonItem:rightBtn];
    
    
    [self.view addSubview:self.headerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UI
- (UIView *)headerView
{
//    if (_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 187)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *registerSuccessButton = [[UIButton alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 0, MainWidth-XQBMarginHorizontal*2, 82)];
        [registerSuccessButton setTitle:@"   恭喜您，重置密码成功!" forState:UIControlStateNormal];
        [registerSuccessButton.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [registerSuccessButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
        [registerSuccessButton setImage:[UIImage imageNamed:@"user_agreement.png"] forState:UIControlStateNormal];
        [registerSuccessButton setUserInteractionEnabled:NO];
        [_headerView addSubview:registerSuccessButton];
        
        UILabel *systemCertificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 82, MainWidth-XQBMarginHorizontal*2, 17)];
        systemCertificationLabel.text = @"请妥善保管好您的密码";
        systemCertificationLabel.textColor = XQBColorContent;
        systemCertificationLabel.textAlignment = NSTextAlignmentCenter;
        systemCertificationLabel.font = [UIFont systemFontOfSize:17.0f];
        [_headerView addSubview:systemCertificationLabel];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 131.5-0.5, MainWidth, 0.5)];
        lineView1.backgroundColor = XQBColorElementSeparationLine;
        [_headerView addSubview:lineView1];
        
        UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 131.5, MainWidth, XQBSpaceVerticalElement)];
        spaceView1.backgroundColor = XQBColorBackground;
        [_headerView addSubview:spaceView1];
        
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 131.5+XQBSpaceVerticalElement, MainWidth, 40)];
        [_playButton setTitle:@"玩转小区宝" forState:UIControlStateNormal];
        [_playButton setTitleColor:XQBColorGreen forState:UIControlStateNormal];
        _playButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_playButton];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 172+XQBSpaceVerticalElement-0.5, MainWidth, 0.5)];
        lineView2.backgroundColor = XQBColorElementSeparationLine;
        [_headerView addSubview:lineView2];
    
    return _headerView;
}

#pragma mark --- action
- (void)rightBtnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)playButtonAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.tabBarController.selectedIndex = 0;
    
}
@end
