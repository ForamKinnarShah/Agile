//
//  registerViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController <UITextFieldDelegate>

{ UITextField IBOutlet *username;
    UITextField IBOutlet *password;
    UITextField IBOutlet *email;
    UITextField IBOutlet *name;
    UITextField IBOutlet *phoneNo;
}

@end
