//
//  LocationCell.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/23/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell
@synthesize location;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Delete:(id)sender {
    [location deleteEventually];
    [self.delegate thisCellDeleted:self];
    
}

@end
