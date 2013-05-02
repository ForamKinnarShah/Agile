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
    
    IBOutlet UIToolbar *doneBar;
    IBOutlet UIPickerView *pickerCard;
    // a variable to decide which picker is selected
    BOOL SELECTED_PICKER;
}
@property UITextField *nameTextField;
@property UITextField *address1TextField;
@property UITextField *address2TextField;
@property UITextField *cardTypeTextField;
@property UITextField *cardNumberTextField;
@property UIButton *addCardBtn;
@property UITextField *securityCodeTextField;
@property UITextField *expirationDateTextField;
@property UIDatePicker *datePicker; 
@property (nonatomic, strong) NSString *strExpirationDate,*strCardType;

// assignments for tableview
@property (nonatomic, strong) UILabel *lblCardDetail,*lblexiprationDate,*lblCardType;
@property (nonatomic, strong) UITextField *txtCardDetail;

// assign properties
@property (nonatomic, strong) IBOutlet UITableView *tblCreditCardInfo;

-(IBAction)addCreditCard:(id)sender; 

// button actions
- (IBAction)bg_clicked:(id)sender;
-(IBAction)Done_Picker;

@end
