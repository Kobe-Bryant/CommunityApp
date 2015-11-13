//
//  CustomTextField.h
//  CommunityAPP
//
//  Created by City-Online-1 on 14/11/10.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, CustomTextFieldType) {
    CustomTextFieldTypeCustom = 0,              //自定义第三格
    CustomTextFieldTypeNone,                    //第三格没有其他东西
    CustomTextFieldTypeAuthCode,                //第三格是验证码
    CustomTextFieldTypeCheck,                   //第三格是核对输入信息
};                                              //default is CustomTextFieldTypeNone


@protocol CustomTextFieldDelegate <NSObject>
@optional
//验证码
- (void)customTextField:(UITextField *)textField rightButtonClicked:(UIButton *)button;

@end



@interface CustomTextField : UIView

@property (nonatomic, strong) NSString *leftLabelString;
@property (nonatomic, strong) NSString *middleTextFieldPlaceholder;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, strong) UIView *rightCustomView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, assign) CustomTextFieldType textFieldType;

@property (nonatomic, strong) id <CustomTextFieldDelegate> delegate;



//只有当textFieldType为CustomTextFieldTypeAuthCode才有效
//“获取验证码”的定时器时间
@property (nonatomic, assign) NSInteger timeCount;



//只有当textFieldType为CustomTextFieldTypeCheck才有效
@property (nonatomic, strong) NSString *checkTrueString;
@property (nonatomic, strong) NSString *checkFalseString;


- (void)textFieldBecomeFirstResponder;
- (void)textFieldResignFirstResponder;
- (NSString *)getMiddleTextFieldText;

//指定middleTextField的delegate
- (void)setMiddleTextFieldDelegate:(id)delegate;


//只有当textFieldType为CustomTextFieldTypeAuthCode才有效
//“获取验证码”开始定时器
- (void)startAuthCodeTimmer;
- (void)stopAuthCodeTimmer;



//只有当textFieldType为CustomTextFieldTypeCheck才有效
- (void)changeRightButtonSelected:(BOOL)isSelected;

@end
