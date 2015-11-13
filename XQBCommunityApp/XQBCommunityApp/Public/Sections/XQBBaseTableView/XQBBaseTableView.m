//
//  XQBBaseTableView.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/15.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBBaseTableView.h"

@implementation XQBBaseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

@end
