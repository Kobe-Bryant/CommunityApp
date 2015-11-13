//
//  HomeFeedsModel.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/11/26.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeFeedsModel : NSObject

@property (nonatomic, strong) NSString *feedId;         //关注id
@property (nonatomic, strong) NSString *feedType;       //动态类型
@property (nonatomic, strong) NSString *linkId;         //关联类容id
@property (nonatomic, strong) NSString *title;          //主题
@property (nonatomic, strong) NSString *icon;           //发布人头像
@property (nonatomic, strong) NSString *time;           //发布时间
@property (nonatomic, strong) NSString *content;        //内容
@property (nonatomic, strong) NSString *commentCount;   //评论数量
@property (nonatomic, strong) NSString *likeCount;      //赞数量
@property (nonatomic, strong) NSString *isLiked;        //是否
@property (nonatomic, strong) NSString *detailUrl;      //详情url

@property (nonatomic, strong) NSString *feedCity;       //信息流城市

@property (nonatomic, strong) NSMutableArray *images;   //图片  url数组

@end
