//
//  ShareCommentLike.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/25.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCommentLike : UIView

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) NSInteger likeCout;

@end
