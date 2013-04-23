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
#import "utilities.h"
#import "LostPasswordVC.h"

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

-(void)login:(id)sender
{
//    profNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    mytabNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    checkNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    feedNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    h2uNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
    
//    tab.viewControllers = [NSArray arrayWithObjects:feed,check,h2u,mytab,prof,nil];
     
    UIBlocker=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [UIBlocker setFrame:self.presentingViewController.view.frame];
    [UIBlocker setBackgroundColor:[UIColor grayColor]];
    [UIBlocker setAlpha:0.8];
    [UIBlocker setHidesWhenStopped:YES];
    [self.view addSubview:UIBlocker];
    [UIBlocker startAnimating];
    //[self presentViewController:tab animated:NO completion:NULL];
    [NSUserAccessControl Login:usrname.text Password:pass.text Delegate:self];
}

- (IBAction)LostPassword:(id)sender
{
    LostPasswordVC *lpvc = [[LostPasswordVC alloc] initWithNibName:@"LostPasswordVC" bundle:nil];
    [self presentViewController:lpvc animated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == usrname)
        [pass becomeFirstResponder];
    else
    {
        [self dismissKeyboard:nil]; 
        //[textField resignFirstResponder];
        //[UIView animateWithDuration:0.1 animations:^{
        //    CGRect Current=self.view.frame;
        //    Current.origin.y=0;
        //    [self.view setFrame:Current];
        //}];
        //[self performSelector:@selector(login:)];
        [self login:nil]; 
    }
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
-(IBAction)dismissKeyboard:(UIButton*)sender
{
    [usrname resignFirstResponder];
    [pass resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        CGRect Current=self.view.frame;
        Current.origin.y=0;
        [self.view setFrame:Current];
    }];
}

-(void)loggingInFailed:(NSError *)error
{
    UIAlertView *Alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Invalid Email or Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    NSLog(@"error:%@",error.localizedDescription);
    [UIBlocker stopAnimating];
    [Alert show];
}

-(void)loggingInSucceeded:(NSString *)message{
    [NSGlobalConfiguration setConfigurationItem:@"Email" Item:usrname.text];
    [NSGlobalConfiguration setConfigurationItem:@"Password" Item:pass.text];
    [NSGlobalConfiguration setConfigurationItem:@"ID" Item:[AppDelegate sharedInstance].strUserID];
    
    [UIBlocker stopAnimating];
    
    // -----------------------------Push Notification
	
	// Get Bundle Info for Remote Registration (handy if you have more than one app)
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
    NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    // Set the defaults to disabled unless we find otherwise...
    NSString *pushBadge;
    NSString *pushAlert;
    NSString *pushSound;
    
    // Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
    // one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
    // single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
    // true if those two notifications are on.  This is why the code is written this way
    if(rntypes == UIRemoteNotificationTypeBadge)
        pushBadge = @"enabled";
    else if(rntypes == UIRemoteNotificationTypeAlert)
        pushAlert = @"enabled";
    else if(rntypes == UIRemoteNotificationTypeSound)
        pushSound = @"enabled";
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert))
    {
        pushBadge = @"enabled";
        pushAlert = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound))
    {
        pushBadge = @"enabled";
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound))
    {
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound))
    {
        pushBadge = @"enabled";
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
	
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceUuid = dev.uniqueIdentifier;
    NSString *deviceName = dev.name;
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
	
	// Prepare the Device Token for Registration (remove spaces and < >)
    NSString *deviceToken_Push = [[[[[AppDelegate sharedInstance].dataDeviceToken description]
                                    stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                   stringByReplacingOccurrencesOfString:@">" withString:@""]
                                  stringByReplacingOccurrencesOfString: @" " withString: @""];

    //	NSLog(@"deviceToken_Push before >> %@",deviceToken_Push);
	// !!! CHANGE "/apns.php?" TO THE PATH TO WHERE apns.php IS INSTALLED
    // !!! ( MUST START WITH / AND END WITH ? ).
    // !!! SAMPLE: "/path/to/apns.php?"
    NSString *urlString = [@"/APNS.php?"stringByAppendingString:@"task=register"];
	urlString = [urlString stringByAppendingString:@"&appname="];
    urlString = [urlString stringByAppendingString:appName];
    urlString = [urlString stringByAppendingString:@"&appversion="];
    urlString = [urlString stringByAppendingString:appVersion];
    urlString = [urlString stringByAppendingString:@"&deviceuid="];
    urlString = [urlString stringByAppendingString:deviceUuid];
    urlString = [urlString stringByAppendingString:@"&devicetoken="];
    NSLog(@"deviceToken_Push after >> %@",deviceToken_Push);
    urlString = [urlString stringByAppendingString:deviceToken_Push];
    urlString = [urlString stringByAppendingString:@"&devicename="];
    urlString = [urlString stringByAppendingString:deviceName];
    urlString = [urlString stringByAppendingString:@"&devicemodel="];
    urlString = [urlString stringByAppendingString:deviceModel];
    urlString = [urlString stringByAppendingString:@"&deviceversion="];
    urlString = [urlString stringByAppendingString:deviceSystemVersion];
    urlString = [urlString stringByAppendingString:@"&pushbadge="];
    urlString = [urlString stringByAppendingString:pushBadge];
    urlString = [urlString stringByAppendingString:@"&pushalert="];
    urlString = [urlString stringByAppendingString:pushAlert];
    urlString = [urlString stringByAppendingString:@"&pushsound="];
    urlString = [urlString stringByAppendingString:pushSound];
    urlString = [urlString stringByAppendingString:@"&uid="];
    urlString = [urlString stringByAppendingString:[AppDelegate sharedInstance].strUserID];
    
    //    urlString = [urlString stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
    // NSString *hostUrl = @"heres2u.calarg.net";
    
    // NSString *hostUrl = @"74.208.77.106/rts/heres2u/api/";
    
    NSString *hostUrl = @"50.62.148.155:8080/heres2u/api/";
    
    [AppDelegate sharedInstance].url = [[NSURL alloc] initWithScheme:@"http" host:hostUrl path:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[AppDelegate sharedInstance].url];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"Register URL: %@", [AppDelegate sharedInstance].url);
    NSLog(@"Return Data: %@", returnData);
    
    NSString *s=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response String ==-========================================================================================================================================================== %@",s);
    
    //  -----Completion of notification
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
