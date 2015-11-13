//
//  MallPopListTableViewCell.m
//  CommunityAPP
//
//  Created by City-Online on 14-10-15.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "MallPopListTableViewCell.h"

@interface MallPopListTableViewCell ()

//UITableViewCellSeparatorStyleNone
@property (nonatomic ,strong) UIView *separatorLine;

@end

@implementation MallPopListTableViewCell

- (void)dealloc{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-0.5, self.bounds.size.width, 0.5)];
        _separatorLine.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin);
        _separatorLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:_separatorLine];
       
        
    }
    return self;
}

@end
