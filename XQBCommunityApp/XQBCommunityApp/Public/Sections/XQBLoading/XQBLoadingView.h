//
//  XQBLoadingView.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/23.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQBLoadingView;
typedef void (^LoadingBlock)(XQBLoadingView *refreshView);

@interface XQBLoadingView : UIView

+ (instancetype)showLoadingAddedToWindow;
+ (instancetype)showLoadingAddedToView:(UIView *)view;
+ (instancetype)showLoadingAddedToView:(UIView *)view withOffset:(UIOffset)offset;
+ (instancetype)showLoadingAddedToView:(UIView *)view withBeginBlock:(LoadingBlock)beginLoadingBlock;
+ (instancetype)showLoadingAddedToView:(UIView *)view withOffset:(UIOffset)offset andBeginBlock:(LoadingBlock)beginLoadingBlock;

+ (BOOL)hideLoadingForWindow;
+ (BOOL)hideLoadingForView:(UIView *)view;
+ (BOOL)hideLoadingForView:(UIView *)view withEndBlock:(LoadingBlock)endLoadingBlock;

+ (instancetype)loadingForView:(UIView *)view;


- (id)initWithView:(UIView *)view;
- (id)initWithView:(UIView *)view andOffset:(UIOffset)offset;
- (void)showLoading;
- (void)showLoadingWithBlock:(LoadingBlock)beginLoadingBlock;
- (void)hideLoading;
- (void)hideLoadingWithBlock:(LoadingBlock)endLoadingBlock;

@end
