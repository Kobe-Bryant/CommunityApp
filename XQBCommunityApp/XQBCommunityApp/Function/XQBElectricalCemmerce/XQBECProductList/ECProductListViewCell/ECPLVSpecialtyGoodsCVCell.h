//
//  ECPLVSpecialtyGoodsCVCell.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECPLVSpecialtyGoodsCVCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *goodsImageView;  //商品图片
@property (nonatomic, strong) UILabel *nameLabel;           //商品名称
@property (nonatomic, strong) UILabel *discountLabel;       //商品折扣
@property (nonatomic, strong) UILabel *priceLabel;          //商品价格（折后）

- (void)getLinePositionAtIndex:(NSInteger)index withCellCount:(NSInteger)count;

@end
