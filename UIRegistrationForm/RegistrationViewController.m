//
//  RegistrationViewController.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/24/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "RegistrationViewController.h"
#import "MBProgressHUD.h"
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
-(void) RegistrationButtonPressed
{
    //NSUserAccessControl *RR=[[NSUserAccessControl alloc] init];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    NSString* DOB=[format stringFromDate:[form.DOB date]];
    
    if ([form.Email.text length] == 0 || [form.Password.text length] == 0 || [form.Name.text length] == 0 || [form.Phone.text length] == 0 || [form.ZipCode.text length] == 0)
    {
        UIAlertView *alEmail = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"One or more fields are missing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alEmail show];
        return;
    }
    
    if([self validEmail:form.Email.text])
    {
        for (NSString *field in [NSArray arrayWithObjects:form.Email.text,form.Password.text,form.Phone.text,form.ZipCode.text,form.Name.text, nil]) //should rewrite to include other disallowed entries
        {
            if ([field length] == 0)
            {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"One or more fields not filled in"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                return;
            }
        }
        
    //    NSLog(@"%@",[form.DOB date]);
        // check for the age eligiblity
        int yearDifference = [[NSDate date] timeIntervalSinceDate:[form.DOB date]] / (60.0 * 60.0 * 24.0 * 365.0);
        
        if (yearDifference < 18)
        {
            UIAlertView *alAge = [[UIAlertView alloc] initWithTitle:@"HERES2U" message:@"We're sorry.You're ineligible to register for heres2u account. You must be 18+ years in age." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alAge show];
            [form.Email resignFirstResponder];
            [form.Password resignFirstResponder];
            [form.Name resignFirstResponder];
            [form.Phone resignFirstResponder];
            [form.DOB resignFirstResponder];
            [form.ZipCode resignFirstResponder];
            return;
        }
        
//        // check for the valid zip code
//        if ([form.ZipCode.text length] > 7)
//        {
//            UIAlertView *alZip = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Please enter valid zipcode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alZip show];
//            return;
//        }
//        
//        // check for the valid phone no
//        if ([form.Phone.text length] > 11)
//        {
//            UIAlertView *alZip = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Please enter valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alZip show];
//            return;
//        }
        
        [NSUserAccessControl RegisterUser:[form.Email text]  Password:[form.Password text] ProfilePicture:[form currentProfilePicture] Phone:[form.Phone text] DateOfBirth:DOB Name:[form.Name text] ZipCode:[form.ZipCode text] CallBackDelegate:self];
    }
    else
    {
        UIAlertView *alValidEmail = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Please enter valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alValidEmail show];
        return;
    }
}

-(void) registrationDidBegin:(NSTaggedURLConnection *)connection{
 //   NSLog(@"Registration Began");
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
  //  NSLog(@"Registration Failed! Reason: %@",[error localizedDescription]);
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Retry", nil];
    [alert show];
    [activity removeFromSuperview];
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Retry"]){
        [self RegistrationButtonPressed];
   //     NSLog(@"Retrying");
    }
}
-(void) registrationDidSucceed:(NSString *)message{
  //  NSLog(@"Registration succeeded! Server message:%@", message);
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
  //  NSLog(@"%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
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

-(void)loginWithFacebook:(id)sender
{
//    NSLog(@"%@",FBSession.activeSession);
    
    
    if (FBSession.activeSession.isOpen)
    { //  NSLog(@"FBSession is open, getting user details");
        [self getUserDetails];
    }
    
    else {
        
        
        
       // delegate.session = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"email", nil]];
        
   //     NSLog(@"opening new session");
        [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObject:@"email"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
        
            // [delegate openSession];
            
            //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //            // Do something...
            if (FBSession.activeSession.isOpen)
            {
                [self getUserDetails];
            }
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [MBProgressHUD hideHUDForView:self.view animated:YES];
            //            });
        }];
        
    }
    
    
    
}

-(void)getUserDetails
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    
 //   NSLog(@"getting user details");
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
             
             if (!error) {
           //      NSLog(@"setting username");
                 form.Email.text = [user objectForKey:@"email"];
                 form.Name.text = user.name;
             }
         }];
    }
    else {
     //   NSLog(@"fbsession not open?");
    }
    // });
}

#pragma mark
#pragma mark email validation

-(BOOL)validEmail:(NSString*)emailString
{
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
  //  NSLog(@"%i", regExMatches);
    if (regExMatches == 0)
        return NO;
    else
        return YES;
}


@end
