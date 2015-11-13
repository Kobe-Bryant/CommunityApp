//
//  ECShoppingCartCell.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/16.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "ECShoppingCartCell.h"
#import "XQBUIFormatMacros.h"

@implementation ECShoppingCartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"no_choosed_button.png"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"choosed_button.png"] forState:UIControlStateSelected];
        _selectButton.frame = CGRectMake(0, 0, 45, 103);
        [self addSubview:_selectButton];
        
        _shoppingIconView = [[UIImageView alloc] initWithFrame:CGRectMake(_selectButton.frame.origin.x*2 + _selectButton.frame.size.width, 14, 75, 75)];
        [self addSubview:_shoppingIconView];
        
        _shoppingNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shoppingIconView.frame.size.width+_shoppingIconView.frame.origin.x+14, _shoppingIconView.frame.origin.y+14, 120, 30)];
        _shoppingNameLabel.textColor = XQBColorContent;
        _shoppingNameLabel.font = [UIFont systemFontOfSize:15.0];
        _shoppingNameLabel.numberOfLines = 0;
        [self addSubview:_shoppingNameLabel];
        
        _shoppingTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shoppingNameLabel.frame.origin.x, _shoppingNameLabel.frame.origin.y+_shoppingNameLabel.frame.size.height, 120, 17)];
        _shoppingTypeLabel.font = [UIFont systemFontOfSize:12.0];
        _shoppingTypeLabel.textColor = XQBColorExplain;
        [self addSubview:_shoppingTypeLabel];
        
        _shoppingPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shoppingNameLabel.frame.origin.x+_shoppingNameLabel.frame.size.width, _shoppingIconView.frame.origin.y+75/2-12.5, 320-14-_shoppingNameLabel.frame.origin.x-_shoppingNameLabel.frame.size.width, 10)];
        _shoppingPriceLabel.font = [UIFont systemFontOfSize:10.0];
        _shoppingPriceLabel.textColor = XQBColorContent;
        _shoppingPriceLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:_shoppingPriceLabel];
        
        _shoppingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shoppingPriceLabel.frame.origin.x, _shoppingPriceLabel.frame.origin.y+_shoppingPriceLabel.frame.size.height+5, _shoppingPriceLabel.frame.size.width, 10)];
        _shoppingCountLabel.font = [UIFont systemFontOfSize:10.0f];
        _shoppingCountLabel.textColor = XQBColorExplain;
        _shoppingCountLabel.textAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:_shoppingCountLabel];
        
        _changeCountComponent = [[ChangeCount alloc] initWithFrame:CGRectMake(_shoppingNameLabel.frame.origin.x, _shoppingNameLabel.frame.origin.y-10, 122.5, 35)];
        _changeCountComponent.hidden = YES;
        [self addSubview:_changeCountComponent];
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
