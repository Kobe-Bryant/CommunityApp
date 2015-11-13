//
//  ShareCommentLike.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/25.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "ShareCommentLike.h"
#import "XQBUIFormatMacros.h"

static const CGFloat kVerticalMargin = 5;

@implementation ShareCommentLike

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(0, 0, self.frame.size.width/3-0.5, self.frame.size.height);
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton.titleLabel setFont:XQBFontExplain];
        [_shareButton setTitleColor:XQBColorExplain forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"share_icon.png"] forState:UIControlStateNormal];
        [_shareButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [self addSubview:_shareButton];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/3, kVerticalMargin, 0.5, self.frame.size.height-kVerticalMargin*2)];
        lineView1.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:lineView1];
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.frame = CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height);
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:XQBFontExplain];
        [_commentButton setTitleColor:XQBColorExplain forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"comment_icon.png"] forState:UIControlStateNormal];
        [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [self addSubview:_commentButton];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*2/3, kVerticalMargin, 0.5, self.frame.size.height-kVerticalMargin*2)];
        lineView2.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:lineView2];
        
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = CGRectMake(self.frame.size.width*2/3+0.5, 0, self.frame.size.width/3-0.5, self.frame.size.height);
        [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [_likeButton.titleLabel setFont:XQBFontExplain];
        [_likeButton setTitleColor:XQBColorExplain forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"like_icon.png"] forState:UIControlStateNormal];
        [_likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [self addSubview:_likeButton];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        lineView3.backgroundColor = XQBColorInternalSeparationLine;
        [self addSubview:lineView3];
    }
    return self;
}

- (void)setIsLiked:(BOOL)isLiked
{
    if (isLiked) {
        [_likeButton setImage:[UIImage imageNamed:@"liked_icon.png"] forState:UIControlStateNormal];
    } else {
        [_likeButton setImage:[UIImage imageNamed:@"like_icon.png"] forState:UIControlStateNormal];
    }
}

- (void)setLikeCout:(NSInteger)likeCout
{
    if (likeCout > 50) {
        [_likeButton setTitle:[NSString stringWithFormat:@"(%ld)", likeCout] forState:UIControlStateNormal];
    }
}


@end
