//
//  XQBCoreLBS.m
//  CommunityAPP
//
//  Created by City-Online on 14/11/7.
//  Copyright (c) 2014年 City-Online. All rights reserved.
//

#import "XQBCoreLBS.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>


@interface XQBCoreLBS ()<CLLocationManagerDelegate,AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation XQBCoreLBS


+ (instancetype)shareInstance{
    
    static XQBCoreLBS *instance = nil;
    if (instance == nil) {
        instance = [[XQBCoreLBS alloc] init];
    }
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //默认深圳的经纬度
        self.availableLocationServices = YES;
        _coordinate.latitude = 22.548839f;
        _coordinate.longitude = 114.050742f;
        self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:nil];
        self.search.delegate = self;
        self.cityName = @"深圳";
        [self setupLocationManager];
    }
    return self;
}


- (void) setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        // TODO: Remember to add the NSLocationWhenInUseUsageDescription plist key
        [self.locationManager requestWhenInUseAuthorization];
        //[self.locationManager requestAlwaysAuthorization];
    }

    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog( @"Cannot Starting CLLocationManager" );
        /*self.locationManager.delegate = self;
         self.locationManager.distanceFilter = 200;
         locationManager.desiredAccuracy = kCLLocationAccuracyBest;
         [self.locationManager startUpdatingLocation];*/
    }
}

#pragma mark ---CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.availableLocationServices = YES;
    self.checkinLocation = newLocation;
    _coordinate.longitude = self.checkinLocation.coordinate.longitude;
    _coordinate.latitude = self.checkinLocation.coordinate.latitude;
    //do something else
    
    [self searchReGeocode];
}

- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    self.availableLocationServices = NO;
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
        }
}


- (void)searchReGeocode
{
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:self.checkinLocation.coordinate.latitude longitude:self.checkinLocation.coordinate.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    [self.search AMapReGoecodeSearch: regeoRequest];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
    NSLog(@"ReGeo: %@", result);
    self.cityName = response.regeocode.addressComponent.city;
    if ([self.cityName hasSuffix:@"市"]) {
        
        self.cityName = [self.cityName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"市"]];
    }
    NSLog(@"city-->%@",self.cityName);
}

@end
