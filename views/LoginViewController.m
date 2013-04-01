//
//  LoginViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "FeedViewController.h"
#import "MytabViewController.h"
#import "CheckinViewController.h"
#import "Heres2uViewController.h"

@interface LoginViewController ()

@end


@implementation LoginViewController

@synthesize centerImageName,usrname,pass;

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
    //UIImageView *pic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
    centerImageName = @"logo_small.png";

    
    //[[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]]];
  //  [self.navigationController.navigationItem setTitleView:pic];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
    self.navigationItem.hidesBackButton = YES;
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)goToRegister:(id)sender {
   // registerViewController *menu = [[registerViewController alloc] initWithNibName:@"registerViewController" bundle:nil];
    
  //  [self presentViewController:menu animated:YES completion:NULL];
   // [self.navigationController pushViewController:menu animated:YES];
    RegistrationViewController *Registration=[[RegistrationViewController alloc] init];
    [self presentViewController:Registration animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)login:(id)sender {
    
        
    
    
    
    
//    profNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    mytabNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    checkNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    feedNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    h2uNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
    
    
   
    
//    tab.viewControllers = [NSArray arrayWithObjects:feed,check,h2u,mytab,prof,nil];
     

    
    
    //[self presentViewController:tab animated:NO completion:NULL];
    [NSUserAccessControl Login:usrname.text Password:pass.text Delegate:self];
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
    NSInteger UP=-190+20;
    if([textField.placeholder isEqualToString:@"Password"]){
        //UP=-221+20;
    }
    [UIView animateWithDuration:0.1 animations:^{
        CGRect Current=self.view.frame;
        Current.origin.y=UP;
        [self.view setFrame:Current];
    }];
    //[self sendDimensionsToParentController:newFrame];
    return YES;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch=[touches anyObject];
    if(touch.view != pass &&touch.view != usrname){
        [self dismissKeyboard:Nil];
    }
}
-(IBAction)dismissKeyboard:(UIButton*)sender{
    [usrname resignFirstResponder];
    [pass resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        CGRect Current=self.view.frame;
        Current.origin.y=0;
        [self.view setFrame:Current];
    }];
}


-(void)loggingInFailed:(NSError *)error{ 
    UIAlertView *Alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Invalid Email or Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [Alert show];
}
-(void)loggingInSucceeded:(NSString *)message{
    [NSGlobalConfiguration setConfigurationItem:@"Email" Item:usrname.text];
    [NSGlobalConfiguration setConfigurationItem:@"Password" Item:pass.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
