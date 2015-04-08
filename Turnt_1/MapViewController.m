//
//  DEMOSecondViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MapViewController.h"

#import "PersonAnnotation.h"
#import "PartyAnnotation.h"
#import "FriendsModel.h"
#import "LocationTracker.h"
#import "LocationShareModel.h"
#import <Parse/Parse.h>

@interface MapViewController ()

//@property (strong, nonatomic) CCHMapClusterController *mapClusterController;

@end

@implementation MapViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Force the Navigation Bar Color
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = YES;
    searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    // Do any additional setup after loading the view, typically from a nib.
    
    // Refresh Friends
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    LocationShareModel *locationManager = [LocationShareModel sharedModel];
    CLLocationManager *locationTracker = [LocationTracker sharedLocationManager];
    
    [locationManager.Annotations removeAllObjects];
    [locationManager.VenueAnnotations removeAllObjects];
    //Make this controller the delegate for the location manager.
    //[locationManager.locationManager setDelegate:self];
    //[locationManager.locationManager startUpdatingLocation];
    
    //Make this controller the delegate for the map view.
    mapView.delegate = self;
    searchBar.delegate = self;
    // Ensure that you can view your own location in the map view.
    [mapView setShowsUserLocation:YES];

    //Set some parameters for the location object.
    //[locationManager.locationManager setDistanceFilter:kCLDistanceFilterNone];
    //[locationManager.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    // Get venues
    PFQuery *VenueQuery = [PFQuery queryWithClassName:@"Venue"];
    NSArray *Venues = [VenueQuery findObjects];
    for (PFObject *V in Venues) {
        PFGeoPoint *Coord = V[@"Location"];
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(Coord.latitude, Coord.longitude);
        
        int Guys = [[V objectForKey:@"Guys"] integerValue];
        int Girls = [[V objectForKey:@"Girls"] integerValue];
        NSString *Attendance = [NSString stringWithFormat:@"Guys: %d Girls: %d", Guys, Girls];
        PartyAnnotation *annoation = [[PartyAnnotation alloc] initWithTitle:V[@"Name"] subTitle:Attendance Location:loc];
        [locationManager.VenueAnnotations addObject:annoation];
        
    }
    
    // Put annotations on the map:
    for (PFUser *u in SharedFriendsModel.Friends) {
    
        PFGeoPoint *Coord = u[@"CurrentLocation"];
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(Coord.latitude, Coord.longitude);
        NSString *locationName = u[@"LocationName"];
        PersonAnnotation *annoation;
        if ([locationName isEqualToString:@"Not near any marked locations"]) {
            annoation = [[PersonAnnotation alloc] initWithTitle:u[@"username"] subTitle:nil Location:loc];
        }
        else {
            annoation = [[PersonAnnotation alloc] initWithTitle:u[@"username"] subTitle:locationName Location:loc];
        }
        
        [locationManager.Annotations addObject:annoation];
    }
    
    // determines behavior of search bar based on which view is visible
    showVenues = NO;
    
    //self.mapClusterController = [[CCHMapClusterController alloc] initWithMapView:mapView];
    //[self.mapClusterController addAnnotations:locationManager.Annotations withCompletionHandler:NULL];
    [mapView addAnnotations:locationManager.Annotations];
    
    CLLocationCoordinate2D coord = locationTracker.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    
    [mapView setRegion:region animated:YES];

}

