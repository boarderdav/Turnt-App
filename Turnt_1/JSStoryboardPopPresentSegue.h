//
//  JSStoryboardPopPresentSegue.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/3/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "RBStoryboardSegue.h"

@interface JSStoryboardPopPresentSegue : RBStoryboardSegue

@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;

@property (nonatomic, assign) UIModalTransitionStyle transitionStyle;

@property (nonatomic, copy) dispatch_block_t completion;

@end
