//
//  AppDelegate.h
//  Project_Turnt
//
//  Created by Jake Spracher on 11/30/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UIViewController+MJPopupViewController.h"
#import "LocationTracker.h"
#import "RegisteringViewController.h"
#import "LocationAccessViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, RegisteringViewControllerDelegate, LocationAccessViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard * storyboard;
@property (strong, nonatomic) UIViewController *viewController;
@property (nonatomic) BOOL safeToLaunch;

@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

- (NSURL *)applicationDocumentsDirectory;


@end

