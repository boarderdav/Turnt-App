//
//  SettingsCell.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/23/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor darkGrayColor]]; // set color here
    [self setSelectedBackgroundView:selectedBackgroundView];
    
}

@end
