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

@synthesize nameTextField, cardNumberTextField, cardTypeTextField, address1TextField, address2TextField, securityCodeTextField, expirationDateTextField, datePicker;

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
    
    arrCardDetail = [[NSMutableArray alloc] initWithObjects:@"Name on Card",@"Expiration Date",@"Billing Address",@"Address Line 2",@"Card Type",@"Card Number",@"security Code", nil];
    _strExpirationDate = @"";
    arrCardType = [[NSMutableArray alloc] initWithObjects:@"visa", @"mastercard", @"amex", nil];
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
    for (NSString *field in textEntries)
    {
        NSLog(@"field:%@",field);
        
        if ([field isEqualToString:@""])
        {
            [[[UIAlertView alloc] initWithTitle:@"one or more fields are missing" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
            return;
        }
    }
    
    if ([cardNumberTextField.text length] != 16)
    {
        [[[UIAlertView alloc] initWithTitle:@"credit card number incorrect" message:@"please check that you entered your number correctly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    QBMSRequester *qbms = [[QBMSRequester alloc] init];
    [qbms sendAddWalletRequestForCustomerID:[NSGlobalConfiguration getConfigurationItem:@"ID"] CCNumber:cardNumberTextField.text ExpiryDate:datePicker.date];
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
    NSLog(@"%@",[nsdf stringFromDate:datePicker.date]);
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
    NSMutableDictionary *creditCardInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:nameTextField.text,address1TextField.text, address2TextField.text, cardTypeTextField.text, [cardNumberTextField.text substringFromIndex:12],code, nil] forKeys:[NSArray arrayWithObjects:@"nameOnCard",@"address1",@"address2",@"cardType",@"cardNumberLast4Digits",@"walletID", nil]];
    
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
    [nameTextField resignFirstResponder];
    datePicker.hidden = YES;
    [expirationDateTextField resignFirstResponder];
    [address1TextField resignFirstResponder];
    [address2TextField resignFirstResponder];
    [cardTypeTextField resignFirstResponder];
    [cardNumberTextField resignFirstResponder];
    [securityCodeTextField resignFirstResponder];
    [self setViewMovedUp:NO];
}

-(IBAction)Done_Picker
{
    // if pickerview for
    if (SELECTED_PICKER)
    {
        pickerCard.hidden = YES;
        doneBar.hidden = YES;
        _strCardType = [arrCardType objectAtIndex:[pickerCard selectedRowInComponent:0]];
        //textEntries[4] = _strCardType;
    }
    else
    {
        datePicker.hidden = YES;
        doneBar.hidden = YES;
        [datePicker addTarget:self action:@selector(datePickerPicked:) forControlEvents:UIControlEventValueChanged];
        _strExpirationDate = [NSString stringWithFormat:@"%@",[nsdf stringFromDate:datePicker.date]];
        //textEntries[1] = _strExpirationDate;
    }
    [_tblCreditCardInfo reloadData];
}

#pragma mark
#pragma mark tableview methods

// datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        _lblCardDetail.tag = 100;
        [Cell.contentView addSubview:_lblCardDetail];
    
        _txtCardDetail = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, 150, 24)];
        [_txtCardDetail setBorderStyle:UITextBorderStyleRoundedRect];
        _txtCardDetail.delegate = self;
        _txtCardDetail.tag = indexPath.row;
        
        _lblexiprationDate = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 150, 24)];
        [_lblexiprationDate setBackgroundColor:[UIColor clearColor]];
        [_lblexiprationDate setTextColor:[UIColor blackColor]];
        [_lblexiprationDate setFont:[UIFont systemFontOfSize:14]];
        _lblexiprationDate.tag = 300;
        
        _lblCardType = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 150, 24)];
        [_lblCardType setBackgroundColor:[UIColor clearColor]];
        [_lblCardType setTextColor:[UIColor blackColor]];
        [_lblCardType setFont:[UIFont systemFontOfSize:14]];
        _lblCardType.tag = 400;
    }
    else
    {
        _lblCardDetail = (UILabel *)[Cell.contentView viewWithTag:100];
        _txtCardDetail = (UITextField *)[Cell.contentView viewWithTag:indexPath.row];
        _lblexiprationDate = (UILabel *)[Cell.contentView viewWithTag:300];
        _lblCardType = (UILabel *)[Cell.contentView viewWithTag:400];
    }
    
    if (indexPath.row == 1)
        [Cell.contentView addSubview:_lblexiprationDate];
    else if(indexPath.row == 4)
        [Cell.contentView addSubview:_lblCardType];
    else
    {
        if(indexPath.row == 5 || indexPath.row == 6)
            [_txtCardDetail setKeyboardType:UIKeyboardTypeNumberPad];

        [Cell.contentView addSubview:_txtCardDetail];
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
    [_txtCardDetail resignFirstResponder];
    
    if (indexPath.row == 1)
    {
        // no, if date picker is selected
        SELECTED_PICKER = NO;
        datePicker.hidden = NO;
        doneBar.hidden = NO;
    }
    else if (indexPath.row == 4)
    {
        // no, if date picker is selected
        SELECTED_PICKER = YES;

        pickerCard.hidden = NO;
        doneBar.hidden = NO;
    }
}

#pragma mark
#pragma mark textfield delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1)
    {
        [textField resignFirstResponder];
        datePicker.hidden = NO;
        textField.inputView = datePicker;
   //     doneBar.hidden = NO;
    }
    else
    {
        [textField becomeFirstResponder];
        datePicker.hidden = YES;
     //   doneBar.hidden = NO;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textEntries[textField.tag] = textField.text; 
    
    switch (textField.tag)
    {
        case 0:
            nameTextField.text = textField.text;
            break;
            
        case 1:
            expirationDateTextField.text = textField.text;
            break;
            
        case 2:
            address2TextField.text = textField.text;
            break;

        case 3:
            cardTypeTextField.text = textField.text;
            break;
            
        case 4:
            cardNumberTextField.text = textField.text;
            break;

        case 5:
            securityCodeTextField.text = textField.text;
            break;
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

@end
