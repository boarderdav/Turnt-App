//
//  LoginViewController.m
//  Project_Turnt
//
//  Created by Jake Spracher on 11/30/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import "LoginViewController.h"
#import <AddressBook/AddressBook.h>
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.Username becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //UIButton *registerButton = [ [UIButton alloc] init: target:self action:@selector(registernow:)];
    
    // Force the Navigation Bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    self.navigationController.navigationBar.translucent = YES;
    
    UIColor *color = [UIColor lightGrayColor];
    UIColor *bordercolor = [UIColor clearColor];
    
    self.Username.layer.borderColor=[bordercolor CGColor];
    self.Username.layer.borderWidth=1.0;
    [self.Username setReturnKeyType:UIReturnKeyNext];
    self.Username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.Password.layer.borderColor=[bordercolor CGColor];
    self.Password.layer.borderWidth=1.0;
    [self.Password setReturnKeyType:UIReturnKeyDone];
    self.Password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginMeow:(id)sender {

    [PFUser logInWithUsernameInBackground:self.Username.text password:self.Password.text
    block:^(PFUser *user, NSError *error) {
        if (user) {
            // Successful login
            [self performSegueWithIdentifier:@"LoginMeow" sender:sender];

        } else {
            // The Parse login failed. Check error to see why.
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
    
    return;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"\n--Preparing for segue to landing screen");
    
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    if ([textField isKindOfClass:[JSTextField class]])
        dispatch_async(dispatch_get_current_queue(),
                       ^ { [[(JSTextField *)textField nextField] becomeFirstResponder]; });
    
    return YES;
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self.view endEditing:YES];
}

@end
