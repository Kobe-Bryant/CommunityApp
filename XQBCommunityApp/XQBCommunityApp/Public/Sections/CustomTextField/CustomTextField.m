//
//  CustomTextField.m
//  CommunityAPP
//
//  Created by City-Online-1 on 14/11/10.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "CustomTextField.h"
#import "Global.h"


static const CGFloat kLabelWidth        = 100.0f - XQBMarginHorizontal;
static const CGFloat kViewWidth         = 90.0f - XQBMarginHorizontal;

static const int kTimeCount             = 60;

@interface CustomTextField ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UITextField *middleTextField;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *spaceLineView;

@property (nonatomic, strong) UIButton *authCodeButton;
@property (nonatomic, strong) NSTimer *authCodeTimer;

@property (nonatomic, strong) UIButton *checkButton;



@end

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _textFieldType = CustomTextFieldTypeNone;
        _timeCount = kTimeCount;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(XQBMarginHorizontal, 0, kLabelWidth, self.frame.size.height)];
        _leftLabel.text = @"内容";
        _leftLabel.font = XQBFontContent;
        _leftLabel.textColor = XQBColorContent;
        [self addSubview:_leftLabel];
        
        _middleTextField = [[UITextField alloc] initWithFrame:CGRectMake(XQBMarginHorizontal+kLabelWidth, 0, MainWidth - XQBMarginHorizontal*2 - kLabelWidth, self.frame.size.height)];
        _middleTextField.font = XQBFontContent;
        _middleTextField.placeholder = @"请输入内容";
        [self addSubview:_middleTextField];
        
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(MainWidth-XQBMarginHorizontal*2-kViewWidth, 0, kViewWidth+XQBMarginHorizontal, self.frame.size.height)];
        _rightView.hidden = YES;
        [self addSubview:_rightView];
        
        _spaceLineView = [[UIView alloc] initWithFrame:CGRectMake(MainWidth-XQBMarginHorizontal*2-kViewWidth-0.5, 3, 0.5, self.frame.size.height-3*2)];
        _spaceLineView.backgroundColor = XQBColorInternalSeparationLine;
        _spaceLineView.hidden = YES;
        [self addSubview:_spaceLineView];
        
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, MainWidth, 0.5)];
        _bottomLineView.backgroundColor = XQBColorElementSeparationLine;
        [self addSubview:_bottomLineView];
    }
    return self;
}

#pragma mark --- setter
- (void)setLeftLabelString:(NSString *)leftLabelString
{
    _leftLabel.text = leftLabelString;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _middleTextField.keyboardType = keyboardType;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _middleTextField.secureTextEntry = secureTextEntry;
}

- (void)setMiddleTextFieldPlaceholder:(NSString *)middleTextFieldPlaceholder
{
    _middleTextField.placeholder = middleTextFieldPlaceholder;
}

- (void)setCheckTrueString:(NSString *)checkTrueString
{
    if (_textFieldType == CustomTextFieldTypeCheck) {
        [_checkButton setTitle:checkTrueString forState:UIControlStateNormal];
    }
}

- (void)setCheckFalseString:(NSString *)checkFalseString
{
    if (_textFieldType == CustomTextFieldTypeCheck) {
        [_checkButton setTitle:checkFalseString forState:UIControlStateSelected];
    }
}

