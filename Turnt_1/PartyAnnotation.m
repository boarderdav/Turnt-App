//
//  PartyAnnotation.m
//  Turnt_1
//
//  Created by Jake Spracher on 1/11/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import "PartyAnnotation.h"

@implementation PartyAnnotation

-(id)initWithTitle:(NSString *)newTitle subTitle:(NSString*)newsubTitle Location:(CLLocationCoordinate2D)location {
    self = [super init];
    
    if(self) {
        _title = newTitle;
        _subTitle = newsubTitle;
        _coordinate = location;
    }
    
    return self;
}

- (NSString *)subtitle {
    return _subTitle;
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
