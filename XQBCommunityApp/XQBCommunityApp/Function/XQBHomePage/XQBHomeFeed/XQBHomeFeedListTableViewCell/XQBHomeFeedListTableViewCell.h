//
//  XQBHomeFeedListTableViewCell.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/12.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFeedSectionModel.h"

typedef void(^XQBHomeFeedCellHandleBlock)(HomeFeedSectionModel *sectionModel,NSInteger index);

@interface XQBHomeFeedListTableViewCell : UITableViewCell

@property (nonatomic, strong) HomeFeedSectionModel *sectionModel;

@property (nonatomic, strong) XQBHomeFeedCellHandleBlock feedCellHandleBlock;

@end
