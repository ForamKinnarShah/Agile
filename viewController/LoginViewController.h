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
    UIActivityIndicatorView *UIBlocker;
    NSMutableData *rawData;
}
@property     UIActivityIndicatorView *UIBlocker;

-(IBAction)login:(id)sender;
- (IBAction)LostPassword:(id)sender;

@property NSString *centerImageName; 
// textfield for Loast Password
@property (nonatomic, strong) UITextField *txtEmail;

// assign properties
@property (nonatomic, strong) IBOutlet UITableView *tblLogin;
// assign properties for tableview
@property (nonatomic, strong) UITextField *txtEmail_Login,*txtPassword;

@end
