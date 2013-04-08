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
@interface LoginViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate,NSUserAccessControlProtocol>

-(IBAction)login:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *usrname;
@property (strong, nonatomic) IBOutlet UITextField *pass;
@property NSString *centerImageName; 

@end
