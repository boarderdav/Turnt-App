//
//  PartyAnnotation.h
//  Turnt_1
//
//  Created by Jake Spracher on 1/11/15.
//  Copyright (c) 2015 Turnt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PartyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* subTitle;

-(id)initWithTitle:(NSString *)newTitle subTitle:(NSString*)newsubTitle Location:(CLLocationCoordinate2D)location;
- (NSString *)subtitle;
-(MKAnnotationView *)annotationView;

@end
