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
#import "AsyncImageView.h"

@interface LoginViewController ()

@end


@implementation LoginViewController

@synthesize centerImageName;

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
    _strusrname = [[NSString alloc] init];
    _strpass = [[NSString alloc] init];
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
    
    
  //  if([_strusrname length] == 0)
        _strusrname = _txtEmail_Login.text;
    
 //   if ([_strpass length] == 0)
        _strpass = _txtPassword.text;
    
//    profNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    mytabNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    checkNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    feedNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    h2uNav.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
    
//    tab.viewControllers = [NSArray arrayWithObjects:feed,check,h2u,mytab,prof,nil];
    
    if ([_strusrname length] == 0)
    {
        UIAlertView *alValidateLogin = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Please insert username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alValidateLogin show];
        return;
    }
    else if([_strpass length] == 0)
    {
        UIAlertView *alValidateLogin = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Please insert password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alValidateLogin show];
        return;
    }
    else
    {
        UIBlocker=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [UIBlocker setFrame:self.presentingViewController.view.frame];
        [UIBlocker setBackgroundColor:[UIColor grayColor]];
        [UIBlocker setAlpha:0.8];
        [UIBlocker setHidesWhenStopped:YES];
        [self.view addSubview:UIBlocker];
        [UIBlocker startAnimating];
        //[self presentViewController:tab animated:NO completion:NULL];
        [NSUserAccessControl Login:_strusrname Password:_strpass Delegate:self];
    }
}

