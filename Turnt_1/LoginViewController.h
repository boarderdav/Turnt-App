//
//  ViewController.h
//  Project_Turnt
//
//  Created by Jake Spracher on 11/30/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class LoginViewController;



//@protocol LoginViewControllerDelegate <NSObject>

//- (void)loginViewControllerDidLogin:(LoginViewController *)controller;

//@end


@interface LoginViewController : UIViewController

//@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *Username;
@property (weak, nonatomic) IBOutlet UITextField *Password;


@end

