//
//  LocationShareModel.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackgroundTaskManager.h"

#import <CoreLocation/CoreLocation.h>

@interface LocationShareModel : NSObject

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer * delay10Seconds;
@property (nonatomic) BackgroundTaskManager * bgTask;
@property (nonatomic) NSMutableArray *myLocationArray;
@property(nonatomic,strong) NSMutableArray *Annotations;
@property(nonatomic,strong) NSMutableArray *VenueAnnotations;

+(id)sharedModel;

@end
