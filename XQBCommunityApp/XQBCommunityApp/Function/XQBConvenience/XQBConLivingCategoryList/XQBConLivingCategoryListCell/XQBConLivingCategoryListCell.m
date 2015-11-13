//
//  XQBConLivingCategoryListCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/26.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBConLivingCategoryListCell.h"
#import "XQBUIFormatMacros.h"


static const CGFloat kShadowViewHeight = 65.0f;
static const CGFloat kDistanceLabelWidth = 50.0f;

@implementation XQBConLivingCategoryListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:_backgroundImageView];
        
        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 200 - kShadowViewHeight, self.frame.size.width, kShadowViewHeight)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, shadowView.frame.size.width, shadowView.frame.size.height);
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor colorWithRed:80 green:80 blue:80 alpha:0.1].CGColor,
                           (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9].CGColor,nil];
        [shadowView.layer insertSublayer:gradient atIndex:0];
        
        [self addSubview:shadowView];
        
        _briefIntroduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 5, MainWidth-XQBMarginHorizontal, XQBHeightLabelContent)];
        _briefIntroduceLabel.font = XQBFontContent;
        _briefIntroduceLabel.text = @"一杯香醇的美式咖啡，享受纯正的味道";
        _briefIntroduceLabel.textColor = [UIColor whiteColor];
        _briefIntroduceLabel.shadowColor = XQBColorExplain;
        _briefIntroduceLabel.shadowOffset = CGSizeMake(0.5, 0.5);
        [shadowView addSubview:_briefIntroduceLabel];
        
        _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, Y(_briefIntroduceLabel)+XQBHeightLabelContent, MainWidth-XQBMarginHorizontal, XQBHeightLabelExplain)];
        _themeLabel.font = XQBFontTabbarItem;
        _themeLabel.text = @"美式咖啡";
        _themeLabel.textColor = [UIColor whiteColor];
        _themeLabel.shadowColor = XQBColorExplain;
        _themeLabel.shadowOffset = CGSizeMake(0.5, 0.5);
        [shadowView addSubview:_themeLabel];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, Y(_themeLabel)+XQBHeightLabelExplain, MainWidth-XQBMarginHorizontal-kDistanceLabelWidth, XQBHeightLabelExplain)];
        _locationLabel.font = XQBFontTabbarItem;
        _locationLabel.text = @"福田区 市民中心";
        _locationLabel.textColor = XQBColorElementSeparationLine;
        [shadowView addSubview:_locationLabel];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth-kDistanceLabelWidth, Y(_locationLabel), kDistanceLabelWidth, XQBHeightLabelContent)];
        _distanceLabel.font = XQBFontTabbarItem;
        _distanceLabel.text = @"1.7km";
        _distanceLabel.textColor = XQBColorElementSeparationLine;
        [shadowView addSubview:_distanceLabel];
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
