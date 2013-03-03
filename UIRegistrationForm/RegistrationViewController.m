//
//  RegistrationViewController.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/24/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize form;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(void) RegistrationButtonPressed{
    //NSUserAccessControl *RR=[[NSUserAccessControl alloc] init];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    NSString* DOB=[format stringFromDate:[form.DOB date]];
    [NSUserAccessControl RegisterUser:[form.Email text]  Password:[form.Password text] ProfilePicture:[form currentProfilePicture] Phone:[form.Phone text] DateOfBirth:DOB Name:[form.Name text] ZipCode:[form.ZipCode text] CallBackDelegate:self];
}
-(void) registrationDidBegin:(NSTaggedURLConnection *)connection{
    NSLog(@"Registration Began");
    if(!activity){
        activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity setFrame:[UIScreen mainScreen].bounds];
    }
    [activity setBackgroundColor:[UIColor grayColor]];
    [activity setAlpha:0.5];
    [self.view addSubview:activity];
    [activity startAnimating];
}
-(void) registrationDidFail:(NSError *)error{
    NSLog(@"Registration Failed! Reason: %@",[error localizedDescription]);
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Retry", nil];
    [alert show];
    [activity removeFromSuperview];
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Retry"]){
        [self RegistrationButtonPressed];
        NSLog(@"Retrying");
    }
}
-(void) registrationDidSucceed:(NSString *)message{
    NSLog(@"Registration succeeded! Server message:%@", message);
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Congratulations" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert show];
    [activity removeFromSuperview];
    [self dismissModalViewControllerAnimated:YES];
}
-(void) backButtonPressed:(id) sender{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
	// Do any additional setup after loading the view.
    form=[[UIRegistrationForm alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    [form setViewController:self];
    [form.BackButton setTarget:self];
    [form.BackButton setAction:@selector(backButtonPressed:)];
    [form.Register setTarget:self];
    [form.Register setAction:@selector(RegistrationButtonPressed)];
    [self.view addSubview:form];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
