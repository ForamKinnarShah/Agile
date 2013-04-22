//
//  CheckinViewController.h
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSLocationLoader.h"
#import "UICheckIns.h"
#import "NSImageLoaderToImageView.h"
#import "utilities.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CheckinViewController : UIViewController <UITabBarControllerDelegate, UITextFieldDelegate,UINavigationControllerDelegate,NSLocationLoaderProtocol,UICheckInsProtocol, CLLocationManagerDelegate>{
    @private
    NSLocationLoader *Locations;
    utilities *UIBlocker;
    CLLocationManager *locationManager; 
    IBOutlet UIButton *btnMap;
    CLLocation *currentLocation;
    NSMutableArray *sortedLocations;
    
}
@property (strong, nonatomic) IBOutlet UIButton *FilterButton;
@property (strong, nonatomic) IBOutlet UITextField *FilterTextBox;
@property (strong, nonatomic) IBOutlet UIScrollView *LocationsView;
@property id delegate; //for modal presentation from heres2u controller

-(IBAction)btnMap_Click:(id)sender;




@end
