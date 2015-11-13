//
//  SGGoodsStandardView.m
//  CommunityAPP
//
//  Created by City-Online on 14-9-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SGGoodsStandardView.h"
#import "NSObject_extra.h"
#import "Global.h"
#import "Macros.h"
#import "ChangeCount.h"
#import "ECProductItemModel.h"
#import "UIImageView+WebCache.h"
#import "PricesShown.h"
#import "NSObject+Time.h"
#import "UIImage+extra.h"
#import "ECProductModel.h"

#define kMAX_CONTENT_SCROLLVIEW_HEIGHT   400

@interface SGGoodsStandardButton : UIButton

@property (nonatomic, retain) SGGoodsStandardView *menu;

@end

@implementation SGGoodsStandardButton

- (id)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
        
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:BaseMenuTextColor(self.menu.style) forState:UIControlStateNormal];
        self.layer.cornerRadius = 2.0f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5;

    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = [UIColor orangeColor].CGColor;
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }else{
        self.layer.borderColor = [UIColor grayColor].CGColor;
        [self setTitleColor:BaseMenuTextColor(self.menu.style) forState:UIControlStateNormal];
    }
}

@end


@interface SGGoodsStandardView ()


@property (nonatomic, strong) NSString *imageUrl;
//dataSource
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *productItems;

@property (nonatomic) NSInteger productCount;

@property (nonatomic, strong) UIImageView *backgroundView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *orderGoodsNumView;
@property (nonatomic, strong) UIView *buyGoodsView;

//header
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *goodsPriceLabel;
@property (nonatomic, strong) UILabel *storeLabel;
@property (nonatomic, strong) UILabel *selectedMeasureLabel;

@property (nonatomic, strong) UIView *productMeasureView;
@property (nonatomic, strong) UILabel *productMeasureLabel;

//order good view
@property (nonatomic, strong) UILabel *orderPepopleTipLabel;


@property (nonatomic, strong) UIButton *addToShoppingCartButton;
@property (nonatomic, strong) UIButton *buyNowButton;


@property (nonatomic, strong) UIView *firstSepLine;
@property (nonatomic, strong) UIView *secondSepLine;
@property (nonatomic, strong) UIView *thirdSepLine;
@property (nonatomic, strong) UIView *forthSepLine;
@property (nonatomic, strong) UIView *fifthSepLine;

@end

@implementation SGGoodsStandardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.roundedCorner = 0.0f;
        //UIImage *image = [UIImage imageNamed:@"actionSheet_background"];
        //UIImage *stretchImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(7, 0, 7, 0)];
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 3.0)];
        //_backgroundView.image = stretchImage;
        _backgroundView.backgroundColor = RGB(87, 182, 16);
        [self addSubview:_backgroundView];
        
        self.backgroundColor = RGB(244, 244, 244);
        
        [self addSubview:self.headerView];
        
        _firstSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), self.bounds.size.width, 0.5)];
        _firstSepLine.backgroundColor = RGB(222,222,222);
        [self addSubview:_firstSepLine];
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_contentScrollView];
        
        _secondSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 135, self.bounds.size.width, 0.5)];
        _secondSepLine.backgroundColor = RGB(222,222,222);
        [self addSubview:_secondSepLine];
        
        [self addSubview:self.orderGoodsNumView];
        
        _thirdSepLine = [[UIView alloc] initWithFrame:CGRectZero];
        _thirdSepLine.backgroundColor = RGB(222, 222, 222);
        [self addSubview:_thirdSepLine];
        
        _forthSepLine = [self lineView];
        [self addSubview:_forthSepLine];
        _fifthSepLine = [self lineView];
        [self addSubview:_fifthSepLine];
        
        [self addSubview:self.buyGoodsView];
        [self addSubview:self.productMeasureView];
    }
    return self;
}

- (UIView *)lineView{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = RGB(222, 222, 222);
    
    return lineView;
}

- (id)initWithTitle:(NSString *)title image:(NSString *)imageUrl itemTitles:(NSArray *)itemTitles{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        _imageUrl = imageUrl;
        _productItems = itemTitles;
        _goodsNameLabel.text = title;
        _productCount = 1;
        [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"default_square_placeholder_image.png"]];
        [self setupWithItemTitles:itemTitles];
        
    }
    return self;
}

