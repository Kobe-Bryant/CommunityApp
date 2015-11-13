//
//  XQBECShippingAddressCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/22.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBECShippingAddressCell.h"
#import "XQBUIFormatMacros.h"

@implementation XQBECShippingAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (70-24)/2, 24, 24)];
        [self addSubview:_iconImageView];
        
        //名称
        _nameLabel = [[UILabel alloc ]  initWithFrame:
                     CGRectMake(_iconImageView.frame.size.width+_iconImageView.frame.origin.x+10, 5, 210, 22)];
        _nameLabel.textColor = XQBColorContent;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font=[UIFont systemFontOfSize:15.0];
        [self addSubview:_nameLabel];
        
        
        _contentLabel = [[UILabel alloc ]  initWithFrame:
                        CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.size.height+_nameLabel.frame.origin.y+2, 230, 36)];
        _contentLabel.numberOfLines = 2;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_contentLabel];
        
        UIImage *detailImage = [UIImage imageNamed:@"bg_awardView_detail.png"];
        _detailbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailbtn setImage:detailImage forState:UIControlStateNormal];
        _detailbtn.frame = CGRectMake(275, 0, 320-275, 70);
        [self addSubview:_detailbtn];
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
