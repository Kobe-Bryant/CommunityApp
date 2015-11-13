//
//  XQBHomeInformationListCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/31.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBHomeInformationListCell.h"
#import "XQBUIFormatMacros.h"

static const CGFloat kIconWidth         = 40.0f;
static const CGFloat kIconHight         = 40.0f;
static const CGFloat kVerticalMargin1   = 15.0f;
static const CGFloat kVerticalMargin2   = 10.0f;

@implementation XQBHomeInformationListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, kVerticalMargin1, kIconWidth, kIconHight)];
        [self addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.frame.origin.x+_iconView.frame.size.width+XQBSpaceHorizontalItem, kVerticalMargin1, MainWidth-(_iconView.frame.origin.x+_iconView.frame.size.width+XQBSpaceHorizontalItem+XQBMarginHorizontal), XQBHeightLabelContent)];
        _titleLabel.font = XQBFontContent;
        _titleLabel.textColor = XQBColorContent;
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, _titleLabel.frame.size.width, XQBHeightLabelContent)];
        _timeLabel.font = XQBFontTabbarItem;
        _timeLabel.textColor = XQBColorExplain;
        [self addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, kVerticalMargin1+_iconView.frame.size.height+kVerticalMargin1, MainWidth-XQBMarginHorizontal*2, XQBHeightLabelContent)];
        _contentLabel.font = XQBFontContent;
        _contentLabel.textColor = XQBColorContent;
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
        
        
        _photosView = [[PhotoDisplayView alloc] initWithDefualtFrame];
        _photosView.hidden = YES;
        [self addSubview:_photosView];
        
        
        _shareCommentLike = [[ShareCommentLike alloc] initWithFrame:CGRectMake(0, _contentLabel.frame.origin.y+_contentLabel.frame.size.height+kVerticalMargin2, MainWidth, 40.0f)];
        [self addSubview:_shareCommentLike];
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
