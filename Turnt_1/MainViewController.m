//
//  DEMOFirstViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MainViewController.h"
#import "ActivityCell.h"
#import "LocationModel.h"
#import "FriendsModel.h"
#import "UpdatePlansView.h"
#import "UIViewController+MJPopupViewController.h"
#import <Parse/Parse.h>

@interface MainViewController () <PopupDelegate> {
    NSArray *actions;
    NSArray *animations;
}
@end

@implementation MainViewController

-(void)viewDidLoad {
    // Request location access
    [[LocationModel getSharedInstance] requestAlwaysAuthorization];
    // Start getting location
    [[LocationModel getSharedInstance]setDelegate:self];
    [[LocationModel getSharedInstance]startUpdating];
    
    // Update users location on server, since main view loaded
    // (Create PFGeoPoint representing current location and push)
    
    // Get the location from the shared model
    LocationModel *GetSharedModel = [LocationModel getSharedInstance];
    
    // If the location hasn't been recently updated (minimize API requests)
    //if (GetSharedModel.updatedThisSession == NO) {
        // get the location
        PFGeoPoint *currentPoint =
        [PFGeoPoint geoPointWithLatitude:GetSharedModel.Lattitude
                               longitude:GetSharedModel.Longitude];
        
        // get the current user
        PFUser* curr = [PFUser currentUser];
    
        // Update the saved location association
        PFQuery * LocationQuery= [PFQuery queryWithClassName:@"SavedLocation"];
        [LocationQuery whereKey:@"User" equalTo:curr];
        [LocationQuery whereKey:@"Coordinate" nearGeoPoint:currentPoint withinKilometers:.5];
        NSArray * objects = [LocationQuery findObjects];

        // update the location coordinate
        curr[@"CurrentLocation"] = currentPoint;
        if (objects.count > 0) {
            curr[@"LocationName"] = objects[0][@"Name"];
        }
        
        // push to server
        [curr saveInBackground];
        
        GetSharedModel.updateCounter++;
        if (GetSharedModel.updateCounter > 4) {
            GetSharedModel.updatedThisSession = YES;
        }
    
    //}
    
    // Collect information from the table if neccesary
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    // If friends are not cached
    if (SharedFriendsModel.Friends.count == 0) {
        
        // Query the join table for follows originating from this user
        PFQuery *friendsQuery = [PFQuery queryWithClassName:@"Follow"];
        [friendsQuery whereKey:@"From" equalTo:[PFUser currentUser]];
        
        [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            // for all the objects that match the query
            for(PFObject *o in objects) {
                // get the user being followed
                PFUser* otherUser = [o objectForKey:@"To"];
                [otherUser fetch];
                // cache it
                [SharedFriendsModel.Friends addObject:otherUser];
                [SharedFriendsModel.FriendFullNames addObject:[FriendsModel FindNameByNumber:[otherUser objectForKey:@"phone"]]];
            }
            // refresh the table view
            [tableView reloadData];
            
        }];
        
    }
    
}

// Function implemented to conform to location manager protocol. Called whenever the user's location changes
-(void)didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation{
    //[latitudeLabel setText:[NSString stringWithFormat:
                          //  @"Latitude: %f",newLocation.coordinate.latitude]];
    //[longitudeLabel setText:[NSString stringWithFormat:
                          //   @"Longitude: %f",newLocation.coordinate.longitude]];
    LocationModel *GetSharedModel = [LocationModel getSharedInstance];
    GetSharedModel.Lattitude = newLocation.coordinate.latitude;
    GetSharedModel.Longitude = newLocation.coordinate.longitude;
    
    /*
    PFGeoPoint *newLoc = [PFGeoPoint geoPointWithLocation:newLocation];
    
    PFUser *curr = [PFUser currentUser];
     
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:curr[@"username"]];
    [query whereKey:@"SavedLocations:" nearGeoPoint:newLoc withinKilometers:.1];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
    }];
    */
    
}

- ( void)cancelButtonClicked:(UpdatePlansView*)UpdatePlansView {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    return SharedFriendsModel.Friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The dequeue reusable cell thing is memory saving reusable cell magic mumbo jumbo
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    int row = [indexPath row];
    cell.ContactNameLabel.text = SharedFriendsModel.FriendFullNames[row];
    cell.PlansTextView.text = SharedFriendsModel.Friends[row][@"Plans"];

    cell.LocationLabel.text = SharedFriendsModel.Friends[row][@"LocationName"];
    cell.EventLabel.text = @"[No Event]";
    return cell;
    
}

@end
