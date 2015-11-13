//
//  ConvenienceListModel.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/29.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvenienceListModel : NSObject

@property (nonatomic, strong) NSString *lifeId;         //id
@property (nonatomic, strong) NSString *linkId;         //linkId
@property (nonatomic, strong) NSString *lifeTitle;      //主题
@property (nonatomic, strong) NSString *desc;           //内容
@property (nonatomic, strong) NSString *type;           //类型
@property (nonatomic, strong) NSString *icon;           //图片
@property (nonatomic, strong) NSString *likeCount;      //赞数量
@property (nonatomic, strong) NSString *isLiked;        //是否点赞过

@end
