//
//  XQBPush.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/9.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQBPush : NSObject

+ (instancetype)shareInstance;

@property (nonatomic) BOOL pushAvailable;   //同送有效

@property (nonatomic) BOOL pushBadge;       //推送徽标      << 0
@property (nonatomic) BOOL pushSound;       //推送声音      << 1
@property (nonatomic) BOOL pushAlert;       //推送横幅      << 2



@end
