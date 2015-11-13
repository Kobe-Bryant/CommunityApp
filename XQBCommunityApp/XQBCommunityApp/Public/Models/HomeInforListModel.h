//
//  HomeInforListModel.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/31.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeInforListModel : NSObject

@property (nonatomic, strong) NSString *infoId;         //id
@property (nonatomic, strong) NSString *title;          //主题
@property (nonatomic, strong) NSString *descp;          //内容
@property (nonatomic, strong) NSString *time;           //创建时间
@property (nonatomic, strong) NSString *icon;           //用户头像
@property (nonatomic, strong) NSString *likeCount;      //点赞数量
@property (nonatomic, strong) NSString *isLiked;        //该用户是否点赞
@property (nonatomic, strong) NSString *nickname;       //昵称
@property (nonatomic, strong) NSString *communityName;  //小区名称
@property (nonatomic, strong) NSString *detailUrl;      //详情链接
@property (nonatomic, strong) NSString *feedType;       //信息流类型

@property (nonatomic, strong) NSMutableArray *images;   //图片  ID  URL数组
/**
 *  feedDetail的类型
 */
@property (nonatomic, strong) NSString *feedCategory;     

@end
