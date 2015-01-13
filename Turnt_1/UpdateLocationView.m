//
//  UpdateLocationView.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/11/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "UpdateLocationView.h"
#import "LocationModel.h"
#import <Parse/Parse.h>

@interface UpdateLocationView ()

@end

@implementation UpdateLocationView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)MarkLocation:(id)sender {
    
    LocationModel *GetSharedModel = [LocationModel getSharedInstance];
    
    PFGeoPoint *currentPoint =
    [PFGeoPoint geoPointWithLatitude:GetSharedModel.Lattitude
                           longitude:GetSharedModel.Longitude];
    
    // Save This location as a place
    PFObject *saveLoc = [PFObject objectWithClassName:@"SavedLocation"];
    [saveLoc setObject:[PFUser currentUser]  forKey:@"User"];
    [saveLoc setObject:currentPoint forKey:@"Coordinate"];
    [saveLoc setObject:self.LocationDescription.text forKey:@"Name"];
    [saveLoc save];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
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
