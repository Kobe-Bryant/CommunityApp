//
//  DateSelectPopUpView.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/25.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DateDidSelectedBlock)(NSInteger year, NSInteger month);

@interface DateSelectPopUpView : UIView

@property (nonatomic, copy) DateDidSelectedBlock dateDidSelectedBlock;


- (instancetype)initWithYearItems:(NSArray *)yearItems andMonthItems:(NSArray *)monthItems;

- (void)showInWindow;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view withOffset:(UIOffset)offset;

- (void)dismiss;
- (void)dismissWithAnimated:(BOOL)animated;

@end