- (IBAction)LostPassword:(id)sender
{
    UIAlertView *alLostPwd = [[UIAlertView alloc] initWithTitle:@"Enter Your Email Id" message:@"TEST SPACE" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
   // NSLog(@"alLostPwd >> %@",NSStringFromCGRect(alLostPwd.frame));
    _txtEmail = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
    [_txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtEmail setBackgroundColor:[UIColor whiteColor]];
    [alLostPwd addSubview:_txtEmail];
    [alLostPwd show];
    
  //  LostPasswordVC *lpvc = [[LostPasswordVC alloc] initWithNibName:@"LostPasswordVC" bundle:nil];
  //  [self presentViewController:lpvc animated:YES completion:nil];
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (textField == usrname)
//        [pass becomeFirstResponder];
//    else
//    {
//        [self dismissKeyboard:nil]; 
//        //[textField resignFirstResponder];
//        //[UIView animateWithDuration:0.1 animations:^{
//        //    CGRect Current=self.view.frame;
//        //    Current.origin.y=0;
//        //    [self.view setFrame:Current];
//        //}];
//        //[self performSelector:@selector(login:)];
//        [self login:nil]; 
//    }
//    return YES;
//}
//-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
//    return YES;
//}
//-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
//    NSInteger UP=-190+20;
//    if([textField.placeholder isEqualToString:@"Password"]){
//        //UP=-221+20;
//    }
//    [UIView animateWithDuration:0.1 animations:^{
//        CGRect Current=self.view.frame;
//        Current.origin.y=UP;
//        [self.view setFrame:Current];
//    }];
//    //[self sendDimensionsToParentController:newFrame];
//    return YES;
//}
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch * touch=[touches anyObject];
//    if(touch.view != pass &&touch.view != usrname){
//        [self dismissKeyboard:Nil];
//    }
//}
//-(IBAction)dismissKeyboard:(UIButton*)sender
//{
//    [usrname resignFirstResponder];
//    [pass resignFirstResponder];
//    [UIView animateWithDuration:0.1 animations:^{
//        CGRect Current=self.view.frame;
//        Current.origin.y=0;
//        [self.view setFrame:Current];
//    }];
//}

-(void)loggingInFailed:(NSError *)error
{
    UIAlertView *Alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    NSLog(@"error:%@",error.localizedDescription);
    [UIBlocker stopAnimating];
    [Alert show];
}

-(void)loggingInSucceeded:(NSString *)message{
    [NSGlobalConfiguration setConfigurationItem:@"Email" Item:_strusrname];
    [NSGlobalConfiguration setConfigurationItem:@"Password" Item:_strpass];
    [NSGlobalConfiguration setConfigurationItem:@"ID" Item:[AppDelegate sharedInstance].strUserID];
    
    [UIBlocker stopAnimating];

 /*  // -----------------------------Push Notification

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
  
    NSLog(@"devicetoken >> %@",[AppDelegate sharedInstance].dataDeviceToken);
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
 */
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark alertview delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if ([_txtEmail.text length] == 0)
        {
            UIAlertView *alValidateLostPassword = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Please provide your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alValidateLostPassword show];
            return;
        }
        else
        {
            NSString *URLString = [[NSString stringWithFormat:@"%@resetpassword.php?Email=%@",[NSGlobalConfiguration URL],_txtEmail.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"URLString : %@",URLString);
            NSURL *url = [[NSURL alloc] initWithString:URLString];
            
            UIBlocker = [[utilities alloc] init];
            rawData = [NSMutableData dataWithCapacity:0];
            
            UIBlocker=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [UIBlocker setFrame:self.presentingViewController.view.frame];
            [UIBlocker setBackgroundColor:[UIColor grayColor]];
            [UIBlocker setAlpha:0.8];
            [UIBlocker setHidesWhenStopped:YES];
            [self.view addSubview:UIBlocker];
            [UIBlocker startAnimating];
            
            //NSString *response = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            //NSLog(@"response:%@",response);
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
            
            [_txtEmail resignFirstResponder];
        }
    }
}

#pragma mark
#pragma mark NSURLConnection delegates

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [rawData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"Was not able to get a response from mail server. Please check your internet connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [UIBlocker stopAnimating];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //XML PARSER:
    NSString *response = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
    NSLog(@"connection finished loading with response:%@",[[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding]);
    if ([response rangeOfString:@"<SuccessMessage>1</SuccessMessage>"].location == NSNotFound)
    {
        [[[UIAlertView alloc] initWithTitle:@"Message Failed to Send" message:@"Your message was not sent. Please confirm your email address and try again. If problems persist, please contact support.heres2uapp.com" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Message Sent" message:@"Please check your email in order to reset your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    [UIBlocker stopAnimating];
    
    //NSXMLParser *parser=[[NSXMLParser alloc] initWithData:rawData];
    //[parser setDelegate:self];
    //[parser parse];
}

#pragma mark
#pragma mark tableview methods

// datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil)
    {
        Cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [Cell setSelectionStyle:UITableViewCellEditingStyleNone];
    
        _txtEmail_Login = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 260, 40)];
        [_txtEmail_Login setKeyboardType:UIKeyboardTypeEmailAddress];
        [_txtEmail_Login setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_txtEmail_Login setAutocorrectionType:UITextAutocorrectionTypeNo]; 
        _txtEmail_Login.delegate = self;
        _txtEmail_Login.placeholder = @"Email";
        [_txtEmail_Login setReturnKeyType:UIReturnKeyNext];
        _txtEmail_Login.tag = 100;
    
        _txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 260, 40)];
        [_txtPassword setSecureTextEntry:YES];
        _txtPassword.delegate = self;
        [_txtPassword setReturnKeyType:UIReturnKeyGo];
        _txtPassword.placeholder = @"Password";
        _txtPassword.tag = 200;
    }
    else
    {
        _txtEmail_Login = (UITextField *)[Cell.contentView viewWithTag:100];
        _txtPassword = (UITextField *)[Cell.contentView viewWithTag:200];
    }

    if(indexPath.row == 0)
        [Cell.contentView addSubview:_txtEmail_Login];
    if (indexPath.row == 1)
        [Cell.contentView addSubview:_txtPassword];

    return Cell;
}

#pragma mark
#pragma mark textfield delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!isiPhone5)
        [self setViewMovedUp:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 100)
    {
        _strusrname = _txtEmail_Login.text;
        [_txtPassword becomeFirstResponder];
    }
    else
    {
        _strpass = _txtPassword.text;
        [_txtPassword resignFirstResponder];
        //[self performSelector:@selector(login:)];
        [self login:nil];
    }
    if (!isiPhone5)
        [self setViewMovedUp:NO];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 100:
             _txtEmail_Login.text = textField.text;
            break;
            
        case 200:
            _txtPassword.text = textField.text;
            break;
            
    }
    return YES;
}

#pragma  mark
#pragma mark invoked functions

- (void)setViewMovedUp:(BOOL)movedUp
{
    CGRect rect = self.view.frame;
    if (movedUp){
        if(rect.origin.y == 20)
            rect.origin.y = self.view.frame.origin.y - 105;
    }
    else{
        if(rect.origin.y < 20)
            rect.origin.y = self.view.frame.origin.y + 105;
    }
    self.view.frame = rect;
}

@end
