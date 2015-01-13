//
//  UpdatePlansPopupSegue.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/9/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "UpdatePlansPopupSegue.h"

@implementation UpdatePlansPopupSegue

- (void)perform {
    [self.sourceViewController presentPopupViewController:self.destinationViewController animationType:MJPopupViewAnimationSlideBottomBottom];
}

@end
