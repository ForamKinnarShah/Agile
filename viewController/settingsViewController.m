//
//  settingsViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "settingsViewController.h"
#import "searchViewController.h"
#import "LoginViewController.h"
#import "supportViewController.h"
#import "addCreditCardViewController.h"
#import "contactInfoViewController.h"


@interface settingsViewController ()

@end

@implementation settingsViewController

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

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(btnEmail_click)]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goToSupport:(id)sender {
    supportViewController *menu = [[supportViewController alloc] initWithNibName:@"supportViewController" bundle:nil];
    [self.navigationController pushViewController:menu animated:YES];
}

-(IBAction)goToSearch:(id)sender {
    searchViewController *menu = [[searchViewController alloc] initWithNibName:@"searchViewController" bundle:nil];
    [self.navigationController pushViewController:menu animated:YES];
}

-(IBAction)logOut:(id)sender {
    [NSGlobalConfiguration setConfigurationItem:@"Email" Item:nil];
    [NSGlobalConfiguration setConfigurationItem:@"Password" Item:nil];
    [NSGlobalConfiguration setConfigurationItem:@"ID" Item:nil];
    [NSGlobalConfiguration setConfigurationItem:@"FullName" Item:nil];
    
    
    LoginViewController *login=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:login animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
    [self.tabBarC setSelectedIndex:0];
    
}

-(IBAction)goToCreditCardInfoPage:(id)sender
{
    addCreditCardViewController *credit = [[addCreditCardViewController alloc] initWithNibName:@"addCreditCardViewController" bundle:nil];
    credit.creditCards = [NSGlobalConfiguration getConfigurationItem:@"creditCards"];
    if (!credit.creditCards)
    {
        credit.creditCards = [[NSMutableArray alloc] initWithCapacity:0]; 
    }
    [self.navigationController pushViewController:credit animated:YES];
}

-(IBAction)goToContactInfoPage:(id)sender
{
    contactInfoViewController *contact = [[contactInfoViewController alloc] initWithNibName:@"contactInfoViewController" bundle:nil];
    [self.navigationController pushViewController:contact animated:YES]; 
}

-(void)btnEmail_click{
    
    
    MFMailComposeViewController *composer=[[MFMailComposeViewController alloc]init];
    [composer setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail]) {
        [composer setToRecipients:[NSArray arrayWithObjects:@"support@heres2uapp.com", nil]];
        
        [composer setSubject:@"Support Request"];
        
            NSMutableString *messageBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
           
            [messageBody appendString:[NSString stringWithFormat:@"Support Request From User: %@</br> Please fill in the details of your support request or comment</br>----------------------------------------------------</br>",[NSGlobalConfiguration getConfigurationItem:@"FullName"]]];
           
            [messageBody appendString:@"</body></html>"];
            [composer setMessageBody:messageBody isHTML:YES];
        
        [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:composer animated:YES completion:nil];
    }
    else {
        NSLog(@"controller cannot send mail");
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

@end
