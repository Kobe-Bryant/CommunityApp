//
//  XQBTabBarController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/17.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBTabBarController.h"
#import "Global.h"
#import "XQBHomeViewController.h"
#import "XQBConvenienceViewController.h"
#import "XQBElectricalCemmerceViewController.h"
#import "XQBMeViewController.h"
#import "XQBBaseNavigationController.h"
#import "XQBGuidePageView.h"

#define XQB_TABBAR_ICON_HOME    1       //首页是否开放
#define XQB_TABBAR_ICON_CONV    1       //便民是否开放
#define XQB_TABBAR_ICON_XQB     0       //小区宝Icon是否开放
#define XQB_TABBAR_ICON_EC      1       //商城是否开放
#define XQB_TABBAR_ICON_ME      1       //我是否开放


@interface XQBTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UIButton *xqbCenterButton;
@property (nonatomic, strong) XQBGuidePageView *guideView;


@end

@implementation XQBTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.delegate = self;
    NSMutableArray *vcMutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
#if XQB_TABBAR_ICON_HOME
    //首页
    XQBHomeViewController *homeViewController = [[XQBHomeViewController alloc] initWithNibName:nil bundle:nil];
    homeViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tabbar_homepage_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    XQBBaseNavigationController *homeNav = [[XQBBaseNavigationController alloc] initWithRootViewController:homeViewController];
    [vcMutableArray addObject:homeNav];
#endif
    
#if XQB_TABBAR_ICON_CONV
    //便民
    XQBConvenienceViewController *convenienceViewController = [[XQBConvenienceViewController alloc] init];
    convenienceViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"便民" image:[[UIImage imageNamed:@"tabbar_convenience_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_convenience_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    XQBBaseNavigationController *conNav = [[XQBBaseNavigationController alloc] initWithRootViewController:convenienceViewController];
    [vcMutableArray addObject:conNav];
#endif
    
    
#if XQB_TABBAR_ICON_XQB
    //空（小区宝）
    XQBBaseViewController *spaceVC = [[XQBBaseViewController alloc] init];
    XQBBaseNavigationController *spaceNav = [[XQBBaseNavigationController alloc] initWithRootViewController:spaceVC];
    [vcMutableArray addObject:spaceNav];
    
    _xqbCenterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _xqbCenterButton.frame = CGRectMake(0.0, 0.0, 65, 49);
    _xqbCenterButton.backgroundColor = XQBColorGreen;
    [_xqbCenterButton setTitle:@"小区宝" forState:UIControlStateNormal];
    _xqbCenterButton.imageEdgeInsets = UIEdgeInsetsMake(-10, 13, 0, 0);
    _xqbCenterButton.titleEdgeInsets = UIEdgeInsetsMake(35, -29, 0, 0);
    _xqbCenterButton.titleLabel.font = [UIFont systemFontOfSize:10];
    _xqbCenterButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [_xqbCenterButton addTarget:self action:@selector(xqbPopMenuHandle:) forControlEvents:UIControlEventTouchUpInside];
    [_xqbCenterButton setImage:[UIImage imageNamed:@"tabbar_xqb_normal"] forState:UIControlStateNormal];
    [_xqbCenterButton setImage:[UIImage imageNamed:@"tabbar_xqb_normal"] forState:UIControlStateHighlighted];
    [_xqbCenterButton setImage:[UIImage imageNamed:@"tabbar_xqb_normal"] forState:UIControlStateSelected];
    
    [self addCenterView:_xqbCenterButton];
#endif
    
#if XQB_TABBAR_ICON_EC
    //商城
    XQBElectricalCemmerceViewController *ecViewController = [[XQBElectricalCemmerceViewController alloc] init];
    ecViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"闪购" image:[[UIImage imageNamed:@"tabbar_electrice_commerce_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_electrice_commerce_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    XQBBaseNavigationController *ecNav = [[XQBBaseNavigationController alloc] initWithRootViewController:ecViewController];
    [vcMutableArray addObject:ecNav];
#endif
    
#if XQB_TABBAR_ICON_ME
    //我
    XQBMeViewController *meViewController = [[XQBMeViewController alloc] init];
    meViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[[UIImage imageNamed:@"tabbar_me_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar_me_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    XQBBaseNavigationController *meNav = [[XQBBaseNavigationController alloc] initWithRootViewController:meViewController];
    [vcMutableArray addObject:meNav];
#endif

    self.viewControllers = (NSArray *)vcMutableArray;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:XQBColorExplain, NSForegroundColorAttributeName, XQBFontTabbarItem, NSFontAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:XQBColorGreen, NSForegroundColorAttributeName, XQBFontTabbarItem, NSFontAttributeName,nil] forState:UIControlStateSelected];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //读取沙盒数据
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"IsFirstAtVersin: %@", APP_VERSION];
    NSString *value = [setting objectForKey:key];   //value为0表示已经看过引导页了，为空或者其他值是没有看过
    if (![value isEqualToString:@"0"]) {            //如果没有数据
        UIImage *imagePage1 = [UIImage imageNamed:@"guide_page_1.png"];
        UIImage *imagePage2 = [UIImage imageNamed:@"guide_page_2.png"];
        UIImage *imagePage3 = [UIImage imageNamed:@"guide_page_3.png"];
        NSArray *imagesArray = [NSArray arrayWithObjects:imagePage1, imagePage2, imagePage3, nil];
    
        if (Is3_5Inches()) {
            _guideView = [[XQBGuidePageView alloc] initWithImages:imagesArray andMargin:[[UIScreen mainScreen] bounds].size.height*0.05];
        } else {
            _guideView = [[XQBGuidePageView alloc] initWithImages:imagesArray];
        }
    
        [_guideView.startButton addTarget:self action:@selector(startButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_guideView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark ---tab bar
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    /*
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index%3 == 0) {
        [MobClick event:@"um_home_notice" label:@"城市纵横花园-1"];//
    }else if (index%3 == 1){
        [MobClick event:@"um_home_notice" label:@"花园名城-120"];
    }else if (index%3 == 2){
        [MobClick event:@"um_home_notice" label:@"御景水岸-24"];
    }
     */
}

#pragma mark - Navigation
- (void)startButtonHandle:(UIButton *)sender
{
    //写入数据
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"IsFirstAtVersin: %@", APP_VERSION];
    [setting setObject:[NSString stringWithFormat:@"0"] forKey:key];
    [setting synchronize];

    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _guideView.transform = CGAffineTransformMakeTranslation(-WIDTH(_guideView), 0);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             _guideView.transform = CGAffineTransformIdentity;
                             [_guideView removeFromSuperview];
                         }
                     }];
}


- (void)xqbPopMenuHandle:(UIButton *)sender{
    XQBLog();
}

@end
