//
//  ShippingAddressDetailCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "ShippingAddressDetailCell.h"
#import "XQBUIFormatMacros.h"

static const CGFloat kAttributeNameWidth    = 80;
static const CGFloat KAttributeValueWidth   = 195;

@implementation ShippingAddressDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        _attributeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 0, kAttributeNameWidth, XQBHeightElement)];
        _attributeNameLabel.font = XQBFontContent;
        _attributeNameLabel.textColor = XQBColorExplain;
        [self addSubview:_attributeNameLabel];
        
        _attributeValueField = [[UITextField alloc] initWithFrame:CGRectMake(X(_attributeNameLabel)+WIDTH(_attributeNameLabel), 0, KAttributeValueWidth, XQBHeightElement)];
        _attributeValueField.font = XQBFontContent;
        _attributeValueField.textColor = [UIColor blackColor];
        [self addSubview:_attributeValueField];
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
