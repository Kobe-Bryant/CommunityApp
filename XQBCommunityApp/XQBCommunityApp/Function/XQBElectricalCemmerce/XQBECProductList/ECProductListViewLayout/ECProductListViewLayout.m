//
//  ECProductListViewLayout.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/9.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "ECProductListViewLayout.h"

@implementation ECProductListViewLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0);
    }
    return self;
}

@end
