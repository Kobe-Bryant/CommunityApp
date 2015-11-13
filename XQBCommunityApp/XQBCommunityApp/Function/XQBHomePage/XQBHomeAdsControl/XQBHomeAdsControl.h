//
//  XQBHomeAdsControl.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/5.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"

@interface XQBHomeAdsControl : UIView

@property (nonatomic, strong) CycleScrollView *cycleScrollView;


- (void)show;

- (void)dismiss;

@end
