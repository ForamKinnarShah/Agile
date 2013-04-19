//
//  settingsViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSGlobalConfiguration.h"
#import <MessageUI/MessageUI.h>

@interface settingsViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property UITabBarController *tabBarC;

-(IBAction)goToCreditCardInfoPage:(id)sender; 

@end
