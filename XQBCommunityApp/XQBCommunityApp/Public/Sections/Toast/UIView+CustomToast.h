//
//  UIView+CustomToast.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/2.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface UIView (CustomToast)

- (void)makeCustomToast:(NSString *)message;

- (void)makeCustomToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position;

@end
