//
//  NewCliqueViewController.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/4/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsModel.h"
#import <Parse/Parse.h>
#import "FriendCell.h"



@interface NewCliqueViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextViewDelegate> {
    IBOutlet UITextField *CliqueName;
    IBOutlet UITableView *tableView;
    IBOutlet UISearchBar *searchBar;
}

@property (nonatomic, strong) NSMutableArray * displayContent;
@property (nonatomic, strong) NSMutableArray * displayUsers;

@end
