//
//  UpdatePlansView.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/10/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "UpdatePlansView.h"
#import "MainViewController.h"
#import <Parse/Parse.h>

@interface UpdatePlansView ()

@end

@implementation UpdatePlansView
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    PlansTextView.delegate = self;
    PlansTextView.text = @"Tap to enter your plans here";
    PlansTextView.textColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Dismiss:(id)sender {
    
    // Push the plans to the server
    PFUser* curr = [PFUser currentUser];
    curr[@"Plans"] = PlansTextView.text;
    [curr saveInBackground];

    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
}

- (IBAction)Cancel:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Tap to enter your plans here"]) {
        textView.text = @"";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Tap to enter your plans here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
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
