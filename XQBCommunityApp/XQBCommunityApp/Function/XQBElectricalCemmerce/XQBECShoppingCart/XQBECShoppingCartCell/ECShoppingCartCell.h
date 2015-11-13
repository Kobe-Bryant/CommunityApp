//
//  ECShoppingCartCell.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/16.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBBaseTableviewCell.h"
#import "ChangeCount.h"

@interface ECShoppingCartCell : XQBBaseTableviewCell

@property (nonatomic, retain) UIButton *selectButton;
@property (nonatomic, retain) UIImageView *shoppingIconView;
@property (nonatomic, retain) UILabel *shoppingNameLabel;
@property (nonatomic, retain) UILabel *shoppingPriceLabel;
@property (nonatomic, retain) UILabel *shoppingTypeLabel;
@property (nonatomic, retain) UILabel *shoppingCountLabel;
@property (nonatomic, retain) ChangeCount *changeCountComponent;

@end