#pragma mark - Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)asearchBar {
    LocationShareModel *locationManager = [LocationShareModel sharedModel];
    
    if (showVenues == NO) {
        for (int i = 0; i < [locationManager.Annotations count]; i++)
        {
            for (id<MKAnnotation> ann in locationManager.Annotations)
            {
                if ([ann.title rangeOfString:[asearchBar text] options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    [mapView selectAnnotation:ann animated:YES];
                }
            }
        }
    }
    else if (showVenues == YES) {
        for (int i = 0; i < [locationManager.VenueAnnotations count]; i++)
        {
            for (id<MKAnnotation> ann in locationManager.VenueAnnotations)
            {
                if ([ann.title rangeOfString:[asearchBar text] options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    [mapView selectAnnotation:ann animated:YES];
                }
            }
        }
    }
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)asearchBar {
    [asearchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)asearchBar {
    asearchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)asearchBar {
    [asearchBar resignFirstResponder];
}

#pragma mark - Custom Map Actions

-(IBAction) refreshMap {
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    LocationShareModel *locationManager = [LocationShareModel sharedModel];

    switch (showVenues) {
        {case NO:
            [self removeAllPinsButUserLocation];
            [locationManager.Annotations removeAllObjects];
            //[self.mapClusterController removeAnnotations:locationManager.VenueAnnotations withCompletionHandler:NULL];
            //[self.mapClusterController addAnnotations:locationManager.Annotations withCompletionHandler:NULL];
            
            [SharedFriendsModel.Friends removeAllObjects];
            [SharedFriendsModel.FriendFullNames removeAllObjects];
            
            // Query the join table for follows originating from this user
            PFQuery *friendsQuery = [PFQuery queryWithClassName:@"Follow"];
            [friendsQuery whereKey:@"From" equalTo:[PFUser currentUser]];
            [friendsQuery whereKey:@"Accepted" equalTo:@YES];
            
            [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                // for all the objects that match the query
                for(PFObject *o in objects) {
                    // get the user being followed
                    PFUser* otherUser1 = [o objectForKey:@"To"];
                    [otherUser1 fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        // cache it
                        [SharedFriendsModel.Friends addObject:object];
                        [SharedFriendsModel.FriendFullNames addObject:[FriendsModel FindNameByNumber:[object objectForKey:@"phone"]]];
                        
                        PFGeoPoint *Coord = object[@"CurrentLocation"];
                        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(Coord.latitude, Coord.longitude);
                        NSString *locationName = object[@"LocationName"];
                        PersonAnnotation *annoation;
                        if ([locationName isEqualToString:@"Not near any marked locations"]) {
                            annoation = [[PersonAnnotation alloc] initWithTitle:object[@"username"] subTitle:nil Location:loc];
                        }
                        else {
                            annoation = [[PersonAnnotation alloc] initWithTitle:object[@"username"] subTitle:locationName Location:loc];
                        }
                        
                        [locationManager.Annotations addObject:annoation];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [mapView addAnnotation:annoation];
                        });
                    }];
                }
            }];


            
        break;}
    
        {case YES:
            [self removeAllPinsButUserLocation];
            [locationManager.VenueAnnotations removeAllObjects];
            //[self.mapClusterController removeAnnotations:locationManager.Annotations withCompletionHandler:NULL];
            //[self.mapClusterController addAnnotations:locationManager.VenueAnnotations withCompletionHandler:NULL];
            
            // Get venues
            PFQuery *VenueQuery = [PFQuery queryWithClassName:@"Venue"];
            NSArray *Venues = [VenueQuery findObjects];
            for (PFObject *V in Venues) {
                PFGeoPoint *Coord = V[@"Location"];
                CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(Coord.latitude, Coord.longitude);
                
                int Guys = [[V objectForKey:@"Guys"] integerValue];
                int Girls = [[V objectForKey:@"Girls"] integerValue];
                NSString *Attendance = [NSString stringWithFormat:@"Guys: %d Girls: %d", Guys, Girls];
                PartyAnnotation *annoation = [[PartyAnnotation alloc] initWithTitle:V[@"Name"] subTitle:Attendance Location:loc];
                [locationManager.VenueAnnotations addObject:annoation];
                
            }
            
            searchBar.placeholder = @"Search Parties";
            [mapView addAnnotations:locationManager.VenueAnnotations];
            break;}
    }
    
}

- (void)removeAllPinsButUserLocation
{
    id userLocation = [mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[mapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [mapView removeAnnotations:pins];
    pins = nil;
}

- (IBAction)changeAnnotations:(id)sender {
    LocationShareModel *locationManager = [LocationShareModel sharedModel];
    switch (((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            [self removeAllPinsButUserLocation];
            //[self.mapClusterController removeAnnotations:locationManager.VenueAnnotations withCompletionHandler:NULL];
            //[self.mapClusterController addAnnotations:locationManager.Annotations withCompletionHandler:NULL];
            searchBar.placeholder = @"Search Friends";
            [mapView addAnnotations:locationManager.Annotations];
            showVenues = NO;
            break;
            
        case 1:
            [self removeAllPinsButUserLocation];
            //[self.mapClusterController removeAnnotations:locationManager.Annotations withCompletionHandler:NULL];
            //[self.mapClusterController addAnnotations:locationManager.VenueAnnotations withCompletionHandler:NULL];
            searchBar.placeholder = @"Search Parties";
            [mapView addAnnotations:locationManager.VenueAnnotations];
            showVenues = YES;
            break;
    }
}

- (IBAction)setMap:(id)sender {
    switch (((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            [mapView setMapType:MKMapTypeStandard];
            break;
        
        case 1:
            [mapView setMapType:MKMapTypeHybrid];
            break;
    }
}

- (IBAction)goToUserLoc {
    // This code moves the screen with user location
    CLLocationCoordinate2D coord = mapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    [mapView setRegion:region animated:YES];
}


- (void)requestAlwaysAuthorization {
    
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
        CLLocationManager *locationTracker = [LocationTracker sharedLocationManager];
        [locationTracker requestAlwaysAuthorization];
    }
}

#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

#pragma mark - MKMapViewDelegate Methods.

- (MKAnnotationView *) mapView:(MKMapView *)amapView
             viewForAnnotation:(id <MKAnnotation>) annotation {

    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]
                                  initWithAnnotation:annotation reuseIdentifier:@"pin"];
    if (showVenues == NO) {
        annView.pinColor = MKPinAnnotationColorRed;
    }
    else if (showVenues == YES) {
        annView.pinColor = MKPinAnnotationColorPurple;
    }

    annView.canShowCallout = YES;  // <-- add this
    return annView;
}

@end
