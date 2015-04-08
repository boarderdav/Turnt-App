//
//  ManageFriendsViewController.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/3/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "ManageFriendsViewController.h"
#import "FriendCell.h"
#import "FriendsModel.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <Parse/Parse.h>

@interface ManageFriendsViewController ()

@end

@implementation ManageFriendsViewController
@synthesize displayFriends;
@synthesize displayFriendFullNames;
@synthesize SectionTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Force the Navigation Bar Color
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = YES;
    
    searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    
    SectionTitle = @"Users in Contacts";
    
    // Force the Navigation Bar Title font
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"mplus-1c-regular" size:21],
      NSFontAttributeName, nil]];
    
    // Get Friends Model
    FriendsModel* SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    // allocate memory for display content
    displayFriends = [[NSMutableArray alloc] init];
    displayFriendFullNames = [[NSMutableArray alloc]init];
    
    // If friends are avaiable, dont query the server
    if (SharedFriendsModel.ContactMatches.count == 0) {
        
        // Query the join table for follows originating from this user
        PFQuery *friendsQuery = [PFQuery queryWithClassName:@"Follow"];
        [friendsQuery whereKey:@"From" equalTo:[PFUser currentUser]];
        
        NSArray *objects = [friendsQuery findObjects];
        for(PFObject *o in objects) {
            // get the user being followed
            PFUser* otherUser = [o objectForKey:@"To"];
            [otherUser fetch];
            // cache it
            [SharedFriendsModel.Friends addObject:otherUser];
            [SharedFriendsModel.FriendFullNames addObject:[FriendsModel FindNameByNumber:[otherUser objectForKey:@"phone"]]];
        }
        
        // Make sure access to contacts is allowed
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            
            CFErrorRef *error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
            
            // iterate all of the contacts
            for(int i = 0; i < numberOfPeople; i++) {
                
                // get this contact
                ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
                
                
                //NSLog(@"Name:%@ %@", firstName, lastName);
                
                // Get all of the phone numbers for this contact
                ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
                [[UIDevice currentDevice] name];
                
                
                // Iterate all of the numbers
                for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                    
                    // Get this number
                    NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                    //NSLog(@"Digits:%@", phoneNumber);
                    
                    // Get rid of all non decimal characters for comparison
                    NSString *cleaned = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet] ] componentsJoinedByString:@""];
                    
                    //  Query the server for this number, this part defines the query function thing (from parse doc):
                    
                    PFQuery *query = [PFUser query];
                    [query whereKey:@"phone" equalTo:cleaned]; // define a query that finds every user with this number
                    
                    // This part is neccesary because this query might take so long that it could block the main thread, see: http://blog.grio.com/2014/04/understanding-the-ios-main-thread.html, and https://www.parse.com/docs/ios/api/Classes/PFQuery.html#//api/name/findObjectsInBackgroundWithBlock:
                    
                    
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        
                        NSLog(@"NumObjects: %lu", (unsigned long)objects.count );
                        // save the matching users
                        if (objects.count > 0) {
                            
                            [SharedFriendsModel.ContactMatches addObjectsFromArray:objects];
                            [SharedFriendsModel.ContactMatchFullNames addObject:[FriendsModel FindNameByNumber:phoneNumber]];
                            
                            //NSLog(@"Contact Matches: %lu", (unsigned long)self.MatchUsers.count );
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [tableView reloadData];
                            });
                        }
                    }];
                }
            }
        }
        else {
            // Send an alert telling user to change privacy setting in settings app
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Freshman Mistake"
                                                            message:@"Turnt needs access to your contacts to work, please go to your privacy settings and allow access."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return SectionTitle;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithWhite:0.3 alpha:0.7];;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor lightGrayColor]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    //Get the shared friends model
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    if (displayFriends.count != 0) {
        return displayFriends.count;
    }
    else{
        return SharedFriendsModel.ContactMatches.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the shared friends model
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    // The dequeue reusable cell thing is memory saving reusable cell magic mumbo jumbo
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];

    if (displayFriends.count == 0) {
        int row = [indexPath row];
        cell.UsernameLabel.text = SharedFriendsModel.ContactMatches[row][@"username"];//[self.MatchUsers[row][@"username"];
        cell.User = SharedFriendsModel.ContactMatches[row];
        cell.ContactNameLabel.text = SharedFriendsModel.ContactMatchFullNames[row];
    }
    else {
        int row = [indexPath row];
        cell.UsernameLabel.text = displayFriends[row][@"username"];//[self.MatchUsers[row][@"username"];
        cell.User = displayFriends[row];
        cell.ContactNameLabel.text = displayFriendFullNames[row];
    }
    
    cell.Followed = NO;
    
    // Figure out if the button should say follow or unfollow:
    for (PFUser *u in SharedFriendsModel.Friends) {
        if ([[u objectForKey:@"username"] isEqualToString:cell.UsernameLabel.text]) {
            // Set the cells user:
            cell.User = u;
            
            [cell.FollowButton setTitle: @"Unfollow" forState: UIControlStateNormal];
            [cell.FollowButton setTitle: @"Unfollow" forState: UIControlStateApplication];
            [cell.FollowButton setTitle: @"Unfollow" forState: UIControlStateHighlighted];
            [cell.FollowButton setTitle: @"Unfollow" forState: UIControlStateReserved];
            [cell.FollowButton setTitle: @"Unfollow" forState: UIControlStateDisabled];
            cell.Followed = YES;
        }
    }
    
    if (cell.Followed != YES) {
        [cell.FollowButton setTitle: @"Follow" forState: UIControlStateNormal];
        [cell.FollowButton setTitle: @"Follow" forState: UIControlStateApplication];
        [cell.FollowButton setTitle: @"Follow" forState: UIControlStateHighlighted];
        [cell.FollowButton setTitle: @"Follow" forState: UIControlStateReserved];
        [cell.FollowButton setTitle: @"Follow" forState: UIControlStateDisabled];
        cell.Followed = NO;
    }
    
    return cell;
}

