//
//  ChangeCount.m
//  CommunityAPP
//
//  Created by Oliver on 14-9-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "ChangeCount.h"
#import "Global.h"

@interface ChangeCount () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UITextField *countTextField;
@property (nonatomic, strong) UILabel *toolbarLabel;

@property (nonatomic, assign) NSInteger maximumValue;
@property (nonatomic, assign) NSInteger minimumValue;
@property (nonatomic, strong) NSString *tmpcountTextString;

@end

@implementation ChangeCount

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
        [_minusButton setTitle:@"－" forState:UIControlStateNormal];
        [_minusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_minusButton.titleLabel setFont:[UIFont systemFontOfSize:self.frame.size.height]];
        [_minusButton.layer setMasksToBounds:YES];
        [_minusButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [_minusButton.layer setBorderWidth:0.5];
        [_minusButton addTarget:self action:@selector(minusButtonAction) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:_minusButton];
        
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusButton setFrame:CGRectMake(self.frame.size.width-self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
        [_plusButton setTitle:@"＋" forState:UIControlStateNormal];
        [_plusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_plusButton.titleLabel setFont:[UIFont systemFontOfSize:self.frame.size.height]];
        [_plusButton.layer setMasksToBounds:YES];
        [_plusButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [_plusButton.layer setBorderWidth:0.5];
        [_plusButton addTarget:self action:@selector(plusButtonAction) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:_plusButton];
        
        _countTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.height, 0, self.frame.size.width-self.frame.size.height*2, self.frame.size.height)];
        _countTextField.textColor = [UIColor grayColor];
        _countTextField.textAlignment = NSTextAlignmentCenter;
        _countTextField.keyboardType = UIKeyboardTypeNumberPad;
        _countTextField.inputAccessoryView = [self toolBarView];
        _countTextField.delegate = self;
        [_countTextField.layer setMasksToBounds:YES];
        [_countTextField.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [_countTextField.layer setBorderWidth:0.5];
        [self addSubview:_countTextField];
        
        _maximumValue = 999;
        _minimumValue = 0;
    }
    return self;
}

#pragma mark --- action
- (void)minusButtonAction
{
    NSInteger count = 0;
    if (![_countTextField.text isEqualToString:@"0"] && _countTextField.text.length != 0) {
        count = [_countTextField.text integerValue];
    }
    
    if (_minimumValue < count) {
        _countTextField.text = [NSString stringWithFormat:@"%ld", (long)--count];
        if (self.changeCountHandleBlock) {
            self.changeCountHandleBlock(self.tag, count);
        }
    } else {
        _countTextField.text = [NSString stringWithFormat:@"%ld", (long)_minimumValue];
        if (self.achieveMinValueBlock) {
            self.achieveMinValueBlock(self.tag, _minimumValue-1);
        }
    }
    _toolbarLabel.text = _countTextField.text;
}

- (void)plusButtonAction
{
    NSInteger count = 0;
    if (![_countTextField.text isEqualToString:@"0"] && _countTextField.text.length != 0) {
        count = [_countTextField.text integerValue];
    }
    
    if (count < _maximumValue) {
        _countTextField.text = [NSString stringWithFormat:@"%ld", (long)++count];
        if (self.changeCountHandleBlock) {
            self.changeCountHandleBlock(self.tag, count);
        }
    } else {
        _countTextField.text = [NSString stringWithFormat:@"%ld", (long)_maximumValue];
        if (self.achieveMaxValueBlock) {
            self.achieveMaxValueBlock(self.tag, _maximumValue+1);
        }
    }
    _toolbarLabel.text = _countTextField.text;
}

- (void)cancelClicked:(UIButton *)sender{
    [_countTextField resignFirstResponder];
    
    if (_toolbarLabel.text.length == 0 || [_toolbarLabel.text integerValue] < _minimumValue) {
        _countTextField.text = [NSString stringWithFormat:@"%ld", (long)_minimumValue];
        if (self.changeCountHandleBlock) {
            self.changeCountHandleBlock(self.tag, _minimumValue);
        }
    } else {
        _countTextField.text = _tmpcountTextString;
    }
}

- (void)doneClicked:(UIButton *)sender{
    [_countTextField resignFirstResponder];
    
    if (_toolbarLabel.text.length == 0 || [_toolbarLabel.text integerValue] < _minimumValue) {
        _countTextField.text = [NSString stringWithFormat:@"%ld", (long)_minimumValue];
        if (self.changeCountHandleBlock) {
            self.changeCountHandleBlock(self.tag, _minimumValue);
        }
    } else {
        _countTextField.text = _toolbarLabel.text;
        if (self.changeCountHandleBlock) {
            self.changeCountHandleBlock(self.tag, [_toolbarLabel.text integerValue]);
        }
    }
    
}

#pragma mark --- countTextField   setter getter
- (void)setCount:(NSInteger)count
{
    _countTextField.text = [NSString stringWithFormat:@"%ld", (long)count];
}

- (NSInteger)getCount
{
    return [_countTextField.text integerValue];
}

#pragma mark --- set  maxValue  minValue
- (void)setmaximumValue:(NSInteger)maxValue
{
    if (9999 < maxValue) {
        _maximumValue = 9999;
    } else if (maxValue < _minimumValue){
        _maximumValue = _minimumValue;
    } else {
        _maximumValue = maxValue;
    }
    
}

- (void)setMinimumValue:(NSInteger)minValue
{
    if (_maximumValue < minValue) {
        _minimumValue = _maximumValue;
    } else if (minValue < 0){
        _minimumValue = 0;
    } else {
        _minimumValue = minValue;
    }
}

#pragma mark --- textField inputAccessoryView
- (UIToolbar *)toolBarView
{
    UIToolbar *toolBarView = [[UIToolbar alloc] init];
    [toolBarView setBarStyle:UIBarStyleDefault];
    toolBarView.barTintColor = XQBColorGreen;
    [toolBarView sizeToFit];
    
    _toolbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 190, 44)];
    _toolbarLabel.backgroundColor = [UIColor clearColor];
    _toolbarLabel.textAlignment = NSTextAlignmentCenter;
    _toolbarLabel.font = [UIFont systemFontOfSize:14];
    _toolbarLabel.textColor = [UIColor whiteColor];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(10, 0, 44, 44);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(220, 0, 44, 44);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithCustomView:_toolbarLabel];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [toolBarView setItems:[NSArray arrayWithObjects:buttonCancel,buttonflexible,buttonDone, nil]];
    
    return toolBarView;
}

#pragma mark --- textField delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _toolbarLabel.text = _countTextField.text;
    _tmpcountTextString = [_countTextField.text copy];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([aString length] > 4) {
        if (range.length>0) {
            return YES;
        }
        return NO;
    } else {
        if (_maximumValue < [aString integerValue]) {
            if (self.achieveMaxValueBlock) {
                self.achieveMaxValueBlock(self.tag, [aString integerValue]);
            };
            return NO;
        } else {
            _toolbarLabel.text = aString;
            return YES;
        }
    }
}

@end
