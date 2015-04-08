//
//  SettingsViewController.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/4/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    IBOutlet UITableView *tableview;
    IBOutlet UIButton *Logout;
    NSArray *Cells;
}

@end
