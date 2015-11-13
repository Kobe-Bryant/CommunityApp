//
//  SGGoodsStandardView.h
//  CommunityAPP
//
//  Created by City-Online on 14-9-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SGCustomMenu.h"
#import "ChangeCount.h"

@class ECProductModel;

@class ECProductItemModel;

typedef void(^SGMenuBuyActionHandler)(ECProductItemModel *productItem,NSInteger count);

@interface SGGoodsStandardView : SGCustomMenu

- (id)initWithTitle:(NSString *)title image:(NSString *)imageUrl itemTitles:(NSArray *)itemTitles;

@property (nonatomic, strong, readonly) ECProductItemModel *currentProductItem;

@property (nonatomic, strong) ECProductModel *productModel;

@property (nonatomic, strong) ChangeCount *changeCountComponent;

@property (nonatomic, strong) SGMenuBuyActionHandler changeMeasureHandle;

@property (nonatomic, strong) SGMenuBuyActionHandler buyNowHandle;

@property (nonatomic, strong) SGMenuBuyActionHandler addShoppingCartHanlde;

@property (nonatomic, strong) SGMenuBuyActionHandler confirmMeasureHandle;

@end
