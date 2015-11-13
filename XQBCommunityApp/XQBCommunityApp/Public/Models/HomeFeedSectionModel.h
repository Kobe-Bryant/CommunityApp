//
//  HomeFeedSectionModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/12.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQBHomeFeedDetailModel.h"
/**
 *  信息流块列表 ,一段时间的homefeed
 */
@interface HomeFeedSectionModel : NSObject

@property (nonatomic, strong) NSString* ptime;     //发布时间
@property (nonatomic, strong) NSMutableArray *homeFeedDetails;

@end
