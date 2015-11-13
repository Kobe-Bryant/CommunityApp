//
//  ECPLVSpecialtyGoodsCVCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "ECPLVSpecialtyGoodsCVCell.h"
#import "XQBUIFormatMacros.h"

typedef NS_ENUM(NSInteger, SpecialtyCellPosition){    //cell的位置
    SpecialtyCellTopOnlyLeft = 0,
    SpecialtyCellMiddleLeft,
    SpecialtyCellMiddleRight,
    SpecialtyCellBottomLeft,
    SpecialtyCellBottomRight,
};

static const CGFloat kSpecialtyItemHight    = 110.0f;
static const CGFloat kVerticalMargin        = 12.5f;
static const CGFloat kIconWidth             = 85.0f;
static const CGFloat kLabelHorizontalMargin = 8.0f;
static const CGFloat kDefaultLabelHight     = 10.0f;
static const CGFloat kPriceLabelHight       = 12.0f;
static const CGFloat kDiscountLabelWidth    = 30.0f;

@interface ECPLVSpecialtyGoodsCVCell()

@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *verticalLine;

@end

@implementation ECPLVSpecialtyGoodsCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, kVerticalMargin, kIconWidth, kIconWidth)];
        _goodsImageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_goodsImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodsImageView.frame.origin.x+_goodsImageView.frame.size.width+kLabelHorizontalMargin, 15, MainWidth/2-_goodsImageView.frame.size.width-XQBMarginHorizontal-kLabelHorizontalMargin*2, kDefaultLabelHight*3+10)];
        _nameLabel.font = [UIFont systemFontOfSize:kDefaultLabelHight];
        _nameLabel.textColor = XQBColorContent;
        _nameLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
        _nameLabel.numberOfLines = 3;
        [self addSubview:_nameLabel];
        
        _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth/2-kLabelHorizontalMargin-kDiscountLabelWidth, _nameLabel.frame.origin.y+_nameLabel.frame.size.height + kDefaultLabelHight, kDiscountLabelWidth, kPriceLabelHight)];
        _discountLabel.font = [UIFont systemFontOfSize:9];
        _discountLabel.textColor = [UIColor whiteColor];
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.backgroundColor = RGB(255, 200, 175);
        _discountLabel.layer.cornerRadius = 4.0f;
        [self addSubview:_discountLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x-kLabelHorizontalMargin, _discountLabel.frame.origin.y+_discountLabel.frame.size.height + 7.5, _nameLabel.frame.size.width+kLabelHorizontalMargin, kPriceLabelHight)];
        _priceLabel.font = [UIFont systemFontOfSize:kPriceLabelHight];
        _priceLabel.textColor = RGB(250, 80, 0);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_priceLabel];
        
        _horizontalLine = [[UIView alloc] init];    //水平的线
        _horizontalLine.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:_horizontalLine];

        _verticalLine = [[UIView alloc] init];      //垂直的线
        _verticalLine.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:_verticalLine];
    }
    return self;
}

- (void)getLinePositionAtIndex:(NSInteger)index withCellCount:(NSInteger)count
{
    if (4 < count){
        if (index == 0) {
            [self resetLinePosition:SpecialtyCellMiddleLeft];
        } else if (index == 1) {
            [self resetLinePosition:SpecialtyCellMiddleRight];
        } else {
            if ((count-4)%2 == 0) {
                if (index == count-1) {
                    [self resetLinePosition:SpecialtyCellBottomRight];
                } else if (index == count-2) {
                    [self resetLinePosition:SpecialtyCellBottomLeft];
                } else if ((index+1)%2 != 0) {
                    [self resetLinePosition:SpecialtyCellMiddleLeft];
                } else if ((index+1)%2 == 0) {
                    [self resetLinePosition:SpecialtyCellMiddleRight];
                }
            } else {
                if (index == count-1) {
                    [self resetLinePosition:SpecialtyCellBottomLeft];
                } else if ((index+1)%2 != 0) {
                    [self resetLinePosition:SpecialtyCellMiddleLeft];
                } else if ((index+1)%2 == 0) {
                    [self resetLinePosition:SpecialtyCellMiddleRight];
                }
            }
        }
    }else if (2 < count) {
        if (index == 0) {
            [self resetLinePosition:SpecialtyCellMiddleLeft];
        } else if (index == 1) {
            [self resetLinePosition:SpecialtyCellMiddleRight];
        } else if (index == 2) {
            [self resetLinePosition:SpecialtyCellBottomLeft];
        } else if (index == 3) {
            [self resetLinePosition:SpecialtyCellBottomRight];
        }
    } else if (count <= 2) {
        if (index == 0) {
            [self resetLinePosition:SpecialtyCellTopOnlyLeft];
        } else if (index == 1) {
            [self resetLinePosition:SpecialtyCellBottomRight];
        }
    }
}

- (void)resetLinePosition:(SpecialtyCellPosition)position
{
    switch (position) {
        case SpecialtyCellTopOnlyLeft: {
            [_horizontalLine setFrame:CGRectMake(0, 0, 0, 0)];
            
            [_verticalLine setFrame:CGRectMake(MainWidth/2-0.5, 10, 0.5, kSpecialtyItemHight-10*2)];
            break;
        } case SpecialtyCellMiddleLeft: {
            [_horizontalLine setFrame:CGRectMake(XQBMarginHorizontal, kSpecialtyItemHight-0.5, MainWidth/2-kLabelHorizontalMargin, 0.5)];
            
            [_verticalLine setFrame:CGRectMake(MainWidth/2-0.5, 0, 0.5, kSpecialtyItemHight)];
            break;
        } case SpecialtyCellMiddleRight: {
            [_horizontalLine setFrame:CGRectMake(0, kSpecialtyItemHight-0.5, MainWidth/2-XQBMarginHorizontal, 0.5)];
            
            [_verticalLine setFrame:CGRectMake(0, 0, 0, 0)];
            break;
        } case SpecialtyCellBottomLeft: {
            [_horizontalLine setFrame:CGRectMake(0, 0, 0, 0)];
            
            [_verticalLine setFrame:CGRectMake(MainWidth/2-0.5, 0, 0.5, kSpecialtyItemHight-10)];
            
            break;
        } case SpecialtyCellBottomRight: {
            [_horizontalLine setFrame:CGRectMake(0, 0, 0, 0)];
            
            [_verticalLine setFrame:CGRectMake(0, 0, 0, 0)];
            break;
        } default: {
            [_horizontalLine setFrame:CGRectMake(0, 0, 0, 0)];
            
            [_verticalLine setFrame:CGRectMake(0, 0, 0, 0)];
            break;
        }
    }
}

@end
