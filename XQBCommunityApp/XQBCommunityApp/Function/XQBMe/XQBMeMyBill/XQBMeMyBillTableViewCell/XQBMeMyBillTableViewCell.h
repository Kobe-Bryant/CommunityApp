//
//  XQBMeMyBillTableViewCell.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/11.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBBaseTableviewCell.h"

@interface XQBMeMyBillTableViewCell : XQBBaseTableviewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *totalPrice;
@property (nonatomic, strong) UILabel *billStatus;

@end
