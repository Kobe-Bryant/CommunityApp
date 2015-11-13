//
//  XQBCompleteInfoPickerView.m
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/8.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import "XQBCompleteInfoPickerView.h"
#import "XQBUIFormatMacros.h"
#import "Global.h"
#import "BlockBackground.h"

#define PICKERVIEW_HEIGHT       216
#define TOOLBAR_HEIGHT          5

@interface XQBCompleteInfoPickerView ()


@property (nonatomic, strong) UIButton *buttonHolder;
@property (nonatomic, strong) UIView *pickerHolderView;
@property (nonatomic, strong) UIView    *accessoryView;
@property (nonatomic, copy) XQBCompleteInfoCompleteBlock pickerCompleteBlock;
@property (nonatomic, copy) XQBCompleteInfoCompleteBlock pickerCancelBlock;

@end


@implementation XQBCompleteInfoPickerView

- (void)dealloc{
    
}

+ (instancetype)initalize{
    return [[self alloc] init];
}

- (instancetype)init{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];;
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _buttonHolder = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonHolder.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-PICKERVIEW_HEIGHT-TOOLBAR_HEIGHT);
        [_buttonHolder addTarget:self action:@selector(cancelPickerHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buttonHolder];
        
        _pickerHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PICKERVIEW_HEIGHT+TOOLBAR_HEIGHT)];
        [self addSubview:_pickerHolderView];
        
        _accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
        _accessoryView.backgroundColor = XQBColorGreen;
        [_pickerHolderView addSubview:_accessoryView];
        //上下班时间选择器 
        /*
         _accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
         [_accessoryView setBarStyle:UIBarStyleDefault];
         _accessoryView.barTintColor = XQBColorBackground;
         [_accessoryView sizeToFit];
         [self addSubview:_accessoryView];
         
         UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
         cancelButton.frame = CGRectMake(10, 0, 44, 44);
         [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
         [cancelButton addTarget:self action:@selector(cancelHandle:) forControlEvents:UIControlEventTouchUpInside];
         
         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 190, 44)];
         label.backgroundColor = [UIColor clearColor];
         label.textAlignment = NSTextAlignmentCenter;
         label.font = [UIFont systemFontOfSize:14];
         label.textColor = [UIColor whiteColor];
         //label.text = [NSString stringWithFormat:@"%@ %@",[self.calendarDataSource objectAtIndex:0],[self.persiodTimeDatasource objectAtIndex:0]];
         
         UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
         doneButton.frame = CGRectMake(230, 0, 44, 44);
         [doneButton setTitle:@"完成" forState:UIControlStateNormal];
         doneButton.titleLabel.textAlignment = NSTextAlignmentRight;
         [doneButton addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
         
         UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
         //UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithCustomView:label];
         UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
         buttonflexible.width = 195;
         UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
         [_accessoryView setItems:[NSArray arrayWithObjects:buttonCancel,buttonflexible,buttonDone, nil]];
         */
        //to do sth about pickerView
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_accessoryView.frame), SCREEN_WIDTH, PICKERVIEW_HEIGHT)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_pickerHolderView addSubview:_pickerView];
    }
    return self;
}

- (void)showPickerView{
    
    [BlockBackground sharedInstance].vignetteBackground = YES;
    [[BlockBackground sharedInstance] addToMainWindow:self];
    //[BlockBackground sharedInstance].backgroundImage = [UIImage imageNamed:@"home_background.png"];
    CGRect frame = _pickerHolderView.frame;
    frame.origin.y = [BlockBackground sharedInstance].bounds.size.height;
    _pickerHolderView.frame = frame;
    
    __block CGPoint center = _pickerHolderView.center;
    center.y -= CGRectGetHeight(_pickerHolderView.frame);
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [BlockBackground sharedInstance].alpha = 1.0f;
                         _pickerHolderView.center = center;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              _pickerHolderView.center = center;
                                          } completion:nil];
                     }];
    
}

- (void)dismissPickerView{
    CGPoint center = self.center;
    center.y += CGRectGetHeight(_pickerHolderView.frame);
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _pickerHolderView.center = center;
                         [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
                     } completion:^(BOOL finished) {
                         [[BlockBackground sharedInstance] removeView:self];
                     }];
}

- (void)cancelPickerHandle:(UIButton *)sender{
    if (self.pickerCancelBlock) {
        self.pickerCancelBlock(@"");
    }
    [self dismissPickerView];
}


- (void)setPickComplete:(XQBCompleteInfoCompleteBlock)block{
    self.pickerCompleteBlock = block;
    
}

- (void)setPickCancel:(XQBCompleteInfoCompleteBlock)block{
    self.pickerCancelBlock = block;
    
}

- (void)cancelHandle:(UIButton *)sender{
    if (self.pickerCancelBlock) {
        self.pickerCancelBlock(@"");
    }
    [self dismissPickerView];
}

- (void)doneClicked:(UIButton *)sender{
    if (self.pickerCompleteBlock) {
        self.pickerCompleteBlock(@"done");
    }
    [self dismissPickerView];
}


@end
