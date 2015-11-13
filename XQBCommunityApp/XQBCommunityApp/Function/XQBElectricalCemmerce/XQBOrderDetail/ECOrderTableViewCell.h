//
//  ECOrderTableViewCell.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *shoppingIconView;
@property (nonatomic, strong) UILabel *shoppingNameLabel;
@property (nonatomic, strong) UILabel *shoppingTypeLabel;
@property (nonatomic, strong) UILabel *shoppingPriceLabel;
@property (nonatomic, strong) UILabel *shoppingCountLabel;
@property (nonatomic, strong) UIButton *afterSalesButton;

@end
