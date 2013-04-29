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
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "GPPShare.h"
#import "GPPSignIn.h"

@interface sendViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, FBFriendPickerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, GPPSignInDelegate, GPPShareDelegate>
{
    IBOutlet UIButton *fbButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *SMSButton;
    IBOutlet UIButton *buttonF;
    IBOutlet UIButton *buttonT;
    IBOutlet UIButton *buttonG; 
}

@property NSMutableArray *selectedFriends;
@property NSDictionary *restaurantInfo;
@property ACAccountStore *accountStore; 

@end
