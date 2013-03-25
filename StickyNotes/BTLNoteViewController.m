//
//  BTLNoteViewController.m
//  StickyNotes
//
//  Created by Benedikt Lotter on 3/24/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLNoteViewController.h"
#import "BTLAppDelegate.h"


@implementation BTLNoteViewController

- (void)viewDidLoad
{
    self.titleTextField.text = _currentTitle;
    self.descriptionTextView.text = _currentDescription;
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [BTLLocationManager sharedLocationManager].delegate = self;
    
    //in case, no location has been set for the note, set it here
    //if (!(_currentNote.notelocation)) {
       // CLLocation *currentLocation = [BTLLocationManager sharedLocationManager].locationManager.location;
       // _currentNote.notelocation = currentLocation;
    

    
    _currentLocation =[[CLLocation alloc] initWithLatitude:_currentLat.doubleValue longitude:_currentLong.doubleValue];
    
    [self addPinToMapAtLocation: _currentLocation];
    
    self.descriptionTextView.delegate = self;
}


- (IBAction)changeTitle:(id)sender {
    _currentTitle = self.titleTextField.text;
    [self.delegate updateNote:self.descriptionTextView.text withTitle:self.titleTextField.text objectId:_currentID];
    
}




-(void)setFields:(NSString*)title noteDescription:(NSString*)descript latitude:(NSNumber*) lat longitude:(NSNumber*)lon objectId:(NSManagedObjectID *)objId{
    _currentTitle = title;
    _currentDescription = descript;
    _currentLat = lat;
    _currentLong = lon;
    _currentLocation =[[CLLocation alloc] initWithLatitude:_currentLat.doubleValue longitude:_currentLong.doubleValue];
    _currentID = objId;
    
}


#pragma mark - LocationControllerDelegate methods

//delegate method that gets called by the singelton class BTLCLLocationManagerDelegate once a location update is detected
- (void)locationUpdate:(CLLocation *)location
{
    
}






// method to draw pins to the map based on the location passed down from the shared location manager
- (void)addPinToMapAtLocation:(CLLocation *)location
{
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = location.coordinate;
    pin.title = _currentTitle;
    pin.subtitle = _currentDescription;
    [self.mapView addAnnotation:pin];
    MKCoordinateRegion region = { { 0.0f, 0.0f }, { 0.0f, 0.0f } };
    region.center = location.coordinate;
    region.span.longitudeDelta = 0.15f;
    region.span.latitudeDelta = 0.15f;
    [self.mapView setRegion:region animated:YES];
}
@end
