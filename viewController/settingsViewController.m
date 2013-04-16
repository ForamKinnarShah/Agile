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

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(goToSupport:)]];
    
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
@end
