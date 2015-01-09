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
            // Go to main view
            [self performSegueWithIdentifier:@"LoginMeow" sender:sender];
            
        } else {
            // The login failed. Check error to see why.
            if (error.code == 101) {
                // Display a pretty error for invalid credentials
                UIAlertView *noCred = [[UIAlertView alloc] initWithTitle:@"Username/Password Not Found"
                                                                message:@"Can u spel? Or you might be drunk, sorry."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [noCred show];
            }
            else if (error.code == 100) {
                // Display a pretty error for no network connection
                UIAlertView *noConnection = [[UIAlertView alloc] initWithTitle:@"The login server could not be reached"
                                                                 message:@"Please ensure that you are connected to the internet and try again."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                [noConnection show];
            }
            else {
                // Explain other errors with ugly parse description
                UIAlertView *otherAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:error.description
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [otherAlert show];
            }

        }
    }];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"\n--Preparing for segue to landing screen");
    
}

@end
