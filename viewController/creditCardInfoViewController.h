//
//  creditCardInfoViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/26/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBMSRequesterDelegate.h"
#import "utilities.h" 

@interface creditCardInfoViewController : UIViewController <UITextFieldDelegate,QBMSRequesterDelegate>
{
    UITextField *activeTextField;
    utilities *UIBlocker;
    
    // stores detail labels to be displayed in table
    NSMutableArray *arrCardDetail;
    // stores the value of different card type
    NSMutableArray *arrCardType;
    NSMutableArray *textEntries; 
    
    IBOutlet UIToolbar *doneBar;
    IBOutlet UIPickerView *pickerCard;
    // a variable to decide which picker is selected
    BOOL SELECTED_PICKER;
}
@property (nonatomic, strong) NSString *strnameTextField;
@property (nonatomic, strong) NSString *straddress1TextField;
@property (nonatomic, strong) NSString *straddress2TextField;
@property (nonatomic, strong) NSString *strcardTypeTextField;
@property (nonatomic, strong) NSString *strcardNumberTextField;
@property UIButton *addCardBtn;
@property (nonatomic, strong) NSString *strsecurityCodeTextField;
@property (nonatomic, strong) NSString *strexpirationDateTextField;
@property UIDatePicker *datePicker; 
@property (nonatomic, strong) NSString *strExpirationDate,*strCardType;

// assignments for tableview
@property (nonatomic, strong) UILabel *lblCardDetail,*lblexiprationDate,*lblCardType;
@property (nonatomic, strong) UITextField *txtName,*txtBillingAddress,*txtAddressLine2,*txtCardNumber,*txtSecurityCode;
@property (nonatomic, strong) IBOutlet UITableView *tblCreditCardInfo;
// for adding done button 
@property (nonatomic, readwrite) BOOL addDone;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, strong) UIView *possibleKeyboard;

-(IBAction)addCreditCard:(id)sender; 

// button actions
- (IBAction)bg_clicked:(id)sender;
-(IBAction)Done_Picker;

@end
