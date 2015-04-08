//
//  LocationCell.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/23/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class LocationCell;

@protocol locationCellDelegate <NSObject>

-(void)thisCellDeleted:(LocationCell*)Cell;

@end

@interface LocationCell : UITableViewCell {

}
@property (nonatomic, strong) IBOutlet UILabel *Label;
@property (nonatomic, strong) PFObject *location;
@property (nonatomic, strong) IBOutlet UIButton *DeleteButton;
@property (nonatomic, weak) id <locationCellDelegate> delegate;

@end
