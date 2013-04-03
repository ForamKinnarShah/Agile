//
//  sendViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface sendViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UIButton *fbButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *SMSButton;
    IBOutlet UITextField *messageTextField; 
}

@end
