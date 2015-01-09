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

@property (nonatomic, strong) NSMutableArray *CliqueNames;
@property (nonatomic, strong) NSMutableArray *MatchUsers;

@end

@implementation ManageCliquesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.CliqueNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The dequeue reusable cell thing is memory saving reusable cell magic mumbo jumbo
    CliqueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    int row = [indexPath row];
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
