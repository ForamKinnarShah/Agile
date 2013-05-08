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
//    self.title = @"Check-in";
//    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"dot.png"];
//    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:self.title image:img tag:2];
//    self.tabBarItem = tab;
    // Custom initialization
    // Do any additional setup after loading the view from its nib.
    
    if (self.presentingViewController)
    {
        // Do any additional setup after loading the view.
        NSString *centerImageName = @"logo_small.png";
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
        
         [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnCancel_Click:)]];
    }
    else{
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToAdd:)]];
    }
    
    Locations=[[NSLocationLoader alloc] init];
    [Locations setDelegate:self];
    //[Locations downloadLocations];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    UIBlocker = [[utilities alloc] init];
    [UIBlocker startUIBlockerInView:self.tabBarController.view];

    arrayTitle = [[NSMutableArray alloc]init];
    arrayFindNumber = [[NSMutableArray alloc]init];

    // Set notification for when textfield is edited
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchForText) name:UITextFieldTextDidChangeNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    FilterTextBox.text =@"";
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
{
    [textField resignFirstResponder];
    NSLog(@"fiterText:%@",FilterTextBox.text);
    
    if([textField.text isEqualToString:@""] || textField.text.length==0){
        [self locationloaderCompleted:nil];
    }
        
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    @try {
        [textField resignFirstResponder];
        [self locationloaderCompleted:nil];
        
    }
    @catch (NSException *exception) {
        
    }
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    NSLog(@"textField.text.length : %d",textField.text.length);
    return YES;
}

-(void)searchForText{
    @try {
        NSLog(@"arrayTitle : %@",arrayTitle);
        NSLog(@"textField.text.length : %d",FilterTextBox.text.length);
        NSLog(@"%@",FilterTextBox.text);
        
        // For string kind of values:
        for(UIView *CurrentView in LocationsView.subviews){
            [CurrentView removeFromSuperview];
        }
        
        NSArray *results=nil;
        NSLog(@"arrayTitle count : %d",arrayTitle.count);
        NSLog(@"Locations count : %d",Locations.count);
        
        for(NSInteger i=0;i<[sortedLocations count];i++){
            
            //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", FilterTextBox.text];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[c] %@", FilterTextBox.text];
            results = [arrayTitle filteredArrayUsingPredicate:predicate];
            NSLog(@"results : %@",results);
        }
        
        
        
        int count1=0;
        int y=10;
        BOOL isMatch;
        
        for(int i=0; i<results.count; i++){
            isMatch = NO;
            NSString *strArrayTitle = [NSString stringWithFormat:@"%@",[results objectAtIndex:i]];
            NSLog(@"strArrayTitle : %@",strArrayTitle);
            
            
            NSDictionary *ItemData1=[sortedLocations objectAtIndex:i];
            
            for(int k=0;k<=ItemData1.count;k++){
                NSLog(@"ItemData1.count : %d",ItemData1.count);
                if(isMatch){
                    break;
                }
                
                NSDictionary *ItemData=[sortedLocations objectAtIndex:k];
                NSString *strItemTitle = [NSString stringWithFormat:@"%@",[ItemData valueForKey:@"Title"]];
                
                if([strItemTitle isEqualToString:strArrayTitle]){
                    
                    count1++;
                    UICheckIns *CheckIn=[[UICheckIns alloc] initWithFrame:CGRectMake(0, y, 0, 95)];
                    [CheckIn.Distance setText:[NSString stringWithFormat:@"%i mi",[[ItemData objectForKey:@"distance"] intValue]]];
                    [CheckIn.Name setText:[ItemData valueForKey:@"Title"]];
                    
                    [CheckIn.Location setText:[NSString stringWithFormat:@"%@",[ItemData valueForKey:@"Address"]]];
                    [CheckIn setDelegate:self];
                    [CheckIn setTag:i];
                    
                    if (self.presentingViewController)
                    {
                        CheckIn.checkInLabel.text = @"buy gift here";
                    }
                    
                    [CheckIn setID:[(NSString *)[ItemData valueForKey:@"ID"] integerValue]];
                    NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData valueForKey:@"Image"]] ImageView:CheckIn.Picture];
                    [img start];
                    //                    LocationsView.frame = CGRectMake(0, y, 320, 100);
                    [LocationsView addSubview:CheckIn];
                    y+=95;
                    isMatch = YES;
                }
            }
        }
        [LocationsView setContentSize:CGSizeMake(320, ((count1+1)*110))];
        [LocationsView setScrollEnabled:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"NSException : %@",exception);
    }
}

