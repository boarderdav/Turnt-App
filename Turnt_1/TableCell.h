//
//  TableCell.h
//  Turnt
//
//  Created by Jake Spracher on 12/29/14.
//  Copyright (c) 2014 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *ContactNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *UsernameLabel;
@property (strong, nonatomic) IBOutlet UIButton *FollowButton;

@end
