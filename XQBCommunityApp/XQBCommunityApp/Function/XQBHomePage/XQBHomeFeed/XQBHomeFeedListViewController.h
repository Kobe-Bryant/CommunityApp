//
//  XQBHomeFeedListViewController.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/12.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBBaseViewController.h"
#import "HomeFeedsModel.h"

#define SECTION_TOP_NEWS_HEIGHT                     170
#define SECTION_TOP_NEWS_CONTENT_HEIGHT             150
#define SECTION_NORMAL_NEWS_HEIGHT                  60

@interface XQBHomeFeedListViewController : XQBBaseViewController

@property (nonatomic, strong) HomeFeedsModel *feedModel;   //类型(feedType)

@end
