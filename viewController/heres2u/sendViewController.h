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
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

#define TWITTER_CONSUMER_KEY @"LH5kISWjImDe9O7v3AG6g"
#define TWITTER_CONSUMER_SECRET @"QUx8OZ7psg31JTeZI7UATBurdDTDDtGXspIfh1IF0gg"

@interface sendViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, FBFriendPickerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, GPPSignInDelegate, GPPShareDelegate>
{
    IBOutlet UIButton *fbButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *SMSButton;
    IBOutlet UIButton *buttonF;
    IBOutlet UIButton *buttonT;
    IBOutlet UIButton *buttonG;
    
    // for twitter
    SA_OAuthTwitterEngine *engine;
    NSString *strTwitterText;
}

@property NSMutableArray *selectedFriends;
@property NSDictionary *restaurantInfo;
@property ACAccountStore *accountStore;


// assign properties
@property (strong, nonatomic) IBOutlet UILabel *lblGreetings;
// stores gift reciever's name
@property (strong, nonatomic) NSString *strRecieverName;
// keeps track of  switch inside table
@property (strong, nonatomic) UISwitch *switchFacebook,*switchTwitter;
// declare an instance for the tableview
@property (strong, nonatomic) IBOutlet UITableView *tblGreetings;

// share button action
-(IBAction)Share:(id)sender;
// email button action
-(IBAction)Email:(id)sender;

@end
