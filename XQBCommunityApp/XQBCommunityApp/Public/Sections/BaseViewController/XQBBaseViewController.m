//
//  XQBBaseViewController.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/11/17.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBBaseViewController.h"
#import "Global.h"

@interface XQBBaseViewController ()


@end

@implementation XQBBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationBarHidden = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     //[self adjustiOS7WhiteNaviagtionBar];
    self.view.backgroundColor = XQBColorBackground;
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

@end
