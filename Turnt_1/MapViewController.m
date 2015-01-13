//
//  DEMOSecondViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MapViewController.h"
#import "PersonAnnotation.h"
#import "FriendsModel.h"

@interface MapViewController ()


@end



@implementation MapViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Make this controller the delegate for the map view.
    mapView.delegate = self;
    
    // Ensure that you can view your own location in the map view.
    [mapView setShowsUserLocation:YES];
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    //if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    //    [locationManager requestAlwaysAuthorization];
    //}
    [self requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    
    //Set some parameters for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    // Put annotations on the map:
    
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    for (PFUser *u in SharedFriendsModel.Friends) {
    
        PFGeoPoint *Coord = u[@"CurrentLocation"];
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(Coord.latitude, Coord.longitude);
        PersonAnnotation *annoation = [[PersonAnnotation alloc] initWithTitle:u[@"username"] Location:loc];
        [mapView addAnnotation:annoation];
    }
    
    

}


-(void)mapView:(MKMapView *)amapView didUpdateUserLocation:(MKUserLocation *)userLocation{
 
    CLLocationCoordinate2D coord = amapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    
    [mapView setRegion:region animated:YES];
    
}


- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

#pragma mark - MKMapViewDelegate methods.
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
    
    
    [mv setRegion:region animated:YES];
}

@end
