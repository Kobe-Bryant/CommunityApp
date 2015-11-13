//
//  XQBRegisterStepThreeViewController.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/27.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBRegisterStepThreeViewController.h"
#import "Global.h"
#import "RegisterStepThreeLayout.h"
#import "UserModel.h"
#import "RegisterStepThreeResidentCell.h"
#import "RegisterStepThreeGeneralCell.h"
#import "XQBMeSelectCityViewController.h"
#import "XQBLoginNavigationController.h"
#import "XQBTabBarController.h"

@interface XQBRegisterStepThreeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation XQBRegisterStepThreeViewController

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
    
    [self initCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UI
- (void)initCollectionView
{
    RegisterStepThreeLayout* lineLayout = [[RegisterStepThreeLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight) collectionViewLayout:lineLayout];
    
    _collectionView.backgroundColor = XQBColorBackground;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.contentSize = CGSizeMake(MainWidth, MainHeight+10);
    _collectionView.alwaysBounceVertical = YES;
    
    [_collectionView registerClass:[RegisterStepThreeResidentCell class] forCellWithReuseIdentifier:@"RESIDENT_CELL"];
    [_collectionView registerClass:[RegisterStepThreeGeneralCell class] forCellWithReuseIdentifier:@"GENERAL_CELL"];
    
    [self.view addSubview:_collectionView];
}


#pragma mark --- action
- (void)rightBtnAction
{    
    
    if ([self.navigationController isKindOfClass:[XQBLoginNavigationController class]]) {
        XQBLoginNavigationController *navigationController = (XQBLoginNavigationController *)(self.navigationController);
        if ([navigationController respondsToSelector:@selector(dismissWithAnimation:)]) {
            [navigationController dismissWithAnimation:YES];
        }
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)playButtonAction
{
    
    if ([self.navigationController isKindOfClass:[XQBLoginNavigationController class]]) {
        XQBLoginNavigationController *navigationController = (XQBLoginNavigationController *)(self.navigationController);
        if ([navigationController respondsToSelector:@selector(dismissWithAnimation:)]) {
            [(XQBLoginNavigationController*)(self.navigationController) dismissWithAnimation:YES];
        }
    }
    [self.navigationController popToRootViewControllerAnimated:NO];

}

- (void)informationButtonAction
{
    if ([self.navigationController isKindOfClass:[XQBLoginNavigationController class]]) {
        XQBLoginNavigationController *navigationController = (XQBLoginNavigationController *)(self.navigationController);
        if ([navigationController respondsToSelector:@selector(dismissWithAnimation:)]) {
            [(XQBLoginNavigationController*)(self.navigationController) dismissWithAnimation:YES];
        }
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kXQBCompleteUserInfoNotice object:nil];
}

#pragma mark --- collectionView UICollectionViewDataSource
#pragma mark --- --- required dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([[UserModel shareUser].userType isEqualToString:XQB_USER_IDENTIFY_RESIDENT]) {
            RegisterStepThreeResidentCell *residentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RESIDENT_CELL" forIndexPath:indexPath];
            residentCell.userDescLabel.text = [UserModel shareUser].residentDesc;
            return residentCell;
        } else {
            RegisterStepThreeGeneralCell *generalCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GENERAL_CELL" forIndexPath:indexPath];
            
            [generalCell.playButton removeTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [generalCell.playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
            
            [generalCell.informationButton removeTarget:self action:@selector(informationButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [generalCell.informationButton addTarget:self action:@selector(informationButtonAction) forControlEvents:UIControlEventTouchUpInside];
            
            return generalCell;
        }
    } else {
        return nil;
    }
}

#pragma mairk --- collectionView UICollectionViewDelegate

#pragma mark --- collectionView UICollectionViewDelegateFlowLayout
#pragma mark ---  --- optional delegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([[UserModel shareUser].userType isEqualToString:XQB_USER_IDENTIFY_RESIDENT]) {
            return CGSizeMake(MainWidth, 198);
        } else {
            return CGSizeMake(MainWidth, 241.5);
        }
    } else {
        return CGSizeMake(0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

@end
