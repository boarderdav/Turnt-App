//
//  ActivityCell.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/5/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell
@synthesize User;

- (void)awakeFromNib {
    // Initialization code
    informed = NO;
}

- (IBAction)Roll:(id)sender {
    if (informed == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Roll"
                                                        message:[NSString stringWithFormat:@"You just told %@ that you want to roll. Feel free to hit this button as many times as neccesary to get their attention", User.username]
                                                       delegate:self
                                              cancelButtonTitle:@"Word"
                                              otherButtonTitles: nil];
        [alert show];
        informed = YES;
    }
    
    // Build the actual push notification target query
    PFQuery *query = [PFInstallation query];
    
    // only return Installations that belong to a User that
    // matches the innerQuery
    [query whereKey:@"user" equalTo:User];
    
    PFUser *curr = [PFUser currentUser];
    
    // Send the notification.
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    NSString *Message = [NSString stringWithFormat:@"%@ wants to roll fool", curr.username];
    [push setMessage:Message];
    [push sendPushInBackground];
    
}


@end
