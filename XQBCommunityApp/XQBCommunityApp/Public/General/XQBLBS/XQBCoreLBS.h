//
//  XQBCoreLBS.h
//  CommunityAPP
//
//  Created by City-Online on 14/11/7.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface XQBCoreLBS : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, assign, getter=isAvailableLocationServices) BOOL availableLocationServices;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *checkinLocation;

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
