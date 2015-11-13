//
//  XQBSeleteHouseTableViewCell.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/8.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBSeleteHouseTableViewCell.h"
#import "Global.h"

@interface XQBSeleteHouseTableViewCell ()


@end

@implementation XQBSeleteHouseTableViewCell

- (void)dealloc{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.bounds.size.width-80, self.bounds.size.height)];
        _contentLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = XQBColorExplain;
        [self addSubview:_contentLabel];
        
    }
    return self;
}

@end
