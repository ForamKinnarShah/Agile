//
//  mapViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 4/21/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface mapViewController : UIViewController

{
    IBOutlet MKMapView *mapView;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *item; 
}
@property IBOutlet MKMapView *mapView;
@property NSMutableArray *annotations;

-(void)annotateMapViewWithLocations:(NSArray*)sortedLocations;

@end
