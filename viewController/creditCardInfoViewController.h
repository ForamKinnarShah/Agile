//
//  creditCardInfoViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/26/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface creditCardInfoViewController : UIViewController <UITextFieldDelegate>

@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *address1TextField;
@property IBOutlet UITextField *address2TextField;
@property IBOutlet UITextField *cardTypeTextField;
@property IBOutlet UITextField *cardNumberTextField;
@property IBOutlet UIButton *addCardBtn; 
@property IBOutlet UITextField *securityCodeTextField;
@property IBOutlet UITextField *expirationDateTextField; 
@property UIDatePicker *datePicker; 

-(IBAction)addCreditCard:(id)sender; 

@end
