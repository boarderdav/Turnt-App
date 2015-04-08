//
//  LocationAccessViewController.m
//  Turnt_1
//
//  Created by Jake Spracher on 2/6/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "LocationAccessViewController.h"
#import "AppDelegate.h"

@interface LocationAccessViewController ()

@end

@implementation LocationAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    // set the delegate as the AppDelegate
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Allow:(id)sender {
    
    if ([self.delegate startLocUpdates]) {
        [self performSegueWithIdentifier:@"ToMainStoryboard" sender:sender];
    }
    else
        [self performSegueWithIdentifier:@"ToMainStoryboard" sender:sender];
    
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
