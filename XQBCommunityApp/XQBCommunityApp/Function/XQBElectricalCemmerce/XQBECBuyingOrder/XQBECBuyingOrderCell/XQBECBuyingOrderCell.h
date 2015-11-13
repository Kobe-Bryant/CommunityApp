//
//  XQBECBuyingOrderCell.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/17.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBBaseTableviewCell.h"

@interface XQBECBuyingOrderCell : XQBBaseTableviewCell

@property (nonatomic, strong) UIImageView *shoppingIconView;
@property (nonatomic, strong) UILabel *shoppingNameLabel;
@property (nonatomic, strong) UILabel *shoppingTypeLabel;
@property (nonatomic, strong) UILabel *shoppingPriceLabel;
@property (nonatomic, strong) UILabel *shoppingCountLabel;
@property (nonatomic, strong) UIButton *afterSalesButton;

@end
