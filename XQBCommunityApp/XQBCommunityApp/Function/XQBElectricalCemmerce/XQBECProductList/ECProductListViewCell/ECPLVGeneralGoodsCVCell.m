//
//  ECPLVGeneralGoodsCVCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "ECPLVGeneralGoodsCVCell.h"
#import "XQBUIFormatMacros.h"

typedef NS_ENUM(NSInteger, GeneralCellPosition){    //cell的位置
    GeneralCellTopOnlyLeft = 0,
    GeneralCellMiddleLeft,
    GeneralCellMiddleRight,
    GeneralCellBottomLeft,
    GeneralCellBottomRight,
};

static const CGFloat kGeneralItemHight      = 198.0f;
static const CGFloat kIconWidth             = 131.0f;
static const CGFloat kDefaultLabelHight     = 10.0f;
static const CGFloat kPriceLabelHight       = 12.0f;
static const CGFloat kDiscountLabelWidth    = 30.0f;

@interface ECPLVGeneralGoodsCVCell()

@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *verticalLine;

@end

@implementation ECPLVGeneralGoodsCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, kDefaultLabelHight, kIconWidth, kIconWidth)];
        _goodsImageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_goodsImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, _goodsImageView.frame.origin.y+_goodsImageView.frame.size.height+5, kIconWidth, kDefaultLabelHight)];
        _nameLabel.font = [UIFont systemFontOfSize:kDefaultLabelHight];
        _nameLabel.textColor = XQBColorContent;
        [self addSubview:_nameLabel];
        
        _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, _nameLabel.frame.origin.y+_nameLabel.frame.size.height, kIconWidth, kDefaultLabelHight)];
        _summaryLabel.font = [UIFont systemFontOfSize:kDefaultLabelHight];
        _summaryLabel.textColor = XQBColorContent;
        [self addSubview:_summaryLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, _summaryLabel.frame.origin.y+_summaryLabel.frame.size.height + 10, kIconWidth-kDiscountLabelWidth, kPriceLabelHight)];
        _priceLabel.font = [UIFont systemFontOfSize:kPriceLabelHight];
        _priceLabel.textColor = XQBColorOrange;
        [self addSubview:_priceLabel];
        
        _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth/2-kDiscountLabelWidth-XQBMarginHorizontal, _priceLabel.frame.origin.y, kDiscountLabelWidth, kPriceLabelHight)];
        _discountLabel.font = [UIFont systemFontOfSize:9];
        _discountLabel.textColor = [UIColor whiteColor];
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.backgroundColor = RGB(255, 200, 175);
        _discountLabel.layer.cornerRadius = 4.0f;
        [self addSubview:_discountLabel];
        
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
            [self resetLinePosition:GeneralCellMiddleLeft];
        } else if (index == 1) {
            [self resetLinePosition:GeneralCellMiddleRight];
        } else {
            if ((count-4)%2 == 0) {
                if (index == count-1) {
                    [self resetLinePosition:GeneralCellBottomLeft];
                } else if (index == count-2) {
                    [self resetLinePosition:GeneralCellBottomLeft];
                } else if ((index+1)%2 != 0) {
                    [self resetLinePosition:GeneralCellMiddleLeft];
                } else if ((index+1)%2 == 0) {
                    [self resetLinePosition:GeneralCellMiddleRight];
                }
            } else {
                if (index == count-1) {
                    [self resetLinePosition:GeneralCellBottomLeft];
                } else if ((index+1)%2 != 0) {
                    [self resetLinePosition:GeneralCellMiddleLeft];
                } else if ((index+1)%2 == 0) {
                    [self resetLinePosition:GeneralCellMiddleRight];
                }
            }
        }
    }else if (2 < count) {
        if (index == 0) {
            [self resetLinePosition:GeneralCellMiddleLeft];
        } else if (index == 1) {
            [self resetLinePosition:GeneralCellMiddleRight];
        } else if (index == 2) {
            [self resetLinePosition:GeneralCellBottomLeft];
        } else if (index == 3) {
            [self resetLinePosition:GeneralCellBottomRight];
        }
    } else if (count <= 2) {
        if (index == 0) {
            [self resetLinePosition:GeneralCellTopOnlyLeft];
        } else if (index == 1) {
            [self resetLinePosition:GeneralCellBottomRight];
        }
    }
}

- (void)resetLinePosition:(GeneralCellPosition)position
{
    switch (position) {
        case GeneralCellTopOnlyLeft: {
            [_horizontalLine setFrame:CGRectMake(0, 0, 0, 0)];
            
            [_verticalLine setFrame:CGRectMake(MainWidth/2-0.5, 10, 0.5, kGeneralItemHight-10*2)];
            break;
        } case GeneralCellMiddleLeft: {
            [_horizontalLine setFrame:CGRectMake(XQBMarginHorizontal, kGeneralItemHight-0.5, MainWidth/2-XQBMarginHorizontal, 0.5)];
            
            [_verticalLine setFrame:CGRectMake(MainWidth/2-0.5, 0, 0.5, kGeneralItemHight)];
            break;
        } case GeneralCellMiddleRight: {
            [_horizontalLine setFrame:CGRectMake(0, kGeneralItemHight-0.5, MainWidth/2-XQBMarginHorizontal, 0.5)];
            
            [_verticalLine setFrame:CGRectMake(0, 0, 0, 0)];
            break;
        } case GeneralCellBottomLeft: {
            [_horizontalLine setFrame:CGRectMake(0, 0, 0, 0)];
            
            [_verticalLine setFrame:CGRectMake(MainWidth/2-0.5, 0, 0.5, kGeneralItemHight-10)];
            
            break;
        } case GeneralCellBottomRight: {
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
