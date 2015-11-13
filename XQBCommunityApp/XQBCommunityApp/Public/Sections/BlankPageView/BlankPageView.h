//
//  BlankPageView.h
//  CommunityAPP
//
//  Created by Oliver on 14-10-15.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlankPageDidClickedBlock)(void);

@interface BlankPageView : UIView

@property (nonatomic, copy) BlankPageDidClickedBlock blankPageDidClickedBlock;

- (void)resetImage:(UIImage *)image;
- (void)resetImageFrame:(CGRect)frame;
- (void)resetTitle:(NSString *)title andDescribe:(NSString *)describe;
- (void)resetTitleFrame:(CGRect)titleFrame andDescribeFrame:(CGRect)describeFrame;
//增加一个自定义的view让其随意添加

@end
