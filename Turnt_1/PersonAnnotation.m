//
//  PersonAnnotation.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/11/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "PersonAnnotation.h"

@implementation PersonAnnotation

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location {
    self = [super init];
    
    if(self) {
        _title = newTitle;
        _coordinate = location;
    }
    
    return self;
}

-(MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                 reuseIdentifier:@"MyCustomAnnotation:"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"IconHome"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}


@end