- (void)setTextFieldType:(CustomTextFieldType)textFieldType
{
    if (textFieldType == _textFieldType || _textFieldType == CustomTextFieldTypeCustom) {
        return;
    } else if (textFieldType == CustomTextFieldTypeNone) {
        _textFieldType = textFieldType;
        _rightView.hidden = YES;
        _spaceLineView.hidden = YES;
        _middleTextField.frame = CGRectMake(XQBMarginHorizontal+kLabelWidth, 0, MainWidth - XQBMarginHorizontal*2 - kLabelWidth, self.frame.size.height);
    } else {
        _textFieldType = textFieldType;
        _rightView.hidden = NO;
        _spaceLineView.hidden = NO;
        _middleTextField.frame = CGRectMake(XQBMarginHorizontal+kLabelWidth, 0, MainWidth - XQBMarginHorizontal*2 - kLabelWidth - kViewWidth - XQBMarginHorizontal, self.frame.size.height);
        
        if (textFieldType == CustomTextFieldTypeAuthCode) {
            _authCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _authCodeButton.frame = CGRectMake(XQBMarginHorizontal, 0, kViewWidth, self.frame.size.height);
            [_authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_authCodeButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
            [_authCodeButton.titleLabel setFont:XQBFontContent];
            [_authCodeButton.titleLabel setTextAlignment:NSTextAlignmentRight];
            [_authCodeButton.titleLabel setNumberOfLines:2];
            [_authCodeButton addTarget:self action:@selector(authCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            for (UIView *subView in _rightView.subviews) {
                [subView removeFromSuperview];
            }
            [_rightView addSubview:_authCodeButton];
        } else if (textFieldType == CustomTextFieldTypeCheck) {
            _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _checkButton.frame = CGRectMake(XQBMarginHorizontal, 0, kViewWidth, self.frame.size.height);
            [_checkButton setUserInteractionEnabled:NO];
            [_checkButton setTitle:@"恭喜可用" forState:UIControlStateNormal];
            [_checkButton setTitle:@"输入有误" forState:UIControlStateSelected];
            [_checkButton setImage:[UIImage imageNamed:@"register_agree"] forState:UIControlStateNormal];
            [_checkButton setImage:[UIImage imageNamed:@"register_not_agree"] forState:UIControlStateSelected];
            [_checkButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
            [_checkButton.titleLabel setFont:XQBFontContent];
            [_checkButton.titleLabel setTextAlignment:NSTextAlignmentRight];
            for (UIView *subView in _rightView.subviews) {
                [subView removeFromSuperview];
            }
            [_rightView addSubview:_checkButton];
        }
    }
}

- (void)setRightCustomView:(UIView *)rightCustomView{
    _rightCustomView = rightCustomView;
    if (_rightCustomView) {
        if (_textFieldType == CustomTextFieldTypeNone) {
            _rightView.hidden = NO;
            _spaceLineView.hidden = NO;
            _middleTextField.frame = CGRectMake(XQBMarginHorizontal+kLabelWidth, 0, MainWidth - XQBMarginHorizontal*2 - kLabelWidth - kViewWidth, self.frame.size.height);
        }
        _textFieldType = CustomTextFieldTypeCustom;
        for (UIView *subView in _rightView.subviews) {
            [subView removeFromSuperview];
        }
        [_rightView addSubview:_rightCustomView];
    }
}

#pragma mark --- action
- (void)authCodeButtonClicked
{
    _authCodeButton.userInteractionEnabled = NO;
    [_delegate customTextField:self.middleTextField rightButtonClicked:self.authCodeButton];
}

-(void)timerFired
{   //让按钮变成绿色可编辑状态
    NSString *str = [NSString stringWithFormat:@"%ld", --_timeCount];
    [_authCodeButton setTitle:[NSString stringWithFormat:@"%ld后重新获取", _timeCount] forState:UIControlStateNormal];
    [_authCodeButton setTitleColor:XQBColorExplain forState:UIControlStateNormal];
    
    if ([str isEqualToString:@"0"]) {
        [_authCodeTimer setFireDate:[NSDate distantFuture]];//关闭定时器
        _authCodeButton.userInteractionEnabled = YES;
        [_authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_authCodeButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
        [_authCodeButton addTarget:self action:@selector(authCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _timeCount = kTimeCount;
    }
}

#pragma mark --- 
- (void)changeRightButtonSelected:(BOOL)isSelected
{
    if (_textFieldType == CustomTextFieldTypeCheck) {
        _checkButton.selected = isSelected;
    }
}

- (void)setMiddleTextFieldDelegate:(id)delegate
{
    _middleTextField.delegate = delegate;
}

- (void)textFieldBecomeFirstResponder
{
    [_middleTextField becomeFirstResponder];
}

- (void)textFieldResignFirstResponder
{
    [_middleTextField resignFirstResponder];
}

- (NSString *)getMiddleTextFieldText
{
    return _middleTextField.text;
}

- (void)startAuthCodeTimmer
{
    _authCodeTimer = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(timerFired)userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_authCodeTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopAuthCodeTimmer
{
    [_authCodeTimer setFireDate:[NSDate distantFuture]];//关闭定时器
    _authCodeButton.userInteractionEnabled = YES;
    [_authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_authCodeButton setTitleColor:XQBColorContent forState:UIControlStateNormal];
    [_authCodeButton addTarget:self action:@selector(authCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _timeCount = kTimeCount;
}

@end
