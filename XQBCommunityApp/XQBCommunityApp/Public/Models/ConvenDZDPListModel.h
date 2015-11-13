//
//  ConvenDZDPListModel.h
//  XQBCommunityApp
//
//  Created by City-Online-1 on 14/12/30.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvenDZDPListModel : NSObject

@property (nonatomic, strong) NSString *businessIdString;
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) NSString *addressString;
@property (nonatomic, strong) NSString *telephoneString;
@property (nonatomic, strong) NSString *cityString;
@property (nonatomic, strong) NSString *latitudeString;
@property (nonatomic, strong) NSString *longitudeString;
@property (nonatomic, strong) NSString *avg_ratingString;
@property (nonatomic, strong) NSString *distanceString;
@property (nonatomic, strong) NSString *s_photo_urlString;
@property (nonatomic, strong) NSString *business_urlString;

@property (nonatomic, strong) NSArray *categoriesArray;
@property (nonatomic, strong) NSArray *regionsArray;

@end
