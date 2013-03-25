//
//  BTLNoteViewController.h
//  StickyNotes
//
//  Created by Benedikt Lotter on 3/24/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BTLTableViewController.h"
#import "BTLLocationManager.h"

@protocol NoteSelectorDelegate <NSObject>

@optional

- (void)updateNote:(NSString*)descriptionString withTitle:(NSString *)titleString objectId:(NSManagedObjectID *)objId;

@end


@interface BTLNoteViewController : UIViewController <LocationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;





//@property NSInteger *currentNoteIndex;
@property (nonatomic, weak) id <NoteSelectorDelegate> delegate;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property NSString *currentTitle;
@property NSString *currentDescription;
@property NSNumber *currentLat;
@property NSNumber *currentLong;
@property CLLocation *currentLocation;
@property NSManagedObjectID *currentID;

-(void)setFields:(NSString*)title noteDescription:(NSString*)descript latitude:(NSNumber*)lat longitude:(NSNumber*)lon objectId:(NSManagedObjectID*)objId;

@end
