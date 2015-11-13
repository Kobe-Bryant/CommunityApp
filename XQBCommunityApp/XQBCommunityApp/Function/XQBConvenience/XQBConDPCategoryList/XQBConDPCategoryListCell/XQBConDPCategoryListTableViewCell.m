//
//  XQBConDPCategoryListTableViewCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/30.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBConDPCategoryListTableViewCell.h"
#import "XQBUIFormatMacros.h"

static const CGFloat kIconWidth     = 70.0f;
static const CGFloat kIconHeight    = 70.0f;
static const CGFloat kDisLabelWidth = 60.0f;
static const CGFloat kStarWidth     = 13.0f;
static const CGFloat kStarHeight    = 13.0f;

@implementation XQBConDPCategoryListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, XQBSpaceVerticalElement, kIconWidth, kIconHeight)];
        [self addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(_iconImageView)+WIDTH(_iconImageView)+XQBSpaceHorizontalItem, Y(_iconImageView), MainWidth-X(_iconImageView)-WIDTH(_iconImageView)-XQBSpaceHorizontalItem-XQBMarginHorizontal, XQBHeightLabelContent)];
        _titleLabel.font = XQBFontContent;
        _titleLabel.textColor = XQBColorContent;
        [self addSubview:_titleLabel];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(_titleLabel), Y(_titleLabel)+HEIGHT(_titleLabel)+6, MainWidth-X(_titleLabel)-XQBMarginHorizontal-kDisLabelWidth, XQBHeightLabelExplain)];
        _addressLabel.font = XQBFontExplain;
        _addressLabel.textColor = XQBColorExplain;
        [self addSubview:_addressLabel];
        
        _disLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(_addressLabel)+WIDTH(_addressLabel), Y(_addressLabel), kDisLabelWidth, XQBHeightLabelExplain)];
        _disLabel.font = XQBFontExplain;
        _disLabel.textColor = XQBColorExplain;
        _disLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_disLabel];
    }
    return self;
}

- (void)setStarWithGrade:(NSInteger)grade
{
    for (int i=0; i<5; i++) {
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(X(_addressLabel)+i*kStarWidth, kIconHeight-kStarHeight+XQBSpaceVerticalElement, kStarWidth, kStarHeight)];
        if (i<=(grade-1)) {
            [starImageView setImage:[UIImage imageNamed:@"dp_con_detail_highstar.png"]];
        }else{
            [starImageView setImage:[UIImage imageNamed:@"dp_con_detail_normalstar.png"]];
        }
        [self addSubview:starImageView];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
