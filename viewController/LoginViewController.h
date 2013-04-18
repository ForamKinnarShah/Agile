//
//  LoginViewController.h
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationViewController.h"
#import "NSUserAccessControl.h"
#import "utilities.h"
@interface LoginViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate,NSUserAccessControlProtocol>
{
    utilities *UIBlocker; 
}
-(IBAction)login:(id)sender;
- (IBAction)LostPassword:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *usrname;
@property (strong, nonatomic) IBOutlet UITextField *pass;
@property NSString *centerImageName; 

@end
