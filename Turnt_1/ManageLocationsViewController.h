//
//  ManageLocationsTableViewController.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/23/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationCell.h"

@interface ManageLocationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, locationCellDelegate> {
    IBOutlet UITableView *tableView;
    NSMutableArray *DisplayLocations;
    NSMutableArray *Locations;
    NSMutableArray *DisplayVenues;
    NSMutableArray *Venues;
}

@end
