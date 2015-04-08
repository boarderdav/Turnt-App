//
//  UpdatePlansView.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/10/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"

@class UpdatePlansView;

@protocol UpdatePlansViewDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(UpdatePlansView*)aUpdatePlansView;
@end

@interface UpdatePlansView : UIViewController <UITextViewDelegate> {
    IBOutlet UITextView *PlansTextView;
}

@property (assign, nonatomic) id <UpdatePlansViewDelegate> delegate;

@end

