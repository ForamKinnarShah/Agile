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
    // Do any additional setup after loading the view from its nib.
    NSMutableDictionary *creditCardInfo = [NSGlobalConfiguration getConfigurationItem:@"creditCard"];
    if (creditCardInfo)
    {
//        nameTextField.text = [creditCardInfo objectForKey:@"nameOnCard"]; nameTextField.userInteractionEnabled = NO; 
//        cardNumberTextField.text = [creditCardInfo objectForKey:@"cardNumber"]; cardNumberTextField.userInteractionEnabled = NO; 
//        address1TextField.text = [creditCardInfo objectForKey:@"address1"]; address1TextField.userInteractionEnabled = NO; 
//        address2TextField.text = [creditCardInfo objectForKey:@"address2"]; address2TextField.userInteractionEnabled = NO; 
//        cardTypeTextField.text = [creditCardInfo objectForKey:@"cardType"]; cardTypeTextField.userInteractionEnabled = NO; 
//        securityCodeTextField.text = [creditCardInfo objectForKey:@"securityCode"]; securityCodeTextField.userInteractionEnabled = NO; 
        
    }
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(datePickerPicked) forControlEvents:UIControlEventValueChanged]; 
    [expirationDateTextField setInputView:datePicker];
    UIToolbar *doneBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [doneBar setItems:[NSArray arrayWithObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(textFieldShouldReturn:)]]];
    //[cardNumberTextField setInputAccessoryView:doneBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addCreditCard:(id)sender
{
    for (UITextField *field in [NSArray arrayWithObjects:nameTextField,address1TextField,cardTypeTextField,cardNumberTextField,securityCodeTextField, nil])
    {
        if ([field.text isEqualToString:@""])
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
    

//[[[UIAlertView alloc] initWithTitle:@"credit card added" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    QBMSRequester *qbms = [[QBMSRequester alloc] init];
    [qbms sendAddWalletRequestForCustomerID:[NSGlobalConfiguration getConfigurationItem:@"ID"] CCNumber:cardNumberTextField.text ExpiryDate:datePicker.date];
    qbms.delegate = self; 
    if (!UIBlocker) {
        UIBlocker = [[utilities alloc] init]; 
    }
    [UIBlocker startUIBlockerInView:self.tabBarController.view]; 
    
return;
}

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
}

-(void)datePickerPicked
{
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateFormat:@"MM/yyyy"]; 
    expirationDateTextField.text = [nsdf stringFromDate:datePicker.date];
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
    NSMutableDictionary *creditCardInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:nameTextField.text,address1TextField.text, address2TextField.text, cardTypeTextField.text, [cardNumberTextField.text substringFromIndex:12], nil] forKeys:[NSArray arrayWithObjects:@"nameOnCard",@"address1",@"address2",@"cardType",@"cardNumberLast4Digits", nil]];
    
    NSMutableArray *cards = [NSGlobalConfiguration getConfigurationItem:@"creditCards"];
    if (!cards)
    {
        cards = [NSMutableArray arrayWithCapacity:0]; 
    }
    [cards addObject:creditCardInfo]; 
    [NSGlobalConfiguration setConfigurationItem:@"creditCards" Item:cards];
    
    [NSGlobalConfiguration setConfigurationItem:@"walletID" Item:code];
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

@end
