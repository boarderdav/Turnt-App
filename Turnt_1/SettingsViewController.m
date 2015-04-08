//
//  SettingsViewController.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/4/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "FriendsModel.h"
#import "LocationTracker.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

-(void)viewWillAppear:(BOOL)animated {
    [tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Force the Navigation Bar Color
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = YES;
    
    // Do any additional setup after loading the view.
    Cells = [NSArray arrayWithObjects:@"Turn Down/Transfer (Logout)", @"Manage Saved Locations", @"Give Feedback", @"Help/Tips", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Logout:(id)sender {
    // clear friends model
    FriendsModel *SharedModel = [FriendsModel GetSharedInstance];
    [SharedModel clear];
    
    // stop location tracking
    [((AppDelegate *) [UIApplication sharedApplication].delegate).locationTracker stopLocationTracking];
    
    // unregister for push notifications
    PFQuery *instQuery = [PFQuery queryWithClassName:@"Installation"];
    [instQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [instQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *o in objects) {
            [o deleteEventually];
        }
    }];
    
    // logout of parse
    [PFUser logOut];
    
    
    [self performSegueWithIdentifier:@"loginLink" sender:sender];
    
}

#pragma mark - Table View Functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return Cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The dequeue reusable cell thing is memory saving reusable cell magic mumbo jumbo
    SettingsCell *cell = [atableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
    
    int row = [indexPath row];
    cell.Label.text = Cells[row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    NSString *segueString;
    UIAlertView *alert;
    
    switch (indexPath.row) {
        case 0:
            alert = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                            message:@"Are you sure you want to log out?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            [alert show];
            
            break;
        case 1:
            segueString = @"ToSavedLocations";
            [self performSegueWithIdentifier:segueString
                                      sender:[Cells objectAtIndex:indexPath.row]];
            break;
        case 2:
            segueString = @"Feedback";
            [self performSegueWithIdentifier:segueString
                                      sender:[Cells objectAtIndex:indexPath.row]];
            break;
        case 3:
            segueString = @"Help";
            [self performSegueWithIdentifier:segueString
                                      sender:[Cells objectAtIndex:indexPath.row]];
            break;
    }

}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    //Make sure the drunk user actually wants to log out
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked, reload data to deselect cell
        [tableview reloadData];
    }else{
        //yes clicked, logout
        [self Logout:self];
    }
}

@end