-(IBAction)goToAdd:(id)sender {
     addViewController *add = [[addViewController alloc] initWithNibName:@"addViewController" bundle:nil];
     [self.navigationController pushViewController:add animated:YES];
}

-(IBAction)btnCancel_Click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NO];
}



-(IBAction)goToCheckinComment:(id)sender {
    checkinCommentViewController *add = [[checkinCommentViewController alloc] initWithNibName:@"checkinCommentViewController" bundle:nil];
    [self.navigationController pushViewController:add animated:YES];
}

-(void)mapViewControllerClickedDoneButton
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)btnMap_Click:(id)sender
{
    
    mapViewController *mapVC = [[mapViewController alloc] initWithNibName:@"mapViewController" bundle:nil];
    mapVC.locations = sortedLocations;
    mapVC.delegate = self;
    [self presentViewController:mapVC animated:YES completion:NULL];
    
}

-(void)locationloaderCompleted:(NSLocationLoader *)loader{
    
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];
    //Clear Everything in LocationsView
    for(UIView *CurrentView in LocationsView.subviews){
        [CurrentView removeFromSuperview];
    }
    [arrayTitle removeAllObjects];
    LocationsView.frame = CGRectMake(0, 44, 320, 480);
    
    
    sortedLocations = [self sortLocationsByDistance];
    int checkinViewLength = 95;
    int spaceBetweenCheckinViews = 6;
    
    for(NSInteger i=0;i<[sortedLocations count];i++){
        NSDictionary *ItemData=[sortedLocations objectAtIndex:i];
        NSLog(@"ItemData : %@",ItemData);
        
        
        UICheckIns *CheckIn=[[UICheckIns alloc] init];
        CheckIn.frame = CGRectMake(0, (checkinViewLength*i), 320, checkinViewLength);
        
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
        {
        [CheckIn.Distance setText:[NSString stringWithFormat:@"%i mi",[[ItemData objectForKey:@"distance"] intValue]]];
        }
        else {
            [CheckIn.Distance setText:@""]; 
        }
        
        [CheckIn.Name setText:[ItemData valueForKey:@"Title"]];
        
        [arrayTitle addObject:[ItemData valueForKey:@"Title"]];
        
        [CheckIn.Location setText:[NSString stringWithFormat:@"%@",[ItemData valueForKey:@"Address"]]];
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
    [LocationsView setContentSize:CGSizeMake(320, ([Locations count]*checkinViewLength)+75)];
    if(!isiPhone5){
        [LocationsView setContentSize:CGSizeMake(320,  ([Locations count]*checkinViewLength)+150)];
    }
    
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
        
        [self.delegate setRestaurantInfo:[sortedLocations objectAtIndex:checkin.tag]];
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
    
     NSLog(@"strLat : %@",currentLat);
     NSLog(@"strLat : %@",currentLong);
    
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
        float dLongRadians = fabsf(([locationLong floatValue] - currentLocation.coordinate.longitude) * 3.141596 / 180);
        float dlatRadians = fabsf(([locationLat floatValue] - currentLocation.coordinate.latitude) * 3.141596 / 180);
                
        float lat1 = [locationLat floatValue] * 3.141596/180;
        float lat2 = currentLocation.coordinate.latitude * 3.141596 / 180;
//        
        float a = sinf(dlatRadians/2) * sinf(dlatRadians/2) + sinf(dLongRadians/2) * sinf(dLongRadians/2) * cosf(lat1) * cosf(lat2);
        float c = 2 * atan2f(sqrtf(a), sqrtf((1-a)));
        float distanceFromLocation = c * 3959;
        
        NSLog(@"Lat :%@,  Long:%@",locationLat,locationLong);
        NSLog(@"distanceFromLocation :%f",distanceFromLocation);
        
      // float a = sinf(lat1) * sinf(lat2) + cosf(lat1) * cosf(lat2) * cosf(dLongRadians);
      //  float distanceFromLocation = acosf(a) * 180/3.141596 * 60 * 1.1515;
        
        //float distanceFromLocation = sqrtf( powf( (currentLocation.coordinate.latitude - [locationLat floatValue]),2) + powf( (currentLocation.coordinate.longitude - [locationLong floatValue]),2));
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithFloat:distanceFromLocation], [NSNumber numberWithInt:i],nil] forKeys:[NSArray arrayWithObjects:@"distance",@"index", nil]];
        [distances addObject:dic];
    }
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                                 ascending:YES];
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

#pragma mark
#pragma mark button actions

// user touches anywhere in the background
- (IBAction)bg_clicked:(id)sender
{
    [FilterTextBox resignFirstResponder];
}

- (void)dealloc
{
    [locationManager stopUpdatingLocation]; 
}
@end
