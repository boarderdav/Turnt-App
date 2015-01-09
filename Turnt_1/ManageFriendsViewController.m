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

@property (nonatomic, strong) NSMutableArray *Names;
@property (nonatomic, strong) NSMutableArray *MatchUsers;
@property (nonatomic, strong) NSMutableArray *MatchContactNames;


@end

@implementation ManageFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get Friends Model
    FriendsModel* SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    // If friends are avaiable, dont query the server
    if (SharedFriendsModel.ContactMatches.count == 0) {
        // [tableView registerClass: [FriendCell class] forCellReuseIdentifier:@"FriendCell"];

        // Make sure access to contacts is allowed
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            
            CFErrorRef *error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
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
                            [SharedFriendsModel.ContactMatchFullNames addObject:[SharedFriendsModel FindNameByNumber:phoneNumber]];
                            
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quit being a GDI"
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    //Get the shared friends model
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    return SharedFriendsModel.ContactMatches.count;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the shared friends model
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    // The dequeue reusable cell thing is memory saving reusable cell magic mumbo jumbo
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    
    int row = [indexPath row];
    cell.UsernameLabel.text = SharedFriendsModel.ContactMatches[row][@"username"];//[self.MatchUsers[row][@"username"];
    cell.ContactNameLabel.text = SharedFriendsModel.ContactMatchFullNames[row];
    return cell;
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