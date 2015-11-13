//
//  XQBHomeAdsControl.m
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/5.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBHomeAdsControl.h"
#import "Global.h"

@interface XQBHomeAdsControl ()


@property (nonatomic, strong) UIButton *dismissButton;

@end

@implementation XQBHomeAdsControl

- (void)dealloc{

}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        //self.transform = CGAffineTransformMakeTranslation(0, -(TOP(self)+HEIGHT(self)));
        [self addSubview:self.cycleScrollView];
        
        [self addSubview:self.dismissButton];
        self.dismissButton.hidden = YES;
        /*
        NSMutableArray *viewsArray = [@[] mutableCopy];
        NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor]];
        for (int i = 0; i < [colorArray count]; ++i) {
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
            tempLabel.backgroundColor = [(UIColor *)[colorArray objectAtIndex:i] colorWithAlphaComponent:0.5];
            [viewsArray addObject:tempLabel];
        }
        
        self.cycleScrollView = [[CycleScrollView alloc] initWithFrame:self.bounds animationDuration:3];
        
        self.cycleScrollView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        
        self.cycleScrollView.totalPagesCount = ^NSInteger(void){
            return viewsArray.count;
        };
        self.cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        self.cycleScrollView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了第%ld个",pageIndex);
        };
        [self addSubview:self.cycleScrollView];
         */
        
    }
    return self;
}

- (UIButton *)dismissButton{
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH(self)-40, 5, 30, 30)];
        [_dismissButton setBackgroundImage:[UIImage imageNamed:@"home_menu_play_close.png"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(closeAdHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}


- (CycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[CycleScrollView alloc] initWithFrame:self.bounds animationDuration:8.0];
    }
    return _cycleScrollView;
}
 
- (void)closeAdHandle:(UIButton *)sender{
    [self dismiss];
}

- (void)show{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                          } completion:^(BOOL finished) {
                              
                          }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                          self.transform = CGAffineTransformMakeTranslation(0, -(TOP(self)+HEIGHT(self)));
                     } completion:^(BOOL finished) {
                         if (finished) {
                             if (self.superview) {
                                 [self removeFromSuperview];
                             }
                         }
                     }];
}

@end
