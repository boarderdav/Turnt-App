//
//  JSTextField.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/22/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "JSTextField.h"

@implementation JSTextField
@synthesize nextField;

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
