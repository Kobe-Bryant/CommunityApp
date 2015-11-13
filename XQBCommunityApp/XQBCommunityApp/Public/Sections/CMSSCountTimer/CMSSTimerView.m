//
//  CMSSTimerView.m
//  CountTime
//
//  Created by City-Online on 14/10/24.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "CMSSTimerView.h"
#import "Global.h"

@interface CMSSTimerView ()

@property (nonatomic, strong) UILabel *hoursLabel;
@property (nonatomic, strong) UILabel *minutesLabel;
@property (nonatomic, strong) UILabel *secondsLabel;

@end

@implementation CMSSTimerView

- (void)dealloc{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"count_time_background"]];
        _hoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
        _hoursLabel.layer.cornerRadius = 3.0;
        _hoursLabel.layer.masksToBounds = YES;
        _hoursLabel.textColor = [UIColor whiteColor];
        _hoursLabel.textAlignment = NSTextAlignmentCenter;
        _hoursLabel.font = [UIFont systemFontOfSize:11];
        _hoursLabel.backgroundColor = XQBColorOrange;//color;
        _hoursLabel.text = @"00";
        [self addSubview:_hoursLabel];
        
        _minutesLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 20, 15)];
        _minutesLabel.layer.cornerRadius = 3.0;
        _minutesLabel.layer.masksToBounds = YES;
        _minutesLabel.textColor = [UIColor whiteColor];
        _minutesLabel.textAlignment = NSTextAlignmentCenter;
        _minutesLabel.font = [UIFont systemFontOfSize:11];
        _minutesLabel.backgroundColor = XQBColorOrange; //color;
        _minutesLabel.text = @"00";
        [self addSubview:_minutesLabel];
        
        _secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 20, 15)];
        _secondsLabel.layer.cornerRadius = 3.0;
        _secondsLabel.layer.masksToBounds = YES;
        _secondsLabel.text = @"00";
        _secondsLabel.textColor = [UIColor whiteColor];
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
        _secondsLabel.font = [UIFont systemFontOfSize:11];
        _secondsLabel.backgroundColor = XQBColorOrange;//color;
        [self addSubview:_secondsLabel];
        
    }
    return self;
}

- (void)setHours:(NSInteger)hours{
    if (hours <= 0) {
        _hoursLabel.text = @"00";
    }else{
        _hoursLabel.text = [NSString stringWithFormat:@"%02ld",hours];
    }
}

- (void)setMinutes:(NSInteger)minutes{
    _minutes = minutes;
    if (minutes <= 0) {
        _minutesLabel.text = @"00";
    }else{
        _minutesLabel.text = [NSString stringWithFormat:@"%02ld",_minutes];
    }
}


- (void)setSeconds:(NSInteger)seconds{
    _seconds = seconds;
    if (_seconds <= 0) {
        _secondsLabel.text = @"00";
    }else{
        _secondsLabel.text = [NSString stringWithFormat:@"%02ld",_seconds];
    }
}


@end
