//
//  XQBTabPickerView.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBTabPickerView.h"
#import "XQBUIFormatMacros.h"
#import "Global.h"
#import "BlockBackground.h"

#define PICKERVIEW_HEIGHT       216
#define TOOLBAR_HEIGHT          44

@interface XQBTabPickerView ()

@property (nonatomic, copy) XQBPickerCompleteBlock pickerCompleteBlock;
@property (nonatomic, copy) XQBPickerCompleteBlock pickerCancelBlock;

@end

@implementation XQBTabPickerView

- (void)dealloc{
    
}

+ (instancetype)initalize{
    return [[self alloc] init];
}

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PICKERVIEW_HEIGHT+TOOLBAR_HEIGHT)];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        //上下班时间选择器
        _accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
        [_accessoryView setBarStyle:UIBarStyleDefault];
        _accessoryView.barTintColor = XQBColorGreen;
        [_accessoryView sizeToFit];
        [self addSubview:_accessoryView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 44, 44);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
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
        doneButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [doneButton addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        //UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithCustomView:label];
        UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
        UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        [_accessoryView setItems:[NSArray arrayWithObjects:buttonCancel,buttonflexible,buttonDone, nil]];
        
        //to do sth about pickerView
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_accessoryView.frame), SCREEN_WIDTH, PICKERVIEW_HEIGHT)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerView];
    }
    return self;
}

- (void)showPickerView{
    
    [BlockBackground sharedInstance].vignetteBackground = YES;
    [[BlockBackground sharedInstance] addToMainWindow:self];
    //[BlockBackground sharedInstance].backgroundImage = [UIImage imageNamed:@"home_background.png"];
    CGRect frame = self.frame;
    frame.origin.y = [BlockBackground sharedInstance].bounds.size.height;
    self.frame = frame;
    
    __block CGPoint center = self.center;
    center.y -= CGRectGetHeight(self.frame);
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [BlockBackground sharedInstance].alpha = 1.0f;
                         self.center = center;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              self.center = center;
                                          } completion:nil];
                     }];
    
}

- (void)dismissPickerView{
    CGPoint center = self.center;
    center.y += CGRectGetHeight(self.frame);
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.center = center;
                         [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
                     } completion:^(BOOL finished) {
                         [[BlockBackground sharedInstance] removeView:self];
                     }];
}


- (void)setPickComplete:(XQBPickerCompleteBlock)block{
    self.pickerCompleteBlock = block;
    
}

- (void)setPickCancel:(XQBPickerCompleteBlock)block{
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
