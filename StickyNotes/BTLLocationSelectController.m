//
//  BTLLocationSelectController.m
//  StickyNotes
//
//  Created by Benedikt Lotter on 3/26/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import "BTLLocationSelectController.h"

#define kBTLFoursquareURL @"https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=0PISWUPDQ4PTJS2TGTY5WGO1VPZMRDHE2IPKK2D0JD5MEOCF&client_secret=ECAQG4ZLDYHZXH43FCYTIPYDYICKZ5BGWVFOYQLZ4SQEONKK&v=20130311"
#define kBTLCellIdentifier @"FoursquareCells"

@interface BTLLocationSelectController ()

@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) NSMutableData *data;

@end



@implementation BTLLocationSelectController


- (void)viewDidLoad
{
    
    // Make HTTP request.
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kBTLFoursquareURL]];
    //
    CLLocation *currentLocation = [BTLLocationManager sharedLocationManager].locationManager.location;
    
    //convert the lat lon values into strings to prepare for string interpolation into url for request to 4square
    NSString* formattedLat = [NSString stringWithFormat:@"%.02f", currentLocation.coordinate.latitude];
    NSString* formattedLon = [NSString stringWithFormat:@"%.02f", currentLocation.coordinate.longitude];
    NSString* formattedTouple = [NSString stringWithFormat:@"%@,%@",formattedLat,formattedLon];
    NSLog(formattedTouple);
    
    //make 4square request with formatted touple of lat long
    NSString *urlAddress = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@&client_id=0PISWUPDQ4PTJS2TGTY5WGO1VPZMRDHE2IPKK2D0JD5MEOCF&client_secret=ECAQG4ZLDYHZXH43FCYTIPYDYICKZ5BGWVFOYQLZ4SQEONKK&v=20130311",formattedTouple];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kBTLCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBTLCellIdentifier];
    }
    
    cell.textLabel.text = self.locations[indexPath.row][@"name"];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get the lat lon values from foursquare response in NSArray locations
    NSString *selectedLat = self.locations[indexPath.row][@"location"][@"lat"];
    NSString *selectedLon = self.locations[indexPath.row][@"location"][@"lng"];
    
    //converts strings into double values
    float fLat = [selectedLat doubleValue];
    float fLon = [selectedLon doubleValue];
    
    //initialize selected Location with these double values
    CLLocation *selectedLocation = [[CLLocation alloc] initWithLatitude:fLat longitude:fLon];
    
    //pass the location of the selected foursquare venue to the noteViewController which acts as delegate of the locationSelectController
    [self.delegate setLocation:selectedLocation];
    //pop the current VC off the stack to return to noteViewController
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - NSURLConnectionDataDelegate Methods

/**
 * Here are the NSURLConnectionDataDelegate methods that handle the callbacks.
 * This is mostly primarily and three step process, assuming you get no errors.
 *
 * 1. You receive a response.
 * 2. You receive any number of pieces of data.
 * 3. The connection finishes loading. That is, you are ready to use the combined pieces of data.
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error and display an error message.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *foursquareResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    self.locations = foursquareResponse[@"response"][@"venues"];
    [self.tableView reloadData];
    NSLog(@"%@", foursquareResponse); // If you want to see what the 4SQ response looks like.
}


@end
