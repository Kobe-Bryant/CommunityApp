//
//  XQBHomeInformationListCell.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/31.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBBaseTableviewCell.h"
#import "ShareCommentLike.h"
#import "PhotoDisplayView.h"

@interface XQBHomeInformationListCell : XQBBaseTableviewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) PhotoDisplayView *photosView;
@property (nonatomic, strong) ShareCommentLike *shareCommentLike;

@end
