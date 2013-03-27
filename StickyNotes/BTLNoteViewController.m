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

@synthesize currentNote;

- (void)viewDidLoad
{
    //self.titleTextField.text = _currentTitle;
    //self.descriptionTextView.text = _currentDescription;
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [BTLLocationManager sharedLocationManager].delegate = self;
    
    //in case, no location has been set for the note, set it here
    //if (!(_currentNote.notelocation)) {
       // CLLocation *currentLocation = [BTLLocationManager sharedLocationManager].locationManager.location;
       // _currentNote.notelocation = currentLocation;


    [self.titleTextField setText:[self.currentNote valueForKey:@"noteTitle"]];
    [self.descriptionTextView setText:[self.currentNote valueForKey:@"noteDescription"]];




    _currentLocation =[[CLLocation alloc] initWithLatitude:_currentLat.doubleValue longitude:_currentLong.doubleValue];
    NSLog(@"when adding pin lat is %f and long is %f", _currentLat.doubleValue, _currentLong.doubleValue);
    [self addPinToMapAtLocation: _currentLocation];
    
    self.descriptionTextView.delegate = self;
}


- (IBAction)changeTitle:(id)sender {
    _currentTitle = self.titleTextField.text;
    
    
    [self.delegate updateNote:self.descriptionTextView.text withTitle:self.titleTextField.text objectId:_currentID];
    
}

//IBAction to change description property of  _currentNote if corresponding textView is changed
-(void)textViewDidChange:(UITextView *)textView {
    _currentDescription = self.descriptionTextView.text;
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
    //pin.coordinate = location.coordinate;
    _currentLat = [self.currentNote valueForKey:@"noteLatitude"];
    _currentLong = [self.currentNote valueForKey:@"noteLongitude"];
    _currentLocation =[[CLLocation alloc] initWithLatitude:_currentLat.doubleValue longitude:_currentLong.doubleValue];
    pin.coordinate = _currentLocation.coordinate;
    
    //pin.title = _currentTitle;
    [self.currentNote valueForKey:@"noteTitle"];
    
    //pin.subtitle = _currentDescription;
    
    NSLog(@"lat = %f, long = %f", pin.coordinate.latitude, pin.coordinate.longitude);
    [self.mapView addAnnotation:pin];
    MKCoordinateRegion region = { { 0.0f, 0.0f }, { 0.0f, 0.0f } };
    //region.center = location.coordinate;
    region.center = _currentLocation.coordinate;
    region.span.longitudeDelta = 0.15f;
    region.span.latitudeDelta = 0.15f;
    [self.mapView setRegion:region animated:YES];
    
    
    //[self.mapView removeObserver:pin forKeyPath:@"coordinate"];
}

// preparation for segue from tableView to noteView
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LocationSelect"]) {
        BTLLocationManager *locationSelector = [segue destinationViewController];
        locationSelector.delegate = self;
    }
}

#pragma mark locationSelectorDelegate

-(void) setLocation:(CLLocation*)location
{
    double updatedLat = location.coordinate.latitude;
    _currentLat = [NSNumber numberWithDouble:updatedLat];
    NSLog(@"updatedLat is %f",updatedLat);
    
    double updatedLon = location.coordinate.longitude;
    _currentLong = [NSNumber numberWithDouble:updatedLon];
    
    _currentLocation =[[CLLocation alloc] initWithLatitude:_currentLat.doubleValue longitude:_currentLong.doubleValue];
    
    
    [self.currentNote setValue:_currentLat forKey:@"noteLatitude"];
    [self.currentNote setValue:_currentLong forKey:@"noteLongitude"];
    

    NSLog(@"location chosen = %f %f",location.coordinate.latitude,location.coordinate.longitude);
    
    //remove previous pins and add pin at updated location
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self addPinToMapAtLocation:_currentLocation];
    
    
}
@end
