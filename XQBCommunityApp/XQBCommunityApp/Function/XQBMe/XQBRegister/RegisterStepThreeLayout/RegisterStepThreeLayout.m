//
//  RegisterStepThreeLayout.m
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/1.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "RegisterStepThreeLayout.h"

@implementation RegisterStepThreeLayout

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
