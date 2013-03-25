//
//  BTLLocationManager.m
//  StickyNotes
//
//  Created by Benedikt Lotter on 3/24/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLLocationManager.h"

@implementation BTLLocationManager

@synthesize locationManager, location, delegate;

#pragma mark Singleton Methods
static BTLLocationManager *sharedLocationManager = nil;

//instantiate an instance of the sharedLocationManager
+ (id)sharedLocationManager {
    NSLog(@"sharedLocationManager gets called");
    @synchronized(self) {
        if (sharedLocationManager == nil)
            sharedLocationManager = [[self alloc] init];
    }
    NSLog(@"shared locationManager locMan is %@",sharedLocationManager.locationManager);
    return sharedLocationManager;
}



//initalize the properties of the shared locationManager and set the delegate
- (id)init
{
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 1000;
    }
    return self;
}


#pragma LocationManagerDelegate Methods


//implementation of the lcoationManager method of the CLLocationManager protocol
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation

{
    NSLog(@"locationManager of sharedLocManager gets called");
    //[self.delegate locationUpdate:newLocation];
}

@end
