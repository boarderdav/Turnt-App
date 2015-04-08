//
//  ManageCliquesViewController.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/3/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "ManageCliquesViewController.h"
#import "CliqueCell.h"
#import <Parse/Parse.h>

@interface ManageCliquesViewController ()

@end

@implementation ManageCliquesViewController
@synthesize Cliques;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Force the Navigation Bar Color
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = YES;

    // Allocate memory for cliques
    Cliques = [[NSMutableArray alloc] init];
    
    // Get cliques you created
    PFQuery *CliqueQuery = [PFQuery queryWithClassName:@"Clique"];
    [CliqueQuery whereKey:@"Creator" equalTo:[PFUser currentUser]];
    [CliqueQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [Cliques addObjectsFromArray:objects];
        [tableView reloadData];
    }];
    
    // Get cliques invited to join
    PFQuery *InviteQuery = [PFQuery queryWithClassName:@"JoinInvite"];
    [InviteQuery whereKey:@"Invitee" equalTo:[PFUser currentUser]];
    [InviteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject* o in objects) {
            PFObject *clique = o[@"ToClique"];
            [clique fetch];
            [Cliques addObject:clique];
        }
        [tableView reloadData];
    }];

    // Get cliques accepted into
    PFQuery *RequestQuery = [PFQuery queryWithClassName:@"JoinRequest"];
    [RequestQuery whereKey:@"Requester" equalTo:[PFUser currentUser]];
    [RequestQuery whereKey:@"Approved" equalTo:@YES];
    [RequestQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject* o in objects) {
            [o fetch];
            [Cliques addObject:o[@"ToClique"]];
        }

        [tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.Cliques count];
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The dequeue reusable cell thing is memory saving reusable cell magic mumbo jumbo
    CliqueCell *cell = [atableView dequeueReusableCellWithIdentifier:@"CliqueCell"];
    
    int row = [indexPath row];
    cell.CliqueNameLabel.text = Cliques[row][@"Name"];
    //cell.UsernameLabel.text = self.MatchUsers[row][@"username"];
    //cell.ContactNameLabel.text = self.MatchContactNames[row];
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
