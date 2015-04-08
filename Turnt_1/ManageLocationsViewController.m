//
//  ManageLocationsTableViewController.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/23/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "ManageLocationsViewController.h"
#import "LocationCell.h"
#import <Parse/Parse.h>

@interface ManageLocationsViewController ()

@end

@implementation ManageLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DisplayLocations = [[NSMutableArray alloc]init];
    Locations = [[NSMutableArray alloc]init];
    DisplayVenues = [[NSMutableArray alloc]init];
    Venues = [[NSMutableArray alloc]init];
    
    PFQuery *LocationQuery = [PFQuery queryWithClassName:@"SavedLocation"];
    [LocationQuery whereKey:@"User" equalTo:[PFUser currentUser]];
    
    [LocationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [Locations addObjectsFromArray:objects];
        for (PFObject *o in objects) {
            [DisplayLocations addObject:o[@"Name"]];
        }
        [tableView reloadData];
    }];
    
    PFQuery *VenueQuery = [PFQuery queryWithClassName:@"Venue"];
    [VenueQuery whereKey:@"Creator" equalTo:[PFUser currentUser]];
    
    [VenueQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [Venues addObjectsFromArray:objects];
        for (PFObject *o in objects) {
            [DisplayVenues addObject:o[@"Name"]];
        }
        [tableView reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Location cell delegate method for when delete button is pressed on cell, deletes cell from table here
-(void)thisCellDeleted:(LocationCell*)Cell {
    [DisplayLocations removeObject:Cell.Label.text];
    [tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0) {
        return DisplayLocations.count;
    }
    else {
        return DisplayVenues.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Locations";
    else
        return @"Venues";
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The dequeue reusable cell thing is memory saving reusable cell magic mumbo jumbo
    LocationCell *cell = [atableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    
    int row = [indexPath row];
    
    if (indexPath.section == 0) {
        cell.Label.text = DisplayLocations[row];
        cell.location = Locations[row];
    }
    else {
        cell.Label.text = DisplayVenues[row];
        cell.location = Venues[row];
    }

    cell.delegate = self;
    
    return cell;

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

@end
