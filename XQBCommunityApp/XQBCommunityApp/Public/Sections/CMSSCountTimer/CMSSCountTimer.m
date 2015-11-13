//
//  CMSSCountTimer.m
//  CountTime
//
//  Created by City-Online on 14/10/24.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "CMSSCountTimer.h"


@interface CMSSCountTimer (){
    dispatch_source_t _timer;
    NSTimeInterval timeUserValue;
    int suspend_cnt;
}

@property (nonatomic, strong) CMSSCountEndBlock endBlock;
@property (nonatomic, strong) CMSSCountingBlock countingBlock;

@end


@implementation CMSSCountTimer

- (void)dealloc{
    _endBlock = nil;
    _countEndBlock = nil;
    _countingBlock = nil;
    dispatch_source_cancel(_timer);
    //[super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        if (_timer) {
            long result = dispatch_source_testcancel(_timer);
            if (result) {
                [self setup];
            }
        }else{
            [self setup];
        }
    }
    return self;
}


- (void)setup{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    suspend_cnt = 1;
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeUserValue<=0){ //倒计时结束，关闭
            NSLog(@"_____cancel");
            [self pause];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if (self.endBlock) {
                    self.endBlock(timeUserValue);
                }
            });
        }else{
            //            int minutes = timeout / 60;
            int second = (int)timeUserValue  % 60;
            int minute = ((int)timeUserValue / 60) % 60;
            int hours = timeUserValue / 3600;
            //return [NSString stringWithFormat:@"%02dh %02dm %02ds",hours,minute,second];
            NSString *strTime = [NSString stringWithFormat:@"%02dh %02dm %02ds",hours,minute,second];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                if (self.countingBlock) {
                    self.countingBlock(hours,minute,second);
                }
            });
            timeUserValue--;
        }
    });
}


#pragma mark ---Timer control methods to use

-(void)start{
    //__block int timeout=30; //倒计时时间


    //size_t estimated = dispatch_source_get_data(_timer);
    //size_t debugAttr = _dispatch_object_debug_attr(_timer);
    if (suspend_cnt > 0) {
        [self resume];
    }
    
}
#if NS_BLOCKS_AVAILABLE
-(void)startWithEndingBlock:(CMSSCountEndBlock)endBlock{
    //[self start];
    self.endBlock = endBlock;
}

-(void)startWithCountingBlock:(CMSSCountingBlock)countingBlock{
    //[self start];
    self.countingBlock = countingBlock;
}

#endif
-(void)pause{
    NSLog(@"suspend->suspend_cnt :%d",suspend_cnt);
    if (suspend_cnt == 0) {
        dispatch_suspend(_timer);
        suspend_cnt++;
    }

}
-(void)resume{
    NSLog(@"resume->suspend_cnt :%d",suspend_cnt);
    if (suspend_cnt > 0) {
        dispatch_resume(_timer);
        suspend_cnt--;
    }

}

- (void)free{
    dispatch_source_set_cancel_handler(_timer, ^{
        
    });
    
    dispatch_source_cancel(_timer);
    //dispatch_release(_timer);
    
}

#pragma mark ---set method
-(void)setCountDownTime:(NSTimeInterval)time{
    timeUserValue = (time < 0)? 0 : time;
}

@end
