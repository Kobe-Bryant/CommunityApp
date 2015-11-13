//
//  XQBHomeIconMenu.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/31.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQBHomeIconItem.h"

typedef void(^XQBHomeMenuItemHandleBlock)(NSInteger index, XQBHomeIconItem *item);

@interface XQBHomeIconMenu : UIView

- (instancetype)initWithItmes:(NSArray *)items;

@property (nonatomic, copy) NSArray *menuItems;

@property (nonatomic, copy) XQBHomeMenuItemHandleBlock menuItemHandleBlock;

@end