- (void)setupWithItemTitles:(NSArray *)titles
{
    
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<titles.count; i++) {
        ECProductItemModel *model = titles[i];
        SGGoodsStandardButton *item = [[SGGoodsStandardButton alloc] initWithTitle:model.measure];
        
        item.menu = self;
        item.selected = model.isSelected;
        item.tag = i;
        [item addTarget:self
                 action:@selector(tapAction:)
       forControlEvents:UIControlEventTouchUpInside];
        [items addObject:item];
        [_contentScrollView addSubview:item];
        
        if (model.isSelected) {
            //_goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
            _currentProductItem = model;
            //NSString *string = [NSString stringWithFormat:@"已选:%@",model.measure];
            //_selectedMeasureLabel.text = string;
            
            if (model.selectedCount >= 1) {
                [_changeCountComponent setCount:model.selectedCount];
            }else{
                [_changeCountComponent setCount:1];
            }
            
            [self refreshItemMeasure];
            
        }
    }
    _items = [[NSArray alloc] initWithArray:items];
    
    [self refreshBuyPermission];
    
}

- (void)layoutContentScrollView{
    
    UIEdgeInsets margin = UIEdgeInsetsMake(12, 15, 12, 15);
    CGSize itemSize = CGSizeMake((self.bounds.size.width - margin.left - margin.right) / 3 , 25);
    
    NSInteger itemCount = self.items.count;
    NSInteger rowCount = ((itemCount-1) / 3) + 1;
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width, rowCount * itemSize.height + margin.top + margin.bottom);
    CGSize valiableSize = CGSizeMake(itemSize.width-5, itemSize.height-3);
    for (int i=0; i<itemCount; i++) {
        SGGoodsStandardButton *item = self.items[i];
        int row = i / 3;
        int column = i % 3;
        CGPoint p = CGPointMake(margin.left + column * itemSize.width, margin.top + row * itemSize.height);
        item.frame = (CGRect){p, valiableSize};
        [item layoutIfNeeded];
    }
    
    if (self.contentScrollView.contentSize.height > kMAX_CONTENT_SCROLLVIEW_HEIGHT) {
        self.contentScrollView.frame = (CGRect){CGPointMake(0, CGRectGetMaxY(_secondSepLine.frame)), CGSizeMake(self.bounds.size.width, kMAX_CONTENT_SCROLLVIEW_HEIGHT)};
    }else{
        self.contentScrollView.frame = (CGRect){CGPointMake(0, CGRectGetMaxY(_secondSepLine.frame)), self.contentScrollView.contentSize};
    }
    
}

- (UIView *)headerView{
    if (_headerView == nil) {
        
        CGFloat offsetX = 90;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), 85)];
        
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 65, 65)];
        [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"default_square_placeholder_image.png"]];
        [_headerView addSubview:_goodsImageView];

        
        _goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 12, 160, 20)];
        _goodsNameLabel.backgroundColor = [UIColor clearColor];
        _goodsNameLabel.textColor = RGB(103,102,100);
        _goodsNameLabel.hidden = YES;
        [_headerView addSubview:_goodsNameLabel];
        
        
        _goodsPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 20/*35*/, 130, 20)];
        _goodsPriceLabel.backgroundColor = [UIColor clearColor];
        _goodsPriceLabel.textColor = RGB(224 ,121 ,29);
        //_goodsPriceLabel.text = @"￥55";
        [_headerView addSubview:_goodsPriceLabel];
        
        
        _selectedMeasureLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 45, 150, 15)];
        _selectedMeasureLabel.backgroundColor = [UIColor clearColor];
        _selectedMeasureLabel.textColor = XQBColorContent;
        _selectedMeasureLabel.font = [UIFont systemFontOfSize:11.0f];
        [_headerView addSubview:_selectedMeasureLabel];
    }
    
    return _headerView;
}

- (UIView *)orderGoodsNumView{
    if (_orderGoodsNumView == nil) {
        _orderGoodsNumView = [[UIView alloc] initWithFrame:CGRectZero];
     
        UILabel *changCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 80, 35)];
        changCountLabel.text = @"购买数量";
        changCountLabel.font = [UIFont systemFontOfSize:16];
        [_orderGoodsNumView addSubview:changCountLabel];
        
        _changeCountComponent = [[ChangeCount alloc] initWithFrame:CGRectMake(200, 12, 105, 30)];
        [_changeCountComponent setCount:1];
        [_orderGoodsNumView addSubview:_changeCountComponent];
    }
    
    return _orderGoodsNumView;
}

