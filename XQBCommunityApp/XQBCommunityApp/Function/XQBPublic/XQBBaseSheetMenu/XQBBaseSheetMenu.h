//
//  XQBBaseSheetMenu.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/20.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "SGSheetMenu.h"

@interface XQBBaseSheetMenu : SGBaseMenu

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles;

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles subTitles:(NSArray *)subTitles;

@property (nonatomic, assign) NSUInteger selectedItemIndex;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
