//
//  UpdateLocationPopupSegue.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/11/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "UpdateLocationPopupSegue.h"

@implementation UpdateLocationPopupSegue

- (void)perform {
    [self.sourceViewController presentPopupViewController:self.destinationViewController animationType:MJPopupViewAnimationSlideBottomBottom];
}

@end
