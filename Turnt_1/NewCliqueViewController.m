//
//  NewCliqueViewController.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/4/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "NewCliqueViewController.h"
#import "FriendsModel.h"
#import "FriendCliqueCell.h"
#import <Parse/Parse.h>

@interface NewCliqueViewController ()

@end

@implementation NewCliqueViewController
@synthesize displayContent;
@synthesize displayUsers;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([CliqueName respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor lightTextColor];
        CliqueName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Clique Name" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
    
    displayContent = [[NSMutableArray alloc]init];
    displayUsers = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Clique Creation Utilities

- (PFObject *) createClique: (NSString*) GroupName {
    // create an entry in the Clique table
    PFObject *Clique = [PFObject objectWithClassName:@"Clique"];
    [Clique setObject:GroupName  forKey:@"Name"];
    [Clique setObject:[PFUser currentUser]  forKey:@"Creator"];
    [Clique saveEventually];
    return Clique;
} 

- (void) inviteUser:(PFUser*) User toClique:(PFObject *) Clique {
    // Make the invite
    PFObject *Invite = [PFObject objectWithClassName:@"JoinInvite"];
    // Add Clique
    [Invite setObject:Clique forKey:@"ToClique"];
    // Add invitee
    [Invite setObject:User forKey:@"Invitee"];
    // Set inviter
    [Invite setObject:[PFUser currentUser] forKey:@"Inviter"];
    // Declare as not accepted
    [Invite setValue:@NO forKey:@"Accepted"];
    
    [Invite saveEventually];

}

- (IBAction)CreateThenSegue:(id)sender {
    PFObject *NewClique = [self createClique:CliqueName.text];
    
    FriendsModel *sharedFriendsModel = [FriendsModel GetSharedInstance];
    
    for (PFUser *u in sharedFriendsModel.TempCliqueMembers) {
        [self inviteUser:u toClique:NewClique];
    }
    [sharedFriendsModel.TempCliqueMembers removeAllObjects];
    
}

#pragma mark - Text View Functions

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - searchbar functions

- (void)searchBarSearchButtonClicked:(UISearchBar *)asearchBar
{
    [displayContent removeAllObjects];
    
    FriendsModel * sharedFriendsModel = [FriendsModel GetSharedInstance];
    
    for (int i = 0; i < sharedFriendsModel.Friends.count; i++)
    {
        PFUser * thisUser = sharedFriendsModel.Friends[i];
        NSString *thisName = sharedFriendsModel.FriendFullNames[i];
        if ([thisUser.username isEqualToString:asearchBar.text] || [thisName isEqualToString:asearchBar.text])
        {
            [displayContent addObject:thisName];
            [displayUsers addObject:thisUser];
        }
    }
    
    [tableView reloadData];
    [searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)asearchBar
{
    [asearchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)asearchBar
{
    asearchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)asearchBar
{
    NSLog(@"searchBarTextDidEndEditing:");
    [asearchBar resignFirstResponder];
}

#pragma mark - Table view sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return displayContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the shared friends model
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];

    int row = [indexPath row];
    BOOL remove = NO;
    // The dequeue reusable cell thing is memory saving reusable cell magic mumbo jumbo
    FriendCliqueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCliqueCell"];
    
    // Decide whether add or remove
    for (int i = 0; i < SharedFriendsModel.TempCliqueMembers.count; i++) {
        if (SharedFriendsModel.TempCliqueMembers[i] == displayContent[row]) {
            [cell.AddButton setTitle: @"Remove" forState: UIControlStateNormal];
            [cell.AddButton setTitle: @"Remove" forState: UIControlStateApplication];
            [cell.AddButton setTitle: @"Remove" forState: UIControlStateHighlighted];
            [cell.AddButton setTitle: @"Remove" forState: UIControlStateReserved];
            [cell.AddButton setTitle: @"Remove" forState: UIControlStateDisabled];
            remove = YES;
        }
    }
    if (remove == NO) {
        [cell.AddButton setTitle: @"Add" forState: UIControlStateNormal];
        [cell.AddButton setTitle: @"Add" forState: UIControlStateApplication];
        [cell.AddButton setTitle: @"Add" forState: UIControlStateHighlighted];
        [cell.AddButton setTitle: @"Add" forState: UIControlStateReserved];
        [cell.AddButton setTitle: @"Add" forState: UIControlStateDisabled];
    }
    
    cell.UsernameLabel.text = displayContent[row];
    cell.User = displayUsers[row];

    return cell;
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
