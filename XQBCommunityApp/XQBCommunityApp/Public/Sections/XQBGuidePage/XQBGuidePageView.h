//
//  XQBGuidePageView.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 15/1/8.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQBGuidePageView : UIView

@property (nonatomic, strong) UIButton *startButton;

- (id)initWithImages:(NSArray *)imagesArray;
- (id)initWithImages:(NSArray *)imagesArray andMargin:(NSInteger)margin;
- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)imagesArray;
- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)imagesArray andMargin:(NSInteger)margin;

- (void)setStartButtonHidden:(BOOL)hidden;

@end
