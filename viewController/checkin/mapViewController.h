//
//  mapViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 4/21/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "mapViewControllerDelegate.h" 

@interface mapViewController : UIViewController

{
    IBOutlet MKMapView *mapView;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *item; 
}
@property IBOutlet MKMapView *mapView;
@property NSMutableArray *annotations;
@property NSArray *locations; 
@property id delegate;

-(void)annotateMapViewWithLocations:(NSArray*)sortedLocations;

@end
