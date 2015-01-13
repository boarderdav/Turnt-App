//
//  UpdatePlansView.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/10/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"

@protocol PopupDelegate;

@interface UpdatePlansView : UIViewController {
    IBOutlet UITextView *PlansTextView;
}

@property (assign, nonatomic) id <PopupDelegate>delegate;

@end

@protocol PopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(UpdatePlansView*)UpdatePlansView;
@end