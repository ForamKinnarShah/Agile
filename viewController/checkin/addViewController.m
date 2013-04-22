//
//  addViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "addViewController.h"

@interface addViewController ()

@end

@implementation addViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submitClicked:(id)sender
{
    [(UIScrollView*)self.view setContentSize:self.view.frame.size];
    
    MFMailComposeViewController *mf = [[MFMailComposeViewController alloc] init];
    mf.mailComposeDelegate = self; 
    [mf setSubject:@"Request for new restaurant"];
    NSMutableString *messageBody = [[NSMutableString alloc] init];
    [messageBody appendFormat:@"Name:%@\n",[(UITextField*)collection[0] text]];
    [messageBody appendFormat:@"Type of Business:%@\n",[(UITextField*)collection[1] text]];
    [messageBody appendFormat:@"Address:%@\n",[(UITextField*)collection[2] text]];
    if (![[(UITextField*) collection[3] text] isEqualToString:@""])
    {
        [messageBody appendFormat:@"%@\n",[(UITextField*)collection[3] text]];
    }
    [messageBody appendFormat:@"%@, %@ %@\n",[(UITextField*)collection[4] text],[(UITextField*)collection[5] text],[(UITextField*)collection[6] text]];
    [messageBody appendString:@"----------------------------------------------------\n"]; 
    [mf setToRecipients:[NSArray arrayWithObject:@"support@heres2uapp.com"]];
    [mf setMessageBody:messageBody isHTML:NO];
    if ([MFMailComposeViewController canSendMail]){
    [self presentViewController:mf animated:YES completion:nil]; 
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"cannot send mail" message:@"Please check your mail settings and internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show]; 
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error)
    {
        NSLog(@"error:%@",error);
    }
    
    if (result == MFMailComposeResultSent)
    {
        [self showAlertMessage:@"Message was queued in outbox. Will send if/when connected to email" withTitle:@"Email Sent"];
    }
    else if (result == MFMailComposeErrorCodeSendFailed || result == MFMailComposeResultFailed)
    {
        [self showAlertMessage:@"" withTitle:@"message sending failed"];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        CGRect Current=self.view.frame;
        Current.origin.y=0;
        [self.view setFrame:Current];
    }];
    
    return YES;
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    _activeTextField = textField;
    if (textField == collection[4] || textField == collection[5] || textField == collection[6])
    {
    NSInteger UP=-190+20;
    
    [UIView animateWithDuration:0.1 animations:^{
        CGRect Current=self.view.frame;
        Current.origin.y=UP;
        [self.view setFrame:Current];
    }];
    }
    //[self sendDimensionsToParentController:newFrame];
    return YES;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_activeTextField resignFirstResponder]; 
    }


@end
