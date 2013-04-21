//
//  sendViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@interface sendViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, FBFriendPickerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UIButton *fbButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *SMSButton;
    IBOutlet UITextField *messageTextField;
    IBOutlet UIButton *submitButton;
    IBOutlet UIButton *buttonF;
    IBOutlet UIButton *buttonT;
    IBOutlet UIButton *buttonG; 
}

@property NSMutableArray *selectedFriends;
@property NSDictionary *restaurantInfo;

@end
