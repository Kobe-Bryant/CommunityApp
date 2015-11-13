//
//  XQBVersionManager.h
//  XQBCommunityApp
//
//  Created by City-Online on 15/1/26.
//  Copyright (c) 2015年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQBVersionManager : NSObject

+ (instancetype)shareInstance;

- (void)checkVersionUpdate;

@end
