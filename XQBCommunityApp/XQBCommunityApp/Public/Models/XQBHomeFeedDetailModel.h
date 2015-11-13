//
//  XQBHomeFeedDetailModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/12.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQBHomeFeedDetailModel : NSObject

@property (nonatomic, strong) NSString *feedId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *feedIcon;
@property (nonatomic, strong) NSString *setDefault;
@property (nonatomic, strong) NSString *detailUrl;
@property (nonatomic, strong) NSString *commentCount;
@property (nonatomic, strong) NSString *likeCount;
@property (nonatomic, strong) NSString *isLiked;
@property (nonatomic, strong) NSString *feedType;

/**
 *  feedDetail的类型
 */
@property (nonatomic, strong) NSString *feedCategory;

@end
