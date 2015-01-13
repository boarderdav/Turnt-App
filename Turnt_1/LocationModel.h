//
//  LocationModel.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/4/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationModelDelegate <NSObject>

@required
-(void) didUpdateToLocation:(CLLocation*)newLocation
               fromLocation:(CLLocation*)oldLocation;
@end

@interface LocationModel : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocationDegrees Lattitude;
    CLLocationDegrees Longitude;
}

@property(nonatomic,strong) id<LocationModelDelegate> delegate;

@property(nonatomic) BOOL updatedThisSession;
@property(nonatomic) int updateCounter;
@property(nonatomic) CLLocationDegrees Lattitude;
@property(nonatomic) CLLocationDegrees Longitude;

+(id)getSharedInstance;
-(void)startUpdating;
-(void) stopUpdating;

@end
