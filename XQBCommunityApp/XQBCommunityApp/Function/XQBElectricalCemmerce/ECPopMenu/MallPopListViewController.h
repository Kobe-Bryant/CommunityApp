//
//  MallPopListViewController.h
//  CommunityAPP
//
//  Created by City-Online on 14-10-14.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "XQBBaseViewController.h"

typedef void(^MallPopMenuDidSlectedCompledBlock)(NSInteger index);

@interface MallPopListViewController : XQBBaseViewController

- (instancetype)initWithMenuItems:(NSArray *)items;

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, copy) MallPopMenuDidSlectedCompledBlock popMenuDidSlectedCompled;

@property (nonatomic, copy) MallPopMenuDidSlectedCompledBlock popMenuDidDismissCompled;

@end
