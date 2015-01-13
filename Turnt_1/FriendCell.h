//
//  FriendCell.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/4/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendCell : UITableViewCell 

@property (nonatomic) bool Followed;
@property (nonatomic, strong) PFUser *User;
@property (strong, nonatomic) IBOutlet UILabel *ContactNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *UsernameLabel;
@property (strong, nonatomic) IBOutlet UIButton *FollowButton;

@end
