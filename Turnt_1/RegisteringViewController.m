//
//  RegisteringViewController.m
//  Project_Turnt
//
//  Created by Jake Spracher on 11/30/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import "RegisteringViewController.h"
#import "AppDelegate.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <Parse/Parse.h>

@interface RegisteringViewController ()

@property (weak, nonatomic) IBOutlet UIButton *SignUp;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmpassword;
@property (weak, nonatomic) IBOutlet UITextField *PhoneNum;


@end

@implementation RegisteringViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.username becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Force the Navigation Bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    self.navigationController.navigationBar.translucent = YES;
    
    // set the delegate as the AppDelegate
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // force text field colors, specify return key titles
    UIColor *color = [UIColor lightGrayColor];
    UIColor *bordercolor = [UIColor clearColor];
    
    self.username.layer.borderColor=[bordercolor CGColor];
    self.username.layer.borderWidth=1.0;
    [self.username setReturnKeyType:UIReturnKeyNext];
    self.username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.password.layer.borderColor=[bordercolor CGColor];
    self.password.layer.borderWidth=1.0;
    [self.password setReturnKeyType:UIReturnKeyNext];
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.confirmpassword.layer.borderColor=[bordercolor CGColor];
    self.confirmpassword.layer.borderWidth=1.0;
    [self.confirmpassword setReturnKeyType:UIReturnKeyNext];
    self.confirmpassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.PhoneNum.layer.borderColor=[bordercolor CGColor];
    self.PhoneNum.layer.borderWidth=1.0;
    [self.PhoneNum setReturnKeyType:UIReturnKeyDone];
    self.PhoneNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mobile Phone Number" attributes:@{NSForegroundColorAttributeName: color}];
    
}

// only segue is to find friends table, so this is the registering function as well
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

// To find friends table
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"\nPreparing for segue to findfriendstable");
    
}

- (IBAction)Register:(id)sender {
    
    NSLog(@"\nEntered shouldperformsegue while registering");
    
    // ensure all fields are entered
    if(self.username.text.length > 0 &&
       self.password.text.length > 0 &&
       self.PhoneNum.text.length > 0 &&
       self.confirmpassword.text.length > 0)
    {
        // ensure passwords are the same length
        if(![self.password.text isEqualToString:self.confirmpassword.text])
        {
            //generic error message code
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Passwords don't match"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        else
            [self registerUtility];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"All fields are required"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    return;
    
}

-(void) registerUtility {
    //4
    // format the number so all server numbers are stored in the same format
    NSString *rawNumber = self.PhoneNum.text;
    NSString *cleanedNumber = [[rawNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet] ] componentsJoinedByString:@""];
    
    // ensure this number isnt already registered
    PFQuery *query = [PFUser query];
    [query whereKey:@"phone" equalTo:cleanedNumber];
    NSArray *temp = [query findObjects];
    
    if (temp.count != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"This number is already registered with Turnt. Contact info@getturntapp.com if you believe this is in error"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Create the registering user from the parse class
    PFUser *user = [PFUser user];
    user.username = self.username.text;
    user.password = self.password.text;
    // Phone number is a PFUser custom field, this is syntax for that:
    user[@"phone"] = cleanedNumber;
    
    // Set Gender
    switch (gender.selectedSegmentIndex) {
        case 0:
            user[@"Female"] = @NO;
            break;
            
        case 1:
            user[@"Female"] = @YES;
            break;
    };
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"success");
            // Sign up this device for push notifications
            [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
            [[PFInstallation currentInstallation] saveEventually];
            if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
                [self performSegueWithIdentifier:@"StraightToTable" sender:nil];
            }
            else {
                [self performSegueWithIdentifier:@"FindMyFriends" sender:nil];
            }
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:errorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];

}

// Phone # request explanation action
- (IBAction)WhyNigga:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Why do I gotta give my number?"
                                                    message:@"Turnt uses your phone number to help you find your friends among your contacts. We won't call you, were not that close yet."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Text Field Delegate

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    if ([textField isKindOfClass:[JSTextField class]])
        dispatch_async(dispatch_get_current_queue(),
                       ^ { [[(JSTextField *)textField nextField] becomeFirstResponder]; });
    
    return YES;
    
}


#pragma mark - Phone Number Formatting

// Formats the phone number as you type it
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 3) {
        int length = [self getLength:textField.text];
        //NSLog(@"Length  =  %d ",length);
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            //NSLog(@"%@",[num  substringToIndex:3]);
            //NSLog(@"%@",[num substringFromIndex:3]);
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
        
        return YES;
    }
    
    return YES;
    
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    return length;
    
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self.view endEditing:YES];
}

- (IBAction)userDismiss:(id)sender {
    [userField resignFirstResponder];
}

- (IBAction)passDismiss:(id)sender {
    [passField resignFirstResponder];
}

- (IBAction)passConDismiss:(id)sender {
    [passConField resignFirstResponder];
}

- (IBAction)numDismiss:(id)sender {
    [numField resignFirstResponder];
}

@end
