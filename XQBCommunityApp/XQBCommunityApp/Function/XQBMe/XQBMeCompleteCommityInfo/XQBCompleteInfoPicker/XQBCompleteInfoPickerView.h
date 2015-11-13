//
//  XQBCompleteInfoPickerView.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/8.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XQBCompleteInfoCompleteBlock)(NSString *result);

@interface XQBCompleteInfoPickerView : UIView

+ (instancetype)initalize;

@property (nonatomic, strong) UIPickerView *pickerView;

- (void)showPickerView;

- (void)setPickComplete:(XQBCompleteInfoCompleteBlock)block;
- (void)setPickCancel:(XQBCompleteInfoCompleteBlock)block;

@end
