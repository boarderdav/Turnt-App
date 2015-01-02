//
//  TableCell.m
//  Turnt
//
//  Created by Jake Spracher on 12/29/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import "TableCell.h"
#import <Parse/Parse.h>

@implementation TableCell

- (IBAction)Follow:(id)sender {
    
    /*
    NSString *initmessage = @"Are you sure you want to follow? ";
    NSString *message = [initmessage stringByAppendingString:self.ContactNameLabel.text];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:nil];
    [alert show];
    
    */
    
    
    
    // Follow the user
    PFQuery *UserQuery = [PFUser query];
    [UserQuery whereKey:@"username" equalTo:self.UsernameLabel.text];
    PFUser *ToFollow = [UserQuery findObjects][0];
    
    // create an entry in the Follow table
    PFObject *follow = [PFObject objectWithClassName:@"Follow"];
    [follow setObject:[PFUser currentUser]  forKey:@"From"];
    [follow setObject:ToFollow forKey:@"To"];
    [follow saveInBackground];
    
}

@end

