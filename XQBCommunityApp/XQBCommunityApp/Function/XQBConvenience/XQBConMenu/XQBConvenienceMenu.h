//
//  XQBConvenienceMenu.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/24.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQBConvenienceMenuItem.h"

typedef void(^XQBConvenienceMenuItemHandleBlock)(NSInteger index, NSString *menuItemTitle);

@interface XQBConvenienceMenu : UIView

- (instancetype)initWithItmes:(NSArray *)items;

@property (nonatomic, copy) XQBConvenienceMenuItemHandleBlock menuItemHandleBlock;

@end
