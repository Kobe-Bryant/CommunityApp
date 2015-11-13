//
//  XQBTabDatePickerView.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/13.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQBTabPickerView.h"

@interface XQBTabDatePickerView : UIView

+ (instancetype)initalize;

@property (nonatomic, strong) UIDatePicker *dataPicker;
@property (nonatomic, strong) UIToolbar    *accessoryView;

- (void)showPickerView;

- (void)setPickComplete:(XQBPickerCompleteBlock)block;
- (void)setPickCancel:(XQBPickerCompleteBlock)block;

@end
