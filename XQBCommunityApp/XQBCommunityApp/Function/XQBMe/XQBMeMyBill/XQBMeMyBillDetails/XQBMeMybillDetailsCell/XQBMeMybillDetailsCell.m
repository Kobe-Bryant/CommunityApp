//
//  XQBMeMybillDetailsCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/12.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeMybillDetailsCell.h"
#import "Global.h"

static const CGFloat kAttributeNameWidth    = 120.0f;
static const CGFloat KAttributeValueWidth   = 170.0f;

@implementation XQBMeMybillDetailsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        _attributeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 0, kAttributeNameWidth, XQBHeightElement)];
        _attributeNameLabel.font = XQBFontContent;
        _attributeNameLabel.textColor = XQBColorContent;
        [self addSubview:_attributeNameLabel];
        
        _attributeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(_attributeNameLabel)+WIDTH(_attributeNameLabel), 0, KAttributeValueWidth, XQBHeightElement)];
        _attributeValueLabel.font = XQBFontContent;
        _attributeValueLabel.textColor = XQBColorContent;
        _attributeValueLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_attributeValueLabel];
        
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
