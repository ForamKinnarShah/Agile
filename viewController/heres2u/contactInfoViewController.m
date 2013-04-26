//
//  contactInfoViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 3/26/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "contactInfoViewController.h"
#import "NSGlobalConfiguration.h"

@interface contactInfoViewController ()

@end

@implementation contactInfoViewController

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
    [nameTextField setText:[NSGlobalConfiguration getConfigurationItem:@"FullName"]];
    [emailTextField setText:[NSGlobalConfiguration getConfigurationItem:@"Email"]];
    [phoneTextField setText:[NSGlobalConfiguration getConfigurationItem:@"PhoneNumber"]]; 
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO; 
}
@end
