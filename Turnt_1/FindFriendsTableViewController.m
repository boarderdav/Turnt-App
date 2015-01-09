//
//  FindFriendsTableViewController.m
//  Project_Turnt
//
//  Created by Jake Spracher on 11/30/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import "FindFriendsTableViewController.h"
#import "TableCell.h"
#import "AppDelegate.h"
#import "FriendsModel.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <Parse/Parse.h>

@interface FindFriendsTableViewController ()

@property (nonatomic, strong) NSMutableArray *Names;
@property (nonatomic, strong) NSMutableArray *MatchUsers;
@property (nonatomic, strong) NSMutableArray *MatchContactNames;

@end

@implementation FindFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Make sure access to contacts is allowed
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        

        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
        
        //Allocate memory for the array of contact matches!!
        self.MatchUsers = [[NSMutableArray alloc] init];
        self.MatchContactNames = [[NSMutableArray alloc] init];
        
        // iterate all of the contacts
        for(int i = 0; i < numberOfPeople; i++) {
            
            // get this contact
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
            // get the contact's name
            //NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            //NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            //NSString *fullName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];

            //NSLog(@"Name:%@ %@", firstName, lastName);
            
            // Get all of the phone numbers for this contact
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            [[UIDevice currentDevice] name];
            
            
            // Iterate all of the numbers
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                
                // Get this number
                NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                NSString *cleaned = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                
                //NSLog(@"Digits:%@", phoneNumber);
                
                //  Query the server for this number, this part defines the query function thing (from parse doc):
                PFQuery *query = [PFUser query];
                [query whereKey:@"phone" equalTo:cleaned]; // define a query that finds every user with this number
                
                // This part is neccesary because this query might take so long that it could block the main thread, see: http://blog.grio.com/2014/04/understanding-the-ios-main-thread.html, and https://www.parse.com/docs/ios/api/Classes/PFQuery.html#//api/name/findObjectsInBackgroundWithBlock:
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    //NSLog(@"NumObjects: %lu", (unsigned long)objects.count );
                    // save the matching users
                    //[self.MatchUsers addObjectsFromArray:objects];
                    //[self.MatchContactNames addObject:[self FindNameByNumber:phoneNumber]];
                    
                    if (objects.count > 0) {
                        [SharedFriendsModel.ContactMatches addObjectsFromArray:objects];
                        [SharedFriendsModel.ContactMatchFullNames addObject:[SharedFriendsModel FindNameByNumber:phoneNumber]];
                        
                        //NSLog(@"Contact Matches: %lu", (unsigned long)self.MatchUsers.count );
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                }];
            }
        }
        
    }
    else {
        // Send an alert telling user to change privacy setting in settings app
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quit being a GDI"
                                                        message:@"Turnt needs access to your contacts to work, please go to your privacy settings and allow access."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Getting Started"
                                                    message:@"We've searched your contacts and found some friends that are already using Turnt"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //Get the shared friends model
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    return SharedFriendsModel.ContactMatches.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Get the shared friends model
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    // Configure the cell
    
    // The dequeue reusable cell thing is apple memory saving reusable cell magic mumbo jumbo
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    int row = [indexPath row];
    cell.UsernameLabel.text = SharedFriendsModel.ContactMatches[row][@"username"];//[self.MatchUsers[row][@"username"];
    cell.ContactNameLabel.text = SharedFriendsModel.ContactMatchFullNames[row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Preparing for segue");
}


@end
