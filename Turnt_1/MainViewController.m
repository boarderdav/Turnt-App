//
//  DEMOFirstViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MainViewController.h"
#import "LocationTracker.h"
#import "ActivityCell.h"
#import "YouCell.h"
#import "ContactAccessCell.h"
#import "UIViewController+MJPopupViewController.h"
#import <Parse/Parse.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

@interface MainViewController ()  {
    NSArray *actions;
    NSArray *animations;
    BOOL contactAuthorized;
}
@end

@implementation MainViewController

-(void)viewDidLoad {
    
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil];
    //[self.navigationController.navigationBar setTitleTextAttributes:dic];
    
    // Force the Navigation Bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    self.navigationController.navigationBar.translucent = YES;
    
    // allow table view selection (for contact access row)
    tableView.allowsSelection = YES;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Getting yo frands"];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refreshControl];
    
    // Get the friends model
    SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    // Clear the table view
    [SharedFriendsModel.Friends removeAllObjects];
    [SharedFriendsModel.FriendFullNames removeAllObjects];
    [tableView reloadData];
    
    // Update location manually
    CLLocationManager *locationTracker = [LocationTracker sharedLocationManager];
    CLLocationCoordinate2D coord = locationTracker.location.coordinate;
    
    PFGeoPoint *currentPoint =
    [PFGeoPoint geoPointWithLatitude:coord.latitude
                           longitude:coord.longitude];
    
    PFUser *curr = [PFUser currentUser];
    curr[@"CurrentLocation"] = currentPoint;
    
    // Update the saved location association
    PFQuery * LocationQuery= [PFQuery queryWithClassName:@"SavedLocation"];
    [LocationQuery whereKey:@"User" equalTo:curr];
    [LocationQuery whereKey:@"Coordinate" nearGeoPoint:currentPoint withinKilometers:2];
    NSArray * objects = [LocationQuery findObjects];
    
    // update the location coordinate
    curr[@"CurrentLocation"] = currentPoint;
    
    if (objects.count > 0) {
        PFGeoPoint *closestPoint = objects[0][@"Coordinate"];
        
        // If the closest saved location is close
        if ([closestPoint distanceInKilometersTo:currentPoint] < .2) {
            // Say the user is at that saved location
            curr[@"LocationName"] = objects[0][@"Name"];
        }
        else {
            // If not, say the user is closest to that saved location
            NSArray *myStrings = [[NSArray alloc] initWithObjects:@"Closest to: ", objects[0][@"Name"], nil];
            NSString *joinedString = [myStrings componentsJoinedByString:@""];
            curr[@"LocationName"] = joinedString;
        }
    }
    else {
        curr[@"LocationName"] = @"Not near any marked locations";
    }
    
    // push to server
    [curr saveInBackground];
    [self refreshFriends];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check the segue identifier
    if ([[segue identifier] isEqualToString:@"ToPlans"])
    {
        // Get a reference to your custom view controller
        UpdatePlansView *customViewController = segue.destinationViewController;
        
        // Set your custom view controller's delegate
        customViewController.delegate = self;
    }
    // Check the segue identifier
    else if ([[segue identifier] isEqualToString:@"ToLoc"])
    {
        // Get a reference to your custom view controller
        UpdatePlansView *customViewController = segue.destinationViewController;
        
        // Set your custom view controller's delegate
        customViewController.delegate = self;
    }
}

#pragma mark - Utilities

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self refreshFriends];
    [refreshControl endRefreshing];
}

- (void) refreshFriends {
    // Query the join table for follows originating from this user
    
    [SharedFriendsModel.Friends removeAllObjects];
    [SharedFriendsModel.FriendFullNames removeAllObjects];
    
    PFQuery *friendsQuery = [PFQuery queryWithClassName:@"Follow"];
    [friendsQuery whereKey:@"From" equalTo:[PFUser currentUser]];
    [friendsQuery whereKey:@"Accepted" equalTo:@YES];
    
    NSArray *objects = [friendsQuery findObjects];
        // for all the objects that match the query
    for(PFObject *o in objects) {
        // get the user being followed
        PFUser* otherUser1 = [o objectForKey:@"To"];
        [otherUser1 fetch];
        // cache it
        [SharedFriendsModel.Friends addObject:otherUser1];
        [SharedFriendsModel.FriendFullNames addObject:[FriendsModel FindNameByNumber:[otherUser1 objectForKey:@"phone"]]];
        // refresh the table view
        [tableView reloadData];
     
    }
    
}

-(void) assocWithLocations {
    PFQuery *userQuery = [PFUser query];
    NSArray *Users = [userQuery findObjects];

    for (PFUser *u in Users) {
        
        PFGeoPoint *userlocation = u[@"Location"];
        
        PFQuery *venues = [PFQuery queryWithClassName:@"Venue"];
        [venues whereKey:@"Location" nearGeoPoint:userlocation withinKilometers:2];
        NSArray *matches = [venues findObjects];
        if (matches.count > 0) {
            PFObject* thismatch = matches[0];
            [thismatch fetch];
            [thismatch incrementKey:@"count"];
            [thismatch saveEventually];
            
            u[@"venue"] = thismatch[@"Name"];
            [u saveEventually];
            
        }
        
    }
    
}

