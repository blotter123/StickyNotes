//
//  BTLLocationManager.h
//  StickyNotes
//
//  Created by Benedikt Lotter on 3/24/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol LocationControllerDelegate
@required
- (void)locationUpdate:(CLLocation*)location;
@end

@interface BTLLocationManager : NSObject <CLLocationManagerDelegate>

{
    CLLocationManager* locationManager;
    CLLocation* location;
    __weak id delegate;
    
}

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, weak) id  delegate;

+ (BTLLocationManager *) sharedLocationManager;


@end
