//
//  UpdateLocationView.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/11/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "UpdateLocationView.h"
#import "LocationTracker.h"
#import <Parse/Parse.h>

@interface UpdateLocationView ()

@end

@implementation UpdateLocationView
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LocationDescription.delegate = self;
    LocationDescription.text = @"Tap here to enter a Location name to save. Whenever you're near here, this name will be displayed to your followers in the feed automatically.";
    LocationDescription.textColor = [UIColor lightGrayColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)MarkLocation:(id)sender {
    CLLocationManager *locationTracker = [LocationTracker sharedLocationManager];
    CLLocationCoordinate2D coord = locationTracker.location.coordinate;
    
    PFGeoPoint *currentPoint =
    [PFGeoPoint geoPointWithLatitude:coord.latitude
                           longitude:coord.longitude];
    
    if (Venue == NO) {
        if (![LocationDescription.text isEqualToString:@"Tap here to enter a Location name to save. Whenever you're near here, this name will be displayed to your followers in the feed automatically."]) {
            // Save This location as a place
            PFObject *saveLoc = [PFObject objectWithClassName:@"SavedLocation"];
            [saveLoc setObject:[PFUser currentUser]  forKey:@"User"];
            [saveLoc setObject:currentPoint forKey:@"Coordinate"];
            [saveLoc setObject:LocationDescription.text forKey:@"Name"];
            [saveLoc save];
            
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
                [self.delegate cancelButtonClicked:self];
            }
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Location Entered"
                                                            message:@"Tap the center text to enter a location name"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else if(Venue == YES) {
         if(![LocationDescription.text isEqualToString:@"Tap here to enter a Venue name to save. Your followers will be able to click it in the map to see how many ppl are here, girls, guys, etc."]) {
            // Save This location as a place
            PFObject *saveLoc = [PFObject objectWithClassName:@"Venue"];
            [saveLoc setObject:[PFUser currentUser]  forKey:@"Creator"];
            [saveLoc setObject:currentPoint forKey:@"Location"];
            [saveLoc setObject:LocationDescription.text forKey:@"Name"];
            [saveLoc save];
             
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
                [self.delegate cancelButtonClicked:self];
            }
        }
         else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Venue Entered"
                                                             message:@"Tap the center text to enter a Venue name"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
         }
        
    }
    
}

- (IBAction)Cancel:(id)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

- (IBAction)setLocVenue:(id)sender {
    switch (((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            [LocationDescription becomeFirstResponder];
            LocationDescription.text = @"Tap here to enter a Location name to save. Whenever you're near here, this name will be displayed to your followers in the feed automatically.";
            [LocationDescription resignFirstResponder];
            Venue = NO;
            break;
            
        case 1:
            [LocationDescription becomeFirstResponder];
            LocationDescription.text = @"Tap here to enter a Venue name to save. Your followers will be able to click it in the map to see how many ppl are here, girls, guys, etc.";
            [LocationDescription resignFirstResponder];
            Venue = YES;
            break;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
        if ([textView.text isEqualToString:@"Tap here to enter a Location name to save. Whenever you're near here, this name will be displayed to your followers in the feed automatically."]) {
            textView.text = @"";
        }
        else if ([textView.text isEqualToString:@"Tap here to enter a Venue name to save. Your followers will be able to click it in the map to see how many ppl are here, girls, guys, etc."]) {
            textView.text = @"";
        }
        [textView becomeFirstResponder];

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
        if (Venue == NO) {
            if ([textView.text isEqualToString:@""]) {
                textView.text = @"Tap here to enter a Location name to save. Whenever you're near here, this name will be displayed to your followers in the feed automatically.";
            }
            [textView resignFirstResponder];
        }
        else if (Venue == YES) {
            if ([textView.text isEqualToString:@""]) {
                textView.text = @"Tap here to enter a Venue name to save. Your followers will be able to click it in the map to see how many ppl are here, girls, guys, etc.";
            }
            [textView resignFirstResponder];
        }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
