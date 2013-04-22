//
//  CheckinViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "CheckinViewController.h"
#import "addViewController.h"
#import "checkinCommentViewController.h"
#import "menuViewController.h" 
#import "Heres2uViewController.h" 
#import "mapViewController.h"

@interface CheckinViewController ()

@end

@implementation CheckinViewController
@synthesize FilterButton,FilterTextBox,LocationsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
//    self.title = @"Check-in";
//    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"dot.png"];
//    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:self.title image:img tag:2];
//    self.tabBarItem = tab;
    // Custom initialization
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToAdd:)]];
    Locations=[[NSLocationLoader alloc] init];
    [Locations setDelegate:self];
    //[Locations downloadLocations];
    UIBlocker = [[utilities alloc] init];
    [UIBlocker startUIBlockerInView:self.tabBarController.view]; 
}

-(void)viewDidAppear:(BOOL)animated
{
    [Locations downloadLocations]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{ [textField resignFirstResponder];
    NSLog(@"fiterText:%@",FilterTextBox.text);
    
    return YES;
}
     
-(IBAction)goToAdd:(id)sender {
         addViewController *add = [[addViewController alloc] initWithNibName:@"addViewController" bundle:nil];
         [self.navigationController pushViewController:add animated:YES];
}

-(IBAction)goToCheckinComment:(id)sender {
    checkinCommentViewController *add = [[checkinCommentViewController alloc] initWithNibName:@"checkinCommentViewController" bundle:nil];
    [self.navigationController pushViewController:add animated:YES];
}

-(IBAction)btnMap_Click:(id)sender
{
    
    mapViewController *mapVC = [[mapViewController alloc] initWithNibName:@"mapViewController" bundle:nil];
    mapVC.locations = sortedLocations;
    mapVC.delegate = self; 
    //[mapVC annotateMapViewWithLocations:sortedLocations];
    [self presentViewController:mapVC animated:YES completion:NULL];
    //[mapVC annotateMapViewWithLocations:sortedLocations];
    
}

-(void)mapViewControllerClickedDoneButton
{
    [self dismissViewControllerAnimated:YES completion:NULL]; 
}

-(void)locationloaderCompleted:(NSLocationLoader *)loader{
    
    [UIBlocker stopUIBlockerInView:self.tabBarController.view]; 
    //Clear Everything in LocationsView
    for(UIView *CurrentView in LocationsView.subviews){
        [CurrentView removeFromSuperview];
    }
    
    sortedLocations = [self sortLocationsByDistance];
    
    for(NSInteger i=0;i<[sortedLocations count];i++){
        NSDictionary *ItemData=[sortedLocations objectAtIndex:i];
        NSLog(@"ItemData : %@",ItemData);
        
        UICheckIns *CheckIn=[[UICheckIns alloc] initWithFrame:CGRectMake(0, (100*i), 0, 0)];
        [CheckIn.Distance setText:[NSString stringWithFormat:@"%i mi",[[ItemData objectForKey:@"distance"] intValue]]];
        [CheckIn.Name setText:[ItemData valueForKey:@"Title"]];
        [CheckIn.Location setText:[ItemData valueForKey:@"Address"]];
        [CheckIn setDelegate:self];
        [CheckIn setTag:i];
        
        if (self.presentingViewController)
        {
            CheckIn.checkInLabel.text = @"buy gift here"; 
        }
        
        [CheckIn setID:[(NSString *)[ItemData valueForKey:@"ID"] integerValue]];
        NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData valueForKey:@"Image"]] ImageView:CheckIn.Picture];
        [img start];
        [LocationsView addSubview:CheckIn];
    }
    [LocationsView setContentSize:CGSizeMake(320, ([Locations count]*100))];
    [LocationsView setScrollEnabled:YES];
}
-(void) locationloaderFailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];
    [alert show];
}
-(void)checkinRequested:(UICheckIns *)checkin{
    
   // NSLog(@"checkin requested");
    
    if (self.presentingViewController) //indicates it is being called from heres2u view controller, and should go to menu page next
    {  NSLog(@"isBeingPresented");
        
        //Heres2uViewController *h2u = [self.tabBarController.viewControllers objectAtIndex:2];
        
        [self.delegate setRestaurantInfo:[Locations getLocationAtIndex:checkin.tag]];
        [self dismissViewControllerAnimated:YES completion:^{
            
            NSLog(@"something"); 
            if ([self.delegate respondsToSelector:@selector(loadMenuView)])
            {
                NSLog(@"responds to selector");
                [self.delegate loadMenuView];
            }
        }];
        //menuViewController *menu = [[menuViewController alloc] initWithNibName:@"menuViewController" bundle:nil];
        
    }
    else {
    checkinCommentViewController *add = [[checkinCommentViewController alloc] initWithNibName:@"checkinCommentViewController" bundle:nil Checkin:checkin];
        add.tabBar = self.tabBarController; 
    [self.navigationController pushViewController:add animated:YES]
     ;}
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error!" message:@"Failed to Get Your Location. Please Turn on your device location services." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    NSString *currentLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    NSString *currentLong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    
   // NSLog(@"strLat : %@",currentLat);
   // NSLog(@"strLat : %@",currentLong);
    
    // Reverse Geocoding
    //NSLog(@"Resolving the Address");
    
}

-(NSMutableArray*)sortLocationsByDistance
{
    NSMutableArray *distances = [NSMutableArray arrayWithCapacity:0]; 
    
    for(NSInteger i=0;i<[Locations count];i++)
    {
       NSString *locationLong = [[Locations getLocationAtIndex:i] objectForKey:@"Longitude"];
       NSString *locationLat = [[Locations getLocationAtIndex:i] objectForKey:@"Latitude"];
        
        //Haversine formala for calculating distance in miles between two long/lat coordinates
        float dLongRadians = ([locationLong floatValue] - currentLocation.coordinate.longitude) * 3.141596 / 180;
        float dlatRadians = ([locationLat floatValue] - currentLocation.coordinate.latitude) * 3.141596 / 180;
        float lat1 = [locationLat floatValue] * 3.141596/180;
        float lat2 = currentLocation.coordinate.latitude * 3.141596 / 180;
        
        float a = sinf(dlatRadians/2) * sinf(dlatRadians/2) + sinf(dLongRadians/2) * sinf(dLongRadians/2) * cosf(lat1) * cosf(lat2);
        float c = 2 * atan2f(sqrtf(a), sqrtf((1-a)));
        float distanceFromLocation = c * 3959;
        
        //float distanceFromLocation = sqrtf( powf( (currentLocation.coordinate.latitude - [locationLat floatValue]),2) + powf( (currentLocation.coordinate.longitude - [locationLong floatValue]),2));
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithFloat:distanceFromLocation], [NSNumber numberWithInt:i],nil] forKeys:[NSArray arrayWithObjects:@"distance",@"index", nil]]; 
        [distances addObject:dic];
    }
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSArray *sortedDicArray = [distances sortedArrayUsingDescriptors:sortDescriptors];
    NSMutableArray *sortedLocations= [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in sortedDicArray)
    {
        int index = [[dic objectForKey:@"index"] intValue]; 
        NSMutableDictionary *location = [[Locations getLocationAtIndex:index] mutableCopy];
        [location setObject:[dic objectForKey:@"distance"] forKey:@"distance"]; 
        [sortedLocations addObject:location];
    }
    return sortedLocations; 
}


@end