- (UIView *)buyGoodsView{
    if (_buyGoodsView == nil) {
        _buyGoodsView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _addToShoppingCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addToShoppingCartButton addTarget:self action:@selector(addToShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
        _addToShoppingCartButton.frame = CGRectMake( 110, 10, 93, 45);
        [_addToShoppingCartButton setExclusiveTouch:YES];
        [_addToShoppingCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addToShoppingCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addToShoppingCartButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_addToShoppingCartButton setBackgroundImage:[UIImage imageWithColor:RGB(250, 150, 0) size:_addToShoppingCartButton.bounds.size] forState:UIControlStateNormal];
        [_addToShoppingCartButton setBackgroundImage:[UIImage imageWithColor:RGB(153, 153, 153) size:_addToShoppingCartButton.bounds.size] forState:UIControlStateDisabled];
        [_addToShoppingCartButton.layer setMasksToBounds:YES];
        [_addToShoppingCartButton.layer setCornerRadius:3];
        [_buyGoodsView addSubview:_addToShoppingCartButton];
        
        _buyNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyNowButton addTarget:self action:@selector(buyNowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buyNowButton setExclusiveTouch:YES];
        _buyNowButton.frame = CGRectMake( 214, 10, 93, 45);
        [_buyNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyNowButton setTitle:@"立即购买" forState:UIControlStateNormal];
        _buyNowButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_buyNowButton setBackgroundImage:[UIImage imageWithColor:RGB(250, 0, 0) size:_buyNowButton.bounds.size] forState:UIControlStateNormal];
        [_buyNowButton setBackgroundImage:[UIImage imageWithColor:RGB(153, 153, 153) size:_buyNowButton.bounds.size] forState:UIControlStateDisabled];
        [_buyNowButton.layer setMasksToBounds:YES];
        [_buyNowButton setBackgroundColor:RGB(250, 0, 0)];
        [_buyNowButton.layer setCornerRadius:3];
        [_buyGoodsView addSubview:_buyNowButton];
        
    }
    
    return _buyGoodsView;
}

- (UIView *)productMeasureView{
    if(_productMeasureView == nil){
        _productMeasureView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, self.bounds.size.width, 44)];
        
        _productMeasureLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 13, 100, 22)];
        _productMeasureLabel.backgroundColor = [UIColor clearColor];
        _productMeasureLabel.text = @"产品规格";
        [_productMeasureView addSubview:_productMeasureLabel];
    }
    return _productMeasureView;
}

- (void)setProductModel:(ECProductModel *)productModel{
    _productModel = productModel;

    [self refreshBuyPowerState];
    
}

- (void)refreshBuyPowerState{
    if (_productModel.rushBuyStatus == XQBECProductRushByStatusUnBuying) {
        _buyNowButton.enabled = NO;
        _addToShoppingCartButton.enabled = NO;
        
    }else if(_productModel.rushBuyStatus == XQBECProductRushByStatusBuying){
        
    }else if (_productModel.rushBuyStatus == XQBECProductRushByStatusEnd){
        
        _buyNowButton.enabled = NO;
        _addToShoppingCartButton.enabled = NO;
    }
}

- (UILabel *)selectedMeasureLabel{
    if(_selectedMeasureLabel == nil){
        
    }
    
    return _selectedMeasureLabel;
}

- (void)layoutBuyGoodsView{
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutContentScrollView];
    
    _headerView.frame = CGRectMake(0, 0, self.bounds.size.width, 90);
    _thirdSepLine.frame = CGRectMake(0,CGRectGetMaxY(_contentScrollView.frame), self.bounds.size.width, 0.5);
    _orderGoodsNumView.frame = CGRectMake(0, CGRectGetMaxY(_thirdSepLine.frame), self.bounds.size.width, 50);
    _forthSepLine.frame = CGRectMake(0, CGRectGetMaxY(_orderGoodsNumView.frame), self.bounds.size.width, 0.5);
    
    _fifthSepLine.frame = CGRectMake(0, 327, self.bounds.size.width, 0.5);
    _buyGoodsView.frame = CGRectMake(0, CGRectGetMaxY(_fifthSepLine.frame), self.bounds.size.width, 75);
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, 395/*HEIGHT(_headerView)+HEIGHT(_orderGoodsNumView)+HEIGHT(_buyGoodsView)+HEIGHT(_contentScrollView)*/)};
    //_backgroundView.frame = (CGRect){CGPointZero, self.bounds.size};
}

