//
//  RegisteringViewController.h
//  Project_Turnt
//
//  Created by Jake Spracher on 11/30/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JSTextField.h"

@class RegisteringViewController;

@protocol RegisteringViewControllerDelegate <NSObject>

-(BOOL) startLocUpdates;

@end


@interface RegisteringViewController: UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *userField;
    IBOutlet UITextField *numField;
    IBOutlet UITextField *passConField;
    IBOutlet UITextField *passField;
    IBOutlet UISegmentedControl *gender;
}

@property (nonatomic, weak) id <RegisteringViewControllerDelegate> delegate;

- (IBAction)userDismiss:(id)sender;
- (IBAction)passDismiss:(id)sender;
- (IBAction)passConDismiss:(id)sender;
- (IBAction)numDismiss:(id)sender;


@end
