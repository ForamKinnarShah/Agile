//
//  creditCardInfoViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 3/26/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "creditCardInfoViewController.h"
#import "NSGlobalConfiguration.h" 
#import "QBMSRequester.h" 
#import "utilities.h" 

@interface creditCardInfoViewController ()

@end

@implementation creditCardInfoViewController

@synthesize  datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    textEntries = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<7; i++){
        textEntries[i] = @"";
    }
    
    NSString *centerImageName = @"logo_small.png";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addCreditCard:)]]; 
    
   // [(UIScrollView*)self.view setContentSize:self.view.bounds.size];
    // Do any additional setup after loading the view from its nib.
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 239, 320, 44)];
    datePicker.hidden = YES;
    [datePicker setDatePickerMode:UIDatePickerModeDate];
//    [datePicker addTarget:self action:@selector(datePickerPicked) forControlEvents:UIControlEventValueChanged]; 
//    [expirationDateTextField setInputView:datePicker];
  [self.view addSubview:datePicker];

    
    pickerCard.hidden = YES;
    doneBar.hidden = YES;

    //[cardNumberTextField setInputAccessoryView:doneBar];
    
    arrCardDetail = [[NSMutableArray alloc] initWithObjects:@"Name on Card",@"Expiration Date",@"Billing Address",@"Address Line 2",@"Card Type",@"Card Number",@"Security Code", nil];
    _strExpirationDate = @"";
    arrCardType = [[NSMutableArray alloc] initWithObjects:@"Visa", @"Mastercard", @"Amex", nil];

// notification while picking up the nemberpad keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //adjust position of picker & doneBar for smaller iPhone screens
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    
//    //    if iPhone5
//    if(screenSize.height != 568)
//    {
//        [doneBar setFrame:CGRectMake(0, 197, 320, 44)];
//        [pickerCard setFrame:CGRectMake(0, 239, 320, 216)]; 
//    }
    
    _txtName = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
    _lblexiprationDate = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
    _txtBillingAddress = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
    _txtAddressLine2 = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
    _lblCardType = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
    _txtCardNumber = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
    _txtSecurityCode = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];

}

