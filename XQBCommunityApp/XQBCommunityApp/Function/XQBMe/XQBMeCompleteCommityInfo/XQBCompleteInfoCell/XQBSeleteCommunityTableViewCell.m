//
//  XQBSeleteCommunityTableViewCell.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/7.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBSeleteCommunityTableViewCell.h"
#import "Global.h"

@implementation XQBSeleteCommunityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _communityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 180, 20)];
        _communityNameLabel.backgroundColor = [UIColor clearColor];
        _communityNameLabel.textColor = XQBColorContent;
        [self addSubview:_communityNameLabel];
        
        _communityAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 250, 20)];
        _communityAddressLabel.font = [UIFont systemFontOfSize:12];
        _communityAddressLabel.textColor = XQBColorExplain;
        [self addSubview:_communityAddressLabel];
        
    }
    return self;
}

@end
