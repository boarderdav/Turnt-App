//
//  DEMOFirstViewController.h
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "FriendsModel.h"
#import "UpdatePlansView.h"
#import "UpdateLocationView.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UpdatePlansViewDelegate> {
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *UpdatePlans;
    FriendsModel *SharedFriendsModel;
    int loadedusers;
}



@end
