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
#import "addCreditCardViewController.h"
#import "contactInfoViewController.h"
#import "ProfileViewController.h"

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
    NSString *centerImageName = @"logo_small.png";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)goToSearch:(id)sender {
    searchViewController *menu = [[searchViewController alloc] initWithNibName:@"searchViewController" bundle:nil];
    [self.navigationController pushViewController:menu animated:YES];
}

-(IBAction)logOut:(id)sender
{
    UIAlertView *alLogout = [[UIAlertView alloc] initWithTitle:@"Here's to you" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Log out",@"Cancel", nil];
    [alLogout show];
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

-(void)btnEmail_click
{
    
    
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

#pragma mark
#pragma mark alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0)
    {
        [NSGlobalConfiguration setConfigurationItem:@"Email" Item:nil];
        [NSGlobalConfiguration setConfigurationItem:@"Password" Item:nil];
        [NSGlobalConfiguration setConfigurationItem:@"ID" Item:nil];
        [NSGlobalConfiguration setConfigurationItem:@"FullName" Item:nil];
        [NSGlobalConfiguration setConfigurationItem:@"ImageURL" Item:nil]; 
        [AppDelegate sharedInstance].ProfilePicture_global.image = nil;

        LoginViewController *login=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:login animated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
        [self.tabBarC setSelectedIndex:0];
        
        UINavigationController *firstNav = (UINavigationController *)[[[AppDelegate sharedInstance] tab].viewControllers objectAtIndex:0];
        [firstNav popToRootViewControllerAnimated:YES];
        //    for (__strong UINavigationController *VC in self.tabBarController.viewControllers)
        //    {
        ////        if (![VC.viewControllers[0] isKindOfClass:[ProfileViewController class]])
        ////             {
        //        UIViewController *vcontr = VC.viewControllers[0];
        //             //}
        //    }
        [[NSNotificationCenter defaultCenter] postNotificationName:logOutNotification object:nil];
    }
}

@end
