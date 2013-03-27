//
//  BTLLocationSelectController.h
//  StickyNotes
//
//  Created by Benedikt Lotter on 3/26/13.
//  Copyright (c) 2013 Benedikt Lotter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLNoteViewController.h"
#import "BTLTableViewController.h"
#import <CoreLocation/CoreLocation.h>


@protocol LocationSelectorDelegate <NSObject>

@optional

- (void)setLocation:(CLLocation*)location;

@end

@interface BTLLocationSelectController : UITableViewController

@property (nonatomic, weak) id <LocationSelectorDelegate> delegate;

@end
