//
//  JSStoryboardPopPresentSegue.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/3/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "JSStoryboardPopPresentSegue.h"

@implementation JSStoryboardPopPresentSegue

- (void)perform {
    
    [self.destinationViewController setModalPresentationStyle:self.presentationStyle];
    [self.destinationViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.sourceViewController presentViewController:self.destinationViewController
                                            animated:self.animated
                                          completion:self.completion];
}

@end
