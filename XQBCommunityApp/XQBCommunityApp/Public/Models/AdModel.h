//
//  AdModel.h
//  XQBCommunityApp
//
//  Created by City-Online on 14/12/5.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModel : NSObject

@property (nonatomic, strong) NSString *adId;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *link;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *productId;          //商城轮播图才用得到

@end
