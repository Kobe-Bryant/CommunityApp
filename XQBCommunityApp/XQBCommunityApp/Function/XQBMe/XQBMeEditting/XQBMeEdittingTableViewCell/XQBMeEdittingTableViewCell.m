//
//  XQBMeEdittingTableViewCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/6.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBMeEdittingTableViewCell.h"
#import "XQBUIFormatMacros.h"

static const CGFloat kAttributeNameWidth    = 60;
static const CGFloat KAttributeValueWidth   = 215;

@implementation XQBMeEdittingTableViewCell

- (void)dealloc{
    [self.attributeValueLabel removeObserver:self forKeyPath:@"text"];
}

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
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(_attributeNameLabel)+WIDTH(_attributeNameLabel), 0, KAttributeValueWidth, XQBHeightElement)];
        _placeHolderLabel.font = XQBFontContent;
        _placeHolderLabel.textColor = XQBColorExplain;
        [self addSubview:_placeHolderLabel];
        
        _attributeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(_attributeNameLabel)+WIDTH(_attributeNameLabel), 0, KAttributeValueWidth, XQBHeightElement)];
        _attributeValueLabel.font = XQBFontContent;
        _attributeValueLabel.textColor = [UIColor blackColor];
        [self addSubview:_attributeValueLabel];
        
        
        [self.attributeValueLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionPrior context:nil];
        
        }
    return self;
}



- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{

    if (object == self.attributeValueLabel) {
        if ([keyPath isEqualToString:@"text"]) {
            NSString *oldString = [change objectForKey:NSKeyValueChangeNewKey];
            if (oldString.length > 0) {
                self.placeHolderLabel.text = nil;
            }
        }
    }
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
