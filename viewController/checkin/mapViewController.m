//
//  mapViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 4/21/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "mapViewController.h"

@interface mapViewController ()

@end

@implementation mapViewController

@synthesize mapView, annotations, locations;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self annotateMapViewWithLocations:locations];
    //[self zoomToYouAndNearest];
    [self zoomToLA]; 
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)annotateMapViewWithLocations:(NSArray*)sortedLocations
{
    CLLocationCoordinate2D annotationCoord;
    annotations = [NSMutableArray arrayWithCapacity:0]; 
    for (int i=0; i<[sortedLocations count]; i++)
    {
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationCoord.latitude = [[[sortedLocations objectAtIndex:i] objectForKey:@"Latitude"] floatValue];
        annotationCoord.longitude = [[[sortedLocations objectAtIndex:i] objectForKey:@"Longitude"] floatValue];
        annotationPoint.coordinate = annotationCoord;
        annotationPoint.title = [[sortedLocations objectAtIndex:i] objectForKey:@"Title"];
        annotationPoint.subtitle = [[sortedLocations objectAtIndex:i] objectForKey:@"Address"];
        [annotations addObject:annotationPoint]; 
    }
    for (int i=0; i<[annotations count]; i++)
    {
        [mapView addAnnotation:annotations[i]];
    }
    
    mapView.showsUserLocation = YES;
    NSLog(@"annotationCoord:%f %f",annotationCoord.longitude,annotationCoord.latitude);
    //mapView.region = MKCoordinateRegionMakeWithDistance(annotationCoord, 50,50);
 
}

-(void)zoomToYouAndNearest
{
    MKMapPoint annotationPoint = MKMapPointForCoordinate(mapView.userLocation.coordinate);
    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    
        MKMapPoint annotationPoint2 = MKMapPointForCoordinate([mapView.annotations[0] coordinate]);
        MKMapRect pointRect = MKMapRectMake(annotationPoint2.x, annotationPoint2.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    
    [mapView setVisibleMapRect:zoomRect animated:YES];
}

-(void)zoomToLA
{
    MKCoordinateRegion LA = MKCoordinateRegionMake(CLLocationCoordinate2DMake(34.03, -118.14), MKCoordinateSpanMake(1, 1));
    [mapView setRegion:LA]; 
}

-(IBAction)doneButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(mapViewControllerClickedDoneButton)])
    {
        [self.delegate mapViewControllerClickedDoneButton]; 
    }
}
@end
