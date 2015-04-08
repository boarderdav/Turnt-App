//
//  ManageFriendsViewController.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/3/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface ManageFriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    IBOutlet UITableView *tableView;
    IBOutlet UISearchBar * searchBar;
}

@property (nonatomic, strong) NSMutableArray * displayFriends;
@property (nonatomic, strong) NSMutableArray * displayFriendFullNames;
@property (nonatomic, strong) NSString * SectionTitle;

@end

