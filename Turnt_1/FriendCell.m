//
//  FriendCell.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/4/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "FriendCell.h"
#import "FriendsModel.h"
#import <Parse/Parse.h>

@implementation FriendCell

- (void)awakeFromNib {
    // Initialization code
    Followed = false;
    [self.FollowButton.titleLabel.text isEqualToString:@"Follow"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Follow:(id)sender {
    
    // Get the friends model
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    // follow or unfollow?
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
