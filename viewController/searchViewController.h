//
//  searchViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface searchViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,FBFriendPickerDelegate, MFMessageComposeViewControllerDelegate>
{
    NSArray *selectedFriends; 
}

@property NSArray *selectedFriends;
@property NSMutableArray *selectedContacts;
@end
