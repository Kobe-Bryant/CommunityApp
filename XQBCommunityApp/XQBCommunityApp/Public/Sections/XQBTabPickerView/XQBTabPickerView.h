//
//  XQBTabPickerView.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^XQBPickerCompleteBlock)(NSString *result);

@interface XQBTabPickerView : UIView

+ (instancetype)initalize;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIToolbar    *accessoryView;

- (void)showPickerView;

- (void)setPickComplete:(XQBPickerCompleteBlock)block;
- (void)setPickCancel:(XQBPickerCompleteBlock)block;


@end
