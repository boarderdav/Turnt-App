//
//  NewCliqueViewController.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/4/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "NewCliqueViewController.h"
#import <Parse/Parse.h>

@interface NewCliqueViewController ()

@end

@implementation NewCliqueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Clique Creation Utilities

- (void) createClique: (NSString*) GroupName {
    // create an entry in the Clique table
    PFObject *Clique = [PFObject objectWithClassName:@"Clique"];
    [Clique setObject:GroupName  forKey:@"Name"];
    [Clique setObject:[PFUser currentUser]  forKey:@"Creator"];
    [Clique saveInBackground];
} 

- (void) inviteUserToGroup:(PFUser*) User {
    // Make the invite
    PFObject *Invite = [PFObject objectWithClassName:@"JoinInvite"];
    // Add invitee
    [Invite setObject:User forKey:@"Invitee"];
    // Set inviter
    [Invite setObject:[PFUser currentUser] forKey:@"Inviter"];
    // Declare as not accepted
    [Invite setValue:FALSE forKey:@"Accepted"];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
