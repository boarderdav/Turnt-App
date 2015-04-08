//
//  YouCell.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/31/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface YouCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *ContactNameLabel;
@property (strong,nonatomic) PFUser* User;
@property (strong, nonatomic) IBOutlet UILabel *LocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *EventLabel;
@property (strong, nonatomic) IBOutlet UITextView *PlansTextView;

@end
