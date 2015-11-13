//
//  CityArearListViewController.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/19.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBBaseViewController.h"
#import "CityDistrictsModel.h"

typedef void(^CMSSCityDistrictsBlock)(CityDistrictsModel *districtModel);

@interface CityArearListViewController : XQBBaseViewController

@property (nonatomic, strong) CMSSCityDistrictsBlock distanceDidSelectedCompleteBlock;

@end