#pragma mark - searchbar functions

- (void)searchBarSearchButtonClicked:(UISearchBar *)asearchBar
{
    [displayFriends removeAllObjects];
    [displayFriendFullNames removeAllObjects];
    
    SectionTitle = @"All Matching Users";
    
    FriendsModel * sharedFriendsModel = [FriendsModel GetSharedInstance];
    
    for (int i = 0; i < sharedFriendsModel.ContactMatches.count; i++)
    {
        PFUser * thisUser = sharedFriendsModel.ContactMatches[i];
        NSString *thisName = sharedFriendsModel.ContactMatchFullNames[i];
        if ([thisName rangeOfString:[asearchBar text] options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [displayFriends addObject:thisUser];
            [displayFriendFullNames addObject:thisName];
        }
    }
    
    PFQuery *FriendQuery = [PFUser query];
    [FriendQuery whereKey:@"username" equalTo:asearchBar.text];
    NSArray *Objects = [FriendQuery findObjects];
    for (PFUser *U in Objects) {
        [U fetch];
        BOOL AlreadyFoundinContacts = NO;
        for (PFUser *FoundAlready in displayFriends) {
            if ([U.username isEqualToString:FoundAlready.username]) {
                AlreadyFoundinContacts = YES;
            }
        }
        if (AlreadyFoundinContacts == NO) {
            [displayFriendFullNames addObject:U.username];
            [displayFriends addObject:U];
        }
    }
    [tableView reloadData];
    [searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)asearchBar
{
    [displayFriends removeAllObjects];
    [displayFriendFullNames removeAllObjects];
    SectionTitle = @"Users in Contacts";
    [tableView reloadData];
    [asearchBar resignFirstResponder];
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)asearchBar
{
    asearchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
}



- (void)searchBarTextDidEndEditing:(UISearchBar *)asearchBar
{
    [tableView reloadData];
    [asearchBar resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