// not currently in use
- (void) checkForCliqueInvites {
    PFQuery *InviteQuery = [PFQuery queryWithClassName:@"JoinInvite"];
    [InviteQuery whereKey:@"To" equalTo:[PFUser currentUser]];
    [InviteQuery whereKey:@"Accepted" equalTo:@NO];
    [InviteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(PFObject *o in objects) {
            // Get the clique and prompt to join
            PFObject *Clique = [o objectForKey:@"ToClique"];
            [Clique fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:object[@"Name"]
                                                                message:@"You have been invited to this clique. Join?"
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles:@"Yes", nil];
                [alert show];
            }];
        }
    }];
}

#pragma mark - Popup View Delegates

- (void)cancelButtonClicked:(UpdatePlansView *)aUpdatePlansView
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    [self refreshFriends];
}


- (void)cancelButtonClickedLocation:(UpdateLocationView*)aUpdateLocationView
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    [self refreshFriends];
}
#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
        
    }else{
        [SharedFriendsModel FollowUserBack:alertView.title];
    }
}

#pragma mark - Table View Functions

// Section 1 = you, Section 2 = followers

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0) {
        return 1;
    }
    else {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            return SharedFriendsModel.Friends.count;
        }
        else {
            return SharedFriendsModel.Friends.count + 1;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    PFUser *u = [PFUser currentUser];
    if(section == 0)
        return u.username;
    else
        return @"Followers";
}

// Force section header color
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithWhite:0.3 alpha:0.7];;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor lightGrayColor]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 107;
    }
    else {
        // if access to contacts isnt authorized, give the user the option to authorize access at the first row of this table
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            return 154;
        }
        else {
            if (indexPath.row == 0) {
                return 60;
            }
            else
                return 154;
        }
    }

}

- (void)tableView:(UITableView *)atableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized
        && indexPath.section == 1 && indexPath.row == 0) {
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted
            || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Access is Denied =("
                                                            message:@"Go to Settings -> Privacy -> Contacts to give Turnt permission, then try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        else {
            NSLog(@"Contact Access button pressed");
            
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
            });
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The dequeue reusable cell thing is memory saving reusable cell magic mumbo jumbo
    
    int row = [indexPath row];
    
    if (indexPath.section == 0) {
        YouCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YouCell"];
        PFUser *u = [PFUser currentUser];
        NSString *Plans = u[@"Plans"];
        if (Plans.length == 0) {
            cell.PlansTextView.text = @"Tap post to tell your friends what your plans are, or other random thoughts.";
        }
        else {
            cell.PlansTextView.text = u[@"Plans"];
        }
        
        cell.User = u;
        cell.LocationLabel.text = u[@"LocationName"];
        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setDateStyle:NSDateFormatterShortStyle];
        [date setTimeStyle:NSDateFormatterShortStyle];
        [date setTimeZone:[NSTimeZone defaultTimeZone]];
        cell.EventLabel.text = [date stringFromDate:cell.User.updatedAt];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            
            ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
            if([SharedFriendsModel.FriendFullNames[row] length] == 0) {
                cell.ContactNameLabel.text = SharedFriendsModel.Friends[row][@"username"];
            }
            else {
                cell.ContactNameLabel.text = SharedFriendsModel.FriendFullNames[row];
            }
            cell.PlansTextView.text = SharedFriendsModel.Friends[row][@"Plans"];
            cell.User = SharedFriendsModel.Friends[row];
            cell.LocationLabel.text = SharedFriendsModel.Friends[row][@"LocationName"];
            NSDateFormatter *date = [[NSDateFormatter alloc] init];
            [date setDateStyle:NSDateFormatterShortStyle];
            [date setTimeStyle:NSDateFormatterShortStyle];
            [date setTimeZone:[NSTimeZone defaultTimeZone]];
            cell.EventLabel.text = [date stringFromDate:cell.User.updatedAt];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            if (indexPath.row == 0) {
                ContactAccessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ContactAccessCell"];
                UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
                myBackView.backgroundColor = [UIColor darkGrayColor];
                cell.selectedBackgroundView = myBackView;
                
                return cell;
            }
            else {
                ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
                if([SharedFriendsModel.FriendFullNames[row - 1] length] == 0) {
                    cell.ContactNameLabel.text = SharedFriendsModel.Friends[row - 1][@"username"];
                }
                else {
                    cell.ContactNameLabel.text = SharedFriendsModel.FriendFullNames[row - 1];
                }
                cell.PlansTextView.text = SharedFriendsModel.Friends[row - 1][@"Plans"];
                cell.User = SharedFriendsModel.Friends[row - 1];
                cell.LocationLabel.text = SharedFriendsModel.Friends[row - 1][@"LocationName"];
                NSDateFormatter *date = [[NSDateFormatter alloc] init];
                [date setDateStyle:NSDateFormatterShortStyle];
                [date setTimeStyle:NSDateFormatterShortStyle];
                [date setTimeZone:[NSTimeZone defaultTimeZone]];
                cell.EventLabel.text = [date stringFromDate:cell.User.updatedAt];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    
}

@end
