//
//  ECPLVHeaderRushBuyReusableView.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMSSTimerView.h"
#import "CMSSCountTimer.h"


@interface ECPLVHeaderRushBuyReusableView : UICollectionReusableView

@property (nonatomic, strong) UIView *adsView;
@property (nonatomic, strong) UIView *rushBuyHeaderView;

@property (nonatomic, strong) CMSSCountTimer *countTimer;
@property (nonatomic, strong) CMSSTimerView *timeView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *rushBuyStatusLabel;

@end