-(void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addCreditCard:(id)sender
{
        
//    for (UITextField *field in [NSArray arrayWithObjects:nameTextField,address1TextField,cardTypeTextField,cardNumberTextField,securityCodeTextField, nil])
//    {
//    for (NSString *field in textEntries)
//    {
//        NSLog(@"field:%@",field);
//        
//        if ([field isEqualToString:@""])
//        {
//            [[[UIAlertView alloc] initWithTitle:@"one or more fields are missing" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
//            return;
//        }
//    }
    
    _strnameTextField = _txtName.text;
    _strexpirationDateTextField = _lblexiprationDate.text;
    _straddress1TextField = _txtBillingAddress.text;
    _straddress2TextField = _txtAddressLine2.text;
    _strcardTypeTextField = _lblCardType.text;
    _strcardNumberTextField = _txtCardNumber.text;
    _strsecurityCodeTextField = _txtSecurityCode.text;
    
    if ([_strnameTextField length] == 0 || [_strexpirationDateTextField length] == 0 || [_straddress1TextField length] == 0 || [_strcardTypeTextField length] == 0 || [_strcardNumberTextField length] == 0 || [_strsecurityCodeTextField length] == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"one or more fields are missing" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if ([_strcardNumberTextField length] != 16)
    {
        [[[UIAlertView alloc] initWithTitle:@"credit card number incorrect" message:@"please check that you entered your number correctly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    
    QBMSRequester *qbms = [[QBMSRequester alloc] init];
    [qbms sendAddWalletRequestForCustomerID:[NSGlobalConfiguration getConfigurationItem:@"ID"] CCNumber:_strcardNumberTextField ExpiryDate:datePicker.date];
    qbms.delegate = self; 
    if (!UIBlocker) {
        UIBlocker = [[utilities alloc] init]; 
    }
    [UIBlocker startUIBlockerInView:self.tabBarController.view]; 
    
    return;
}

/*
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{ [textField resignFirstResponder];
        [self setViewMovedUp:NO];
        //        CGRect textFrame = textField.frame;
        //        //CGRect initialFrame = textField.frame;
        //        CGRect finalFrame =  self.view.frame;
        //        finalFrame.origin = CGPointMake(textFrame.origin.x, textFrame.origin.y);
        //
        //        [UIView animateWithDuration:0.2 animations:^{[self.view setFrame:finalFrame];}];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == cardNumberTextField || textField == securityCodeTextField)
    {
        [self setViewMovedUp:YES]; 
//        CGRect textFrame = textField.frame;
//        //CGRect initialFrame = textField.frame;
//        CGRect finalFrame =  self.view.frame; 
//        finalFrame.origin = CGPointMake(textFrame.origin.x, textFrame.origin.y);
//
//        [UIView animateWithDuration:0.2 animations:^{[self.view setFrame:finalFrame];}];
    }
    else if (textField == expirationDateTextField)
    {
        datePicker.hidden = NO;
    }
}
*/
NSDateFormatter *nsdf;
-(void)datePickerPicked:(UIDatePicker *)datePicker
{
    nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateFormat:@"MM/yyyy"]; 
   
    datePicker.hidden = NO;
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
////    if ([textField.text isEqualToString:@"expiration date"])
////    {
////        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
////        [textField setin]
//    
//   // }
//}
- (void)setViewMovedUp:(BOOL)movedUp
{
    CGRect rect = self.view.frame;
    if (movedUp){
        if(rect.origin.y == 0)
            rect.origin.y = self.view.frame.origin.y - 105;
    }
    else{
        if(rect.origin.y < 0)
            rect.origin.y = self.view.frame.origin.y + 105;
    }
    self.view.frame = rect;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [activeTextField resignFirstResponder];
    [self setViewMovedUp:NO];
}

-(void)QBMSRequesterDelegateFinishedWithCode:(NSString*)code
{
    NSMutableDictionary *creditCardInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_strnameTextField,_straddress1TextField, _straddress2TextField, _strcardTypeTextField, [_strcardNumberTextField substringFromIndex:12],code, nil] forKeys:[NSArray arrayWithObjects:@"nameOnCard",@"address1",@"address2",@"cardType",@"cardNumberLast4Digits",@"walletID", nil]];
    
    NSString *email = [NSGlobalConfiguration getConfigurationItem:@"Email"];
    
    NSMutableArray *cards = [NSGlobalConfiguration getConfigurationItem:email];
    
    if (!cards)
    {
        cards = [NSMutableArray arrayWithCapacity:0]; 
    }
    
    [cards addObject:creditCardInfo]; 
    [NSGlobalConfiguration setConfigurationItem:email Item:cards];
    
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];
    [utilities showAlertWithTitle:@"Credit Card Successfully Added" Message:@"Your card has been added. You are now able to buy gifts for friends!"];
    [self.navigationController popViewControllerAnimated:YES]; 
}

-(void)QBMSRequesterDelegateFailedWithError:(NSError*)error
{
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];
    [utilities showAlertWithTitle:@"Adding Credit Card Failed" Message:@"The credit card information you provided is either inaccurate or your internet connection timed out."];
    NSLog(@"error:%@",error.localizedDescription); 
}

#pragma mark
#pragma mark button actions

// user touches anywhere in the background
- (IBAction)bg_clicked:(id)sender
{
    [(UIScrollView*)self.view setContentSize:self.view.bounds.size];
    datePicker.hidden = YES;
    [self setViewMovedUp:NO];
}

-(IBAction)Done_Picker
{
    [self setViewMovedUp:NO];

    pickerCard.hidden = YES;
    doneBar.hidden = YES;
    datePicker.hidden = YES;
    [_txtName resignFirstResponder];
    [_txtBillingAddress resignFirstResponder];
    [_txtAddressLine2 resignFirstResponder];
    [_txtCardNumber resignFirstResponder];
    [_txtSecurityCode resignFirstResponder];
    
    // if pickerview for
    if (SELECTED_PICKER)
    {
        _strCardType = [arrCardType objectAtIndex:[pickerCard selectedRowInComponent:0]];
        [_lblCardType setText:_strCardType];
        [_txtCardNumber becomeFirstResponder];
    }
    else 
    {
        [self performSelector:@selector(datePickerPicked:) withObject:pickerCard];
        _strExpirationDate = [NSString stringWithFormat:@"%@",[nsdf stringFromDate:datePicker.date]];
        [_lblexiprationDate setText:_strExpirationDate];
        [_txtBillingAddress becomeFirstResponder];
    }
 //   [_tblCreditCardInfo reloadData];
}

#pragma mark
#pragma mark tableview methods

// datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    pickerCard.hidden = YES;
    doneBar.hidden = YES;
    datePicker.hidden = YES;
    [_txtName resignFirstResponder];
    [_txtBillingAddress resignFirstResponder];
    [_txtAddressLine2 resignFirstResponder];
    [_txtCardNumber resignFirstResponder];
    [_txtSecurityCode resignFirstResponder];
    return [arrCardDetail count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (Cell == nil)
    {
        Cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [Cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
        _lblCardDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 24)];
        [_lblCardDetail setBackgroundColor:[UIColor clearColor]];
        [_lblCardDetail setTextColor:[UIColor blackColor]];
        [_lblCardDetail setFont:[UIFont systemFontOfSize:14]];
        _lblCardDetail.tag = 10;
        [Cell.contentView addSubview:_lblCardDetail];
        
        if (indexPath.row == 0)
        {
//            _txtName = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
            [_txtName setTextAlignment:NSTextAlignmentRight];
            _txtName.tag = 100;
            [_txtName setPlaceholder:@"Name"];
            [_txtName setBorderStyle:UITextBorderStyleNone];
            _txtName.delegate = self;
            [_txtName setReturnKeyType:UIReturnKeyNext];
            [_txtName setTextColor:[UIColor blueColor]];
            [_txtName setText:_strnameTextField];
            [Cell.contentView addSubview:_txtName];
        }
        if (indexPath.row == 1)
        {
//            _lblexiprationDate = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
            [_lblexiprationDate setTextAlignment:NSTextAlignmentRight];
            [_lblexiprationDate setText:@"Expiration Date"];
            [_lblexiprationDate setBackgroundColor:[UIColor clearColor]];
            [_lblexiprationDate setTextColor:[UIColor blueColor]];
            [_lblexiprationDate setFont:[UIFont systemFontOfSize:14]];
            _lblexiprationDate.tag = 200;
            [Cell.contentView addSubview:_lblexiprationDate];
        }
        if (indexPath.row == 2)
        {
//            _txtBillingAddress = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
            [_txtBillingAddress setTextAlignment:NSTextAlignmentRight];
            [_txtBillingAddress setReturnKeyType:UIReturnKeyNext];
            [_txtBillingAddress setTextColor:[UIColor blueColor]];
            [_txtBillingAddress setPlaceholder:@"Billing Address"];
            _txtBillingAddress.tag = 300;
            [_txtBillingAddress setBorderStyle:UITextBorderStyleNone];
            _txtBillingAddress.delegate = self;
            [_txtBillingAddress setText:_straddress1TextField];
            [Cell.contentView addSubview:_txtBillingAddress];
        }
        if (indexPath.row == 3)
        {
//            _txtAddressLine2 = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
            [_txtAddressLine2 setTextAlignment:NSTextAlignmentRight];
            [_txtAddressLine2 setReturnKeyType:UIReturnKeyNext];
            [_txtAddressLine2 setPlaceholder:@"Billing Address"];
            [_txtAddressLine2 setTextColor:[UIColor blueColor]];
            _txtAddressLine2.tag = 400;
            [_txtAddressLine2 setBorderStyle:UITextBorderStyleNone];
            _txtAddressLine2.delegate = self;
            [_txtAddressLine2 setText:_straddress2TextField]; 
            [Cell.contentView addSubview:_txtAddressLine2];
        }
        if(indexPath.row == 4)
        {
//            _lblCardType = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
            [_lblCardType setTextAlignment:NSTextAlignmentRight];
            [_lblCardType setText:@"Card Type"];
            [_lblCardType setBackgroundColor:[UIColor clearColor]];
            [_lblCardType setTextColor:[UIColor blueColor]];
            [_lblCardType setFont:[UIFont systemFontOfSize:14]];
            _lblCardType.tag = 500;
            [Cell.contentView addSubview:_lblCardType];
        }
        if (indexPath.row == 5)
        {
//            _txtCardNumber = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
            [_txtCardNumber setTextAlignment:NSTextAlignmentRight];
            [_txtCardNumber setPlaceholder:@"Card Number"];
            _txtCardNumber.tag = 600;
            _txtCardNumber.returnKeyType = UIReturnKeyDone;
            [_txtCardNumber setTextColor:[UIColor blueColor]];
            [_txtCardNumber setBorderStyle:UITextBorderStyleNone];
            _txtCardNumber.delegate = self;
            [_txtCardNumber setKeyboardType:UIKeyboardTypeNumberPad];
            [_txtCardNumber setText:_strcardNumberTextField]; 
            [Cell.contentView addSubview:_txtCardNumber];
        }
        if (indexPath.row == 6)
        {
//            _txtSecurityCode = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
            [_txtSecurityCode setTextAlignment:NSTextAlignmentRight];
            [_txtSecurityCode setPlaceholder:@"code"];
            [_txtSecurityCode setTextColor:[UIColor blueColor]];
            _txtSecurityCode.tag = 700;
            [_txtSecurityCode setBorderStyle:UITextBorderStyleNone];
            _txtSecurityCode.delegate = self;
            [_txtSecurityCode setKeyboardType:UIKeyboardTypeNumberPad];
            [Cell.contentView addSubview:_txtSecurityCode];
        }
    }
    else
    {
        _lblCardDetail = (UILabel *)[Cell.contentView viewWithTag:10];
        _txtName = (UITextField *)[Cell.contentView viewWithTag:100];
        _lblexiprationDate = (UILabel *)[Cell.contentView viewWithTag:200];
        _txtBillingAddress = (UITextField *)[Cell.contentView viewWithTag:300];
        _txtAddressLine2 = (UITextField *)[Cell.contentView viewWithTag:400];
        _lblCardType = (UILabel *)[Cell.contentView viewWithTag:500];
        _txtCardNumber = (UITextField *)[Cell.contentView viewWithTag:600];
        _txtSecurityCode = (UITextField *)[Cell.contentView viewWithTag:700];
    }
    
    [_lblCardDetail setText:[NSString stringWithFormat:@"%@ :",[arrCardDetail objectAtIndex:indexPath.row]]];
   
    if ([_strExpirationDate length] != 0)
        _lblexiprationDate.text = _strExpirationDate;
    
    if ([_strCardType length] != 0)
        _lblCardType.text = _strCardType;
    
    return Cell;
}

// delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    datePicker.hidden = YES;
    pickerCard.hidden = YES;
    doneBar.hidden = YES;
    [_txtName resignFirstResponder];
    [_txtBillingAddress resignFirstResponder];
    [_txtAddressLine2 resignFirstResponder];
    [_txtCardNumber resignFirstResponder];
    [_txtSecurityCode resignFirstResponder];
    
    if (indexPath.row == 0)
        [_txtName becomeFirstResponder];
    if (indexPath.row == 1)
    {
        // no, if date picker is selected
        SELECTED_PICKER = NO;
        datePicker.hidden = NO;
        doneBar.hidden = NO;
        [activeTextField resignFirstResponder]; 
        
        [datePicker setMinimumDate:[NSDate date]];
        [self setViewMovedUp:NO];
    }
    if (indexPath.row == 4)
    {
        // no, if date picker is selected
        SELECTED_PICKER = YES;
        [activeTextField resignFirstResponder];
        pickerCard.hidden = NO;
        doneBar.hidden = NO;

        [self setViewMovedUp:NO];
    }
}

#pragma mark
#pragma mark textfield delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self setViewMovedUp:YES];
    if (textField.tag == 100)
    {
        [self tableView:_tblCreditCardInfo didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
    else if (textField.tag == 300)
    {
        [_txtAddressLine2 becomeFirstResponder];
    }
    else if (textField.tag == 400)
    {
        [self tableView:_tblCreditCardInfo didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    }
    else if (textField.tag == 600)
    {
        [_txtSecurityCode becomeFirstResponder];
    }
    else
    {
        [self setViewMovedUp:NO];
        [textField resignFirstResponder];
    }
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField; 
    [textField becomeFirstResponder];
    datePicker.hidden = YES;
    doneBar.hidden = YES;
    pickerCard.hidden = YES;
    if (textField.tag == 600 || textField.tag == 700)
    {
        [self setViewMovedUp:YES];
        
        _addDone = YES;
        textfieldTag = textField.tag;
        [self keyboardDidShow:nil];
    }
    else
    {
        _addDone = NO;
        [_doneButton removeFromSuperview];
        _doneButton = nil;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    pickerCard.hidden = YES;
    doneBar.hidden = YES;
    datePicker.hidden = YES;
    
    switch (textField.tag)
    {
        case 100:
            _strnameTextField = textField.text;
            break;
        case 300:
            _straddress1TextField = textField.text;
            break;
        case 400:
            _straddress2TextField = textField.text;
            break;
        case 600:
            _strcardNumberTextField = textField.text;
            break;
        case 700:
            _strsecurityCodeTextField = textField.text;
            break;


        default:
            break;
    }
    
    
    
//    if ([_strnameTextField length] == 0)
//        _strnameTextField = _txtName.text;
    
    if ([_strexpirationDateTextField length] == 0)
        _strexpirationDateTextField = _strExpirationDate;
    
//    if ([_straddress1TextField length] == 0)
//        _straddress1TextField = _txtBillingAddress.text;
    
//    if ([_straddress2TextField length] == 0)
//        _straddress2TextField = _txtAddressLine2.text;
    
    if ([_strcardTypeTextField length] == 0)
        _strcardTypeTextField = _strCardType;
    
//    if ([_strcardNumberTextField length] == 0)
//        _strcardNumberTextField = _txtCardNumber.text;
    
//    if ([_strsecurityCodeTextField length] == 0)
//        _strsecurityCodeTextField = _txtSecurityCode.text;
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString*)string
{
    if (textField.tag == 600)
    {
        if (range.location >= 16)
            return NO;
    }
    
    return YES;
}

#pragma mark
#pragma mark pickerview

// datasource

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrCardType count];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrCardType objectAtIndex:row];
}

// delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _strCardType = [arrCardType objectAtIndex:[pickerView selectedRowInComponent:0]];
    textEntries[4] = _strCardType; 
}

#pragma mark 
#pragma mark invoked functions


- (void)keyboardWillShow: (NSNotification *)notification
{
	if(!_addDone)
	{
		return;
	}
	else
	{
		if ([[[UIDevice currentDevice] systemVersion] floatValue] <3.2)  //3.2
		{
			[self performSelector:@selector(addHideKeyboardButtonToKeyboard) withObject:nil afterDelay:0];
		}
	}
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    
    [self addButtonToKeyboard];
    //	if(!addDone)
    //	{
    //		return;
    //	}
    //	else
    //	{
    //		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) // 3.2
    //		{
    //			[self performSelector:@selector(addHideKeyboardButtonToKeyboard) withObject:nil afterDelay:0];
    //		}
    //	}
}
- (void)addHideKeyboardButtonToKeyboard {
	UIWindow *keyboardWindow = nil;
	for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
	{
		if (![[testWindow class] isEqual:[UIWindow class]])
		{
			keyboardWindow = testWindow;
			break;
		}
	}
	if (!keyboardWindow) return;
	
	// Locate UIKeyboard.
	UIView *foundKeyboard = nil;
	for (_possibleKeyboard in [keyboardWindow subviews]) {
		
		// iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
		if ([[_possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
			_possibleKeyboard = [[_possibleKeyboard subviews] objectAtIndex:0];
		}
		
		if ([[_possibleKeyboard description] hasPrefix:@"<UIKeyboard"]) {
			foundKeyboard = _possibleKeyboard;
			break;
		}
	}
	
	if (foundKeyboard) {
		[self addButtonToKeyboard];
	}
}


-(void)addButtonToKeyboard {
	// create custom button
    
    if (!_addDone) {
        return;
    }
    else
    {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.frame = CGRectMake(0, 163, 106, 53);  //0, 163, 106, 53
        _doneButton.adjustsImageWhenHighlighted = NO;
        [_doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        UIView *keyboard;
        if ([[[UIApplication sharedApplication] windows] count] < 2)
            return;
        UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
        
        
        for(int i=0; i<[tempWindow.subviews count]; i++) {
            keyboard = [tempWindow.subviews objectAtIndex:i];
            // keyboard found, add the button
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) { //4.3
                if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
                    [keyboard addSubview:_doneButton];
            } else {
                if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
                    [keyboard addSubview:_doneButton];
            }
        }
    }
}

- (void)doneButton:(id)sender
{
    [self.view endEditing:YES];
    if (textfieldTag == 600)
    {
        [self setViewMovedUp:YES];
        [_txtSecurityCode becomeFirstResponder];
    }
    else
    {
        [self setViewMovedUp:NO];
        [_txtSecurityCode resignFirstResponder];
    }
  //  [self setViewMovedUp:NO];
}

@end
