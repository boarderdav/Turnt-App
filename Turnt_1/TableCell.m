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
    
    // Get the friends model
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    // follow or unfollow?
    if ([self.FollowButton.titleLabel.text isEqualToString:@"Follow"]) {
        [self.FollowButton setTitle: @"Unfollow" forState: UIControlStateNormal];
        [self.FollowButton setTitle: @"Unfollow" forState: UIControlStateApplication];
        [self.FollowButton setTitle: @"Unfollow" forState: UIControlStateHighlighted];
        [self.FollowButton setTitle: @"Unfollow" forState: UIControlStateReserved];
        [self.FollowButton setTitle: @"Unfollow" forState: UIControlStateDisabled];
        // Follow the user
        
        
        
        [SharedFriendsModel FollowUser:self.UsernameLabel.text];
    }
    else {
        [self.FollowButton setTitle: @"Follow" forState: UIControlStateNormal];
        [self.FollowButton setTitle: @"Follow" forState: UIControlStateApplication];
        [self.FollowButton setTitle: @"Follow" forState: UIControlStateHighlighted];
        [self.FollowButton setTitle: @"Follow" forState: UIControlStateReserved];
        [self.FollowButton setTitle: @"Follow" forState: UIControlStateDisabled];
        // Unfollow the user
        [SharedFriendsModel UnfollowUser:self.User];
    }
}

@end

