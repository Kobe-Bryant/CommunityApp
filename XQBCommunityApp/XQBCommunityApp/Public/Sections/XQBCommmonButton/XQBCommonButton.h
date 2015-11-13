//
//  XQBCommonButton.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/15.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XQBActionHandleBlock)(NSInteger index);

@interface XQBCommonButton : UIButton

@property (nonatomic, strong) XQBActionHandleBlock actionHandleBlock;

@end
