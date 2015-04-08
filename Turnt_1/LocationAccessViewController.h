//
//  LocationAccessViewController.h
//  Turnt_1
//
//  Created by Jake Spracher on 2/6/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationAccessViewController;

@protocol LocationAccessViewControllerDelegate <NSObject>

-(BOOL) startLocUpdates;

@end


@interface LocationAccessViewController : UIViewController

@property (nonatomic, weak) id <LocationAccessViewControllerDelegate> delegate;

-(IBAction)Allow:(id)sender;

@end
