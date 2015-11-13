//
//  XQBMeMyBillTableViewCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/11.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeMyBillTableViewCell.h"
#import "XQBUIFormatMacros.h"

static const CGFloat kIconWidth         = 30.0f;
static const CGFloat kIconHeigth        = 30.0f;
static const CGFloat kStatusLabelWidth  = 45.0f;

@implementation XQBMeMyBillTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, XQBSpaceVerticalItem, kIconWidth, kIconHeigth)];
        [self addSubview:_iconView];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(X(_iconView)+WIDTH(_iconView)+XQBMarginHorizontal, 0, MainWidth/2 - (X(_iconView)+WIDTH(_iconView)+XQBMarginHorizontal), XQBHeightElement)];
        _title.font = XQBFontContent;
        _title.textColor = XQBColorContent;
        [self addSubview:_title];
        
        _billStatus = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth-XQBMarginHorizontal-kStatusLabelWidth, 0, kStatusLabelWidth, XQBHeightElement)];
        _billStatus.font = XQBFontContent;
        _billStatus.textColor = XQBColorOrange;
        _billStatus.textAlignment = NSTextAlignmentRight;
        [self addSubview:_billStatus];
        
        _totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth/2, 0, MainWidth/2-kStatusLabelWidth-XQBMarginHorizontal-XQBSpaceHorizontalItem, XQBHeightElement)];
        _totalPrice.font = XQBFontContent;
        _totalPrice.textColor = XQBColorContent;
        _totalPrice.textAlignment = NSTextAlignmentRight;
        [self addSubview:_totalPrice];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
