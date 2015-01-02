//
//  LoginViewController.m
//  Project_Turnt
//
//  Created by Jake Spracher on 11/30/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>


@interface LoginViewController ()
//<UITextFieldDelegate,
//UIScrollViewDelegate,
//NewUserViewControllerDelegate>

//@property (nonatomic, assign) BOOL activityViewVisible;
//@property (nonatomic, strong) UIView *activityView;

//@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
//@property (nonatomic, strong) IBOutlet UIView *backgroundView;
//@property (nonatomic, strong) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //UIButton *registerButton = [ [UIButton alloc] init: target:self action:@selector(registernow:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    NSLog(@"\n--Entered shouldperformsegue while logging in");

    return YES;
     
}

- (IBAction)LoginMeow:(id)sender {

    [PFUser logInWithUsernameInBackground:self.Username.text password:self.Password.text
    block:^(PFUser *user, NSError *error) {
        if (user) {
            // Do stuff after successful login.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"... fuck you though"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            [self performSegueWithIdentifier:@"LoginMeow" sender:sender];
            
        } else {
            // The login failed. Check error to see why.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.description
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"\n--Preparing for segue to landing screen");
    
}

@end