#pragma mark ---action
- (void)tapAction:(UIButton *)sender{
    for (SGGoodsStandardButton *btn in self.items) {
        btn.selected = NO;
        
    }
    
    for (ECProductItemModel *item in self.productItems) {
        item.isSelected = NO;
        item.selectedCount = 1;
    }

    ECProductItemModel *model = ([self.productItems count]>sender.tag)?[self.productItems objectAtIndex:sender.tag]:nil;
    _currentProductItem = model;
    model.isSelected = YES;
    sender.selected = YES;
    
    [self refreshItemMeasure];

    [self refreshBuyPermission];
    
    NSInteger maxValue;
    if ([self.productModel.tagType isEqualToString:kXQBProductTagTypeRushBuy] || [self.productModel.tagType isEqualToString:kXQBProductTagTypeLimitedBuy]) {
        maxValue = MIN([self.currentProductItem.stockCount integerValue], [self.productModel.limitedBuyNumber integerValue]);
    } else {
        maxValue = [self.currentProductItem.stockCount integerValue];
    }
    [self.changeCountComponent setMaximumValue:maxValue];

}

//刷新选中商品规格及库存、价格
- (void)refreshItemMeasure{
    UIFont *baseFont = [UIFont systemFontOfSize:12];
    //价格字符串
    NSString *priceStr = [NSString stringWithFormat:@"%@",[PricesShown priceOfShorthand:[self.currentProductItem.price doubleValue]]];
    //库存字符串
    NSString *storeStr = [NSString stringWithFormat:@"(库存%@%@)",self.currentProductItem.stockCount,self.currentProductItem.unit];
    NSString *priceAndStore = [NSString stringWithFormat:@"%@ %@",priceStr,storeStr];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceAndStore];
    NSRange priceRange = [priceAndStore rangeOfString:priceStr];
    NSRange storeRange = [priceAndStore rangeOfString:storeStr];
    [attributedString addAttribute:NSFontAttributeName value:baseFont range:priceRange];
    [attributedString addAttribute:NSFontAttributeName value:baseFont range:storeRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(250, 80, 0) range:priceRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:XQBColorContent range:storeRange];
    
    if ([self.currentProductItem.stockCount integerValue] < [self.changeCountComponent getCount]) {
        [self.changeCountComponent setCount:1];
    }
    
    _goodsPriceLabel.attributedText = attributedString;
    //_goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    NSString *string = [NSString stringWithFormat:@"已选:\"%@\"",self.currentProductItem.measure];
    _selectedMeasureLabel.text = string;
}

- (BOOL)verifyCanBuy{
    
    if ([self.currentProductItem.stockCount integerValue] == 0) {
        return NO;
    }
    
    
    if (_productModel.rushBuyStatus == XQBECProductRushByStatusUnBuying) {
        
        return NO;
        
    }else if(_productModel.rushBuyStatus == XQBECProductRushByStatusBuying){
        
        return YES;
    }else if (_productModel.rushBuyStatus == XQBECProductRushByStatusEnd){
        
        return NO;
    }
    
    return YES;
}

- (void)refreshBuyPermission{
    if ([self verifyCanBuy]) {
        _addToShoppingCartButton.enabled = YES;
        _buyNowButton.enabled = YES;
    }else{
        _addToShoppingCartButton.enabled = NO;
        _buyNowButton.enabled = NO;
    }
}

- (void)buyNowButtonAction:(UIButton *)sender{
    [UIButton cancelPreviousPerformRequestsWithTarget:self selector:@selector(buyNowButtonAction:) object:sender];
    if (self.productCount > [self.currentProductItem.stockCount integerValue]) {
        [self.window makeCustomToast:@"库存量不足"];
        return;
    }
    self.productCount = [_changeCountComponent getCount];
    ECProductItemModel *model = self.currentProductItem;
    model.selectedCount = self.productCount;
    if (self.buyNowHandle) {
        self.buyNowHandle(model,self.productCount);
    }
    
    [[SGActionView sharedActionView] dismissMenu:self Animated:YES];
}

- (void)addToShoppingCart:(UIButton *)sender{
    if (self.productCount > [self.currentProductItem.stockCount integerValue]) {
        [self.window makeCustomToast:@"库存量不足"];
        return;
    }
    self.productCount = [_changeCountComponent getCount];
    ECProductItemModel *model = self.currentProductItem;
    model.selectedCount = self.productCount;
    if (self.addShoppingCartHanlde) {
        self.addShoppingCartHanlde(model,self.productCount);
    }
    [[SGActionView sharedActionView] dismissMenu:self Animated:YES];
}

- (void)confirmClicked:(UIButton *)sender{
    self.productCount = [_changeCountComponent getCount];
    ECProductItemModel *model = self.currentProductItem;
    model.selectedCount = self.productCount;
    if (self.confirmMeasureHandle) {
        self.confirmMeasureHandle(model,self.productCount);
    }
    [[SGActionView sharedActionView] dismissMenu:self Animated:YES];
}

@end
