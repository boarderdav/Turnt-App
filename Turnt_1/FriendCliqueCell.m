//
//  FriendCliqueCell.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/16/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "FriendCliqueCell.h"
#import "FriendsModel.h"

@implementation FriendCliqueCell
@synthesize User;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Add:(id)sender {
    FriendsModel * sharedFriendsModel = [FriendsModel GetSharedInstance];
    
    if ([self.AddButton.titleLabel.text isEqualToString:@"Add"]) {
        [self.AddButton setTitle: @"Remove" forState: UIControlStateNormal];
        [self.AddButton setTitle: @"Remove" forState: UIControlStateApplication];
        [self.AddButton setTitle: @"Remove" forState: UIControlStateHighlighted];
        [self.AddButton setTitle: @"Remove" forState: UIControlStateReserved];
        [self.AddButton setTitle: @"Remove" forState: UIControlStateDisabled];
        PFUser *thisUser = User;
        [sharedFriendsModel.TempCliqueMembers addObject:thisUser];
    }
    if ([self.AddButton.titleLabel.text isEqualToString:@"Remove"]) {
        [self.AddButton setTitle: @"Add" forState: UIControlStateNormal];
        [self.AddButton setTitle: @"Add" forState: UIControlStateApplication];
        [self.AddButton setTitle: @"Add" forState: UIControlStateHighlighted];
        [self.AddButton setTitle: @"Add" forState: UIControlStateReserved];
        [self.AddButton setTitle: @"Add" forState: UIControlStateDisabled];
        PFUser *thisUser = User;
        [sharedFriendsModel.TempCliqueMembers removeObject:thisUser];
    }
    
}

@end
