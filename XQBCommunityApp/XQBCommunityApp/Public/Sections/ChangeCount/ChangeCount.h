//
//  ChangeCount.h
//  CommunityAPP
//
//  Created by Oliver on 14-9-12.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AchieveValueHandleBlock)(NSInteger tag, NSInteger count);


@interface ChangeCount : UIView

@property (nonatomic, strong) AchieveValueHandleBlock changeCountHandleBlock;
@property (nonatomic, strong) AchieveValueHandleBlock achieveMaxValueBlock;
@property (nonatomic, strong) AchieveValueHandleBlock achieveMinValueBlock;

- (void)setCount:(NSInteger)count;
- (NSInteger)getCount;

- (void)setMaximumValue:(NSInteger)maxValue;        //none max
- (void)setMinimumValue:(NSInteger)minValue;        //default is 1

@end
