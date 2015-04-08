//
//  AppDelegate.m
//  Project_Turnt
//
//  Created by Jake Spracher on 11/30/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <AddressBook/AddressBook.h>
#import "LoginViewController.h"

#import "FriendsModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize safeToLaunch;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Initialize connection with Parse
    [Parse setApplicationId:@"lMmBDCknngx1EbLF1G4BoJuHqhJcs0Baxrv8uiVS"
                  clientKey:@"DI0T1zGR6hLS48IQqTqoH5xawtjed6lZcFuJmSvt"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Register for Push Notitications
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    // Initialize memory for the friends model
    FriendsModel* SharedFriendModel = [FriendsModel GetSharedInstance];
    [SharedFriendModel initialize];
    
    // Make the status bar color light
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Initialize window programatically so that storyboard can be selected programatically
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // If the user has previously logged in on this device:
    if ([PFUser currentUser]) {
        // Go straight to the Turnt home screen ("Main Controller":RootViewController -> "Activity Feed":MainViewController) and do other neccesary stuff
        
        // Sign up this device for push notifications (Just in case, remove this later and put in registration section if API requests get high or loading the app takes to long)
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
        [[PFInstallation currentInstallation] saveEventually];
        
        [self checkforFollows];
        [self presentMainView];
        
    } else {
        
        // Go to Account Creation/Login ("Login and Registration":LoginViewController)
        [self presentLoginRegistration];
    }
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([PFUser currentUser]) {
        // Check for new follows:
        [self checkforFollows];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Global App Utilities

-(BOOL) startLocUpdates {
    
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work properly without Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because Background App Refresh is disabled."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    } else{
        
        self.locationTracker = [[LocationTracker alloc]init];
        [self.locationTracker startLocationTracking];
        
        //Send the best location to server every 60 seconds
        //You may adjust the time interval depends on the need of your app.
        NSTimeInterval time = 120.0;
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
        return YES;
    }
}

-(void) checkforFollows {
    // Check for new follows:
    PFQuery *newFollowQuery = [PFQuery queryWithClassName:@"Follow"];
    [newFollowQuery whereKey:@"To" equalTo:[PFUser currentUser]];
    [newFollowQuery whereKey:@"Accepted" equalTo:@NO];
    [newFollowQuery whereKey:@"Read" equalTo:@NO];
    
    [newFollowQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for(PFObject *o in objects) {
            // Acknowledge reciept of the follow
            o[@"Read"] = @YES;
            [o saveInBackground];
            
            // Get the other user and prompt to follow back
            PFUser* otherUser = [o objectForKey:@"From"];
            [otherUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                // If my nigga is pressed,
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:object[@"username"]
                                                                message:@"This user has followed you. Follow Back?"
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles:@"Yes", nil];
                [alert show];
            }];
        }
        
    }];
}

#pragma mark - Delegates

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    FriendsModel *SharedFriendsModel = [FriendsModel GetSharedInstance];
    
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
        
    }else{
        [SharedFriendsModel FollowUserBack:alertView.title];
    }
}

-(void)updateLocation {
    NSLog(@"Updated Location on Server");
    
    [self.locationTracker updateLocationToServer];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - View Presentation Functions

- (void)presentMainView {
    
    [self startLocUpdates];
    
    self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [self.window setRootViewController:self.viewController];
    //self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
}

- (void)presentLoginRegistration {
    self.storyboard = [UIStoryboard storyboardWithName:@"LoginReg" bundle:nil];
    self.viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginRegLaunch"];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
}

- (void)presentManageFriends {
    self.storyboard = [UIStoryboard storyboardWithName:@"ManageFriends" bundle:nil];
    self.viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageFriends"];

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
}

#pragma mark - Push Notification Functions

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    if ( application.applicationState == UIApplicationStateActive ){
        [self checkforFollows];
    }
    
}

@end
