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
#import <Parse/Parse.h>

@interface MainViewController ()

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
    if (GetSharedModel.updatedThisSession == NO) {
        PFGeoPoint *currentPoint =
        [PFGeoPoint geoPointWithLatitude:GetSharedModel.Lattitude
                               longitude:GetSharedModel.Longitude];
        // Push the location to the server
        PFUser* curr = [PFUser currentUser];
        curr[@"CurrentLocation"] = currentPoint;
        [curr save];
        
        GetSharedModel.updatedThisSession = YES;
    }
    
    // Collect information from the table if neccesary
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    if (SharedFriendsModel.Friends.count == 0) {
        PFQuery *friendsQuery = [PFQuery queryWithClassName:@"Follow"];
        [friendsQuery whereKey:@"From" equalTo:[PFUser currentUser]];
        NSLog(@"Current user: %@", [PFUser currentUser][@"objectId"]);
        PFUser * current = [PFUser currentUser];
        [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

            for(PFObject *o in objects) {
                PFUser* otherUser = [o objectForKey:@"To"];
                NSLog(@"Other user: %@, %@", o[@"username"], o[@"phone"]);
                [SharedFriendsModel.Friends addObject:otherUser];
                [SharedFriendsModel.FriendFullNames addObject:[SharedFriendsModel FindNameByNumber:otherUser[@"phone"]]];
            }
 
            [tableView reloadData];
        }];
    }
}

-(void)didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation{
    //[latitudeLabel setText:[NSString stringWithFormat:
                          //  @"Latitude: %f",newLocation.coordinate.latitude]];
    //[longitudeLabel setText:[NSString stringWithFormat:
                          //   @"Longitude: %f",newLocation.coordinate.longitude]];
    LocationModel *GetSharedModel = [LocationModel getSharedInstance];
    GetSharedModel.Lattitude = newLocation.coordinate.latitude;
    GetSharedModel.Longitude = newLocation.coordinate.longitude;
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
    NSLog(@"Contact name label: %@", SharedFriendsModel.FriendFullNames[row] );
    cell.ContactNameLabel = SharedFriendsModel.FriendFullNames[row];
    return cell;
}

@end
