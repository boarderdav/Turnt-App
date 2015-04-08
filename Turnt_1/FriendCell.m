//
//  FriendCell.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/4/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "FriendCell.h"
#import "FriendsModel.h"

@implementation FriendCell
@synthesize Followed;

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"Username: %@", self.UsernameLabel.text);
    // Collect information from the table if neccesary
    
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
        [self.FollowButton setTitle: @"Unfollow" forState: UIControlStateNormal];
        [self.FollowButton setTitle: @"Unfollow" forState: UIControlStateApplication];
        [self.FollowButton setTitle: @"Unfollow" forState: UIControlStateHighlighted];
        [self.FollowButton setTitle: @"Unfollow" forState: UIControlStateReserved];
        [self.FollowButton setTitle: @"Unfollow" forState: UIControlStateDisabled];
        Followed = YES;
        // Follow the user
        [SharedFriendsModel FollowUser:self.UsernameLabel.text];
    }
    else {
        [self.FollowButton setTitle: @"Follow" forState: UIControlStateNormal];
        [self.FollowButton setTitle: @"Follow" forState: UIControlStateApplication];
        [self.FollowButton setTitle: @"Follow" forState: UIControlStateHighlighted];
        [self.FollowButton setTitle: @"Follow" forState: UIControlStateReserved];
        [self.FollowButton setTitle: @"Follow" forState: UIControlStateDisabled];
        Followed = NO;
        // Unfollow the user
        [SharedFriendsModel UnfollowUser:self.User];
    }

}

@end
