//
//  CMSSTimerView.h
//  CountTime
//
//  Created by City-Online on 14/10/24.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    CMSSTypeStopWatch,
    CMSSTypeTimer
}CMSSTimeType;

@interface CMSSTimerView : UIView

@property (nonatomic) NSInteger hours;

@property (nonatomic) NSInteger minutes;

@property (nonatomic) NSInteger seconds;


@end
