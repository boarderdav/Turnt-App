//
//  TableCell.m
//  Turnt
//
//  Created by Jake Spracher on 12/29/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import "TableCell.h"
#import "FriendsModel.h"
#import <Parse/Parse.h>

@implementation TableCell

- (IBAction)Follow:(id)sender {
    
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    if ([self.FollowButton.titleLabel.text isEqualToString:@"Follow"]) {
        self.FollowButton.titleLabel.text = @"Unfollow";
        // Follow the user
        [SharedFriendsModel FollowUser:self.UsernameLabel.text];
    }
    else {
        self.FollowButton.titleLabel.text = @"Follow";
        // Unfollow the user
        [SharedFriendsModel UnfollowUser:self.UsernameLabel.text];
    }
}

@end

