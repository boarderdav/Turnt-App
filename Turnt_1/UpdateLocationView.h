//
//  UpdateLocationView.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/11/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"

@class UpdateLocationView;

@protocol UpdateLocationViewDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(UpdateLocationView*)aUpdatePlansView;
@end


@interface UpdateLocationView : UIViewController <UITextViewDelegate> {
    IBOutlet UITextView *LocationDescription;
    IBOutlet UISegmentedControl *LocVenue;
    BOOL Venue;
}

@property (assign, nonatomic) id <UpdateLocationViewDelegate> delegate;

@end
