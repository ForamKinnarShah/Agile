//
//  checkinCommentViewController.m
//  HERES2U
//
//  Created by Paul Amador on 12/16/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "checkinCommentViewController.h"
#import "FeedViewController.h" 

@interface checkinCommentViewController ()

@end

@implementation checkinCommentViewController
@synthesize CommentField,lblName,POSTButton,UserImage;
@synthesize lblResAddress,lblResDis,lblResName;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Checkin:(UICheckIns *)checkin{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        Checkin=checkin;
    }
    return self;
}
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
    
    NSString *centerImageName = @"logo_small.png";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
    
    
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(btnShare_Click:)];
    [self.navigationItem setRightBarButtonItem:btnShare];
    
    
    
    
    [lblResName setText:[Checkin.Name text]];
    [lblResDis setText:[Checkin.Distance text]];
    [lblResAddress setText:[Checkin.Location text]];
    
    
    [lblName setText:[NSGlobalConfiguration getConfigurationItem:@"FullName"]];
    NSLog(@"Checkin.Picture: %@",Checkin.Picture);

    
    ProfileID = [[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue];
    NSLog(@"%d",ProfileID);
    NSString *strUrl = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[NSGlobalConfiguration getConfigurationItem:@"ImageURL"]]];
    NSLog(@"strUrl >> %@",strUrl);

    ImageViewLoading *imgView = [[ImageViewLoading alloc] initWithFrame:CGRectMake(0, 0, 80, 80) ImageUrl:strUrl];
    [UserImage addSubview:imgView];
    
    
    // Do any additional setup after loading the view from its nib.
}



-(void)viewWillAppear:(BOOL)animated{
    @try {
        //[CommentField becomeFirstResponder];
        
        //check switch condition
        NSString *strAccessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_access_token"];
        NSString *strFbExpDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_exp_date"];
        NSLog(@"strAccessToken : %@,strFbExpDate : %@",strAccessToken,strFbExpDate);
        
        //2013-07-06 09:39:05 +0000
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSDate* fbdate = [df dateFromString:strFbExpDate];
        
        NSDate *todayDate = [NSDate date];
        
        if ([fbdate earlierDate:todayDate]) {
            
            NSLog(@"fbdate : %@",fbdate);
            NSLog(@"todayDate : %@",todayDate);
            NSLog(@"YES");
            [switchFacebook setOn:YES];
        }
        else{
            NSLog(@"NO");
            [switchFacebook setOn:NO];
            return;
        }
        //For twitter
        BOOL isTwitterLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"twitterLogin"];
        if(!isTwitterLogin){
            [switchTwitter setOn:NO];
        }
        else{
            [switchTwitter setOn:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception : %@",exception);
    }
}

- (IBAction)PostFeed:(id)sender
{
//    if ([CommentField.text length] == 0)
//    {
//        UIAlertView *alPost = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Please provide your comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alPost show];
//        return;
//    }
    [NSUserInterfaceCommands PostFeed:[(NSString *)[NSGlobalConfiguration getConfigurationItem:@"ID"] integerValue] Comment:[CommentField text] LocationID:[Checkin ID] CallbackDelegate:self];
    
}
-(void) userinterfaceCommandFailed:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}



-(IBAction)switchValueChanged:(UISwitch*)sender{
    @try {
        if(sender.tag==1){
           
            if([sender isOn]){
               
                NSString *strAccessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_access_token"];
                NSString *strFbExpDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_exp_date"];
                NSLog(@"strAccessToken : %@,strFbExpDate : %@",strAccessToken,strFbExpDate);
                
                //2013-07-06 09:39:05 +0000
                NSDateFormatter* df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
                NSDate* fbdate = [df dateFromString:strFbExpDate];
                
                NSDate *todayDate = [NSDate date];
                
                if ([fbdate earlierDate:todayDate]) {
                    
                    NSLog(@"fbdate : %@",fbdate);
                    NSLog(@"todayDate : %@",todayDate);
                    NSLog(@"YES");
                    return;
                }
                else{
                 //   [FBSession set];
                    NSLog(@"NO");
                }
                
                if (FBSession.activeSession.isOpen){
                    // get friend details & display friend picker
                    if (![FBSession.activeSession.permissions containsObject:@"publish_actions"])
                    {
                        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access", nil] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
                           if (!error)
                           {
                               NSLog(@"%@",session.accessToken);
                               [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",session.accessToken] forKey:@"fb_access_token"];
                               [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",session.expirationDate] forKey:@"fb_exp_date"];
                           }
                           else {
                               NSLog(@"error:%@",error.localizedDescription);
                           }
                       }];
                    }
                }
                else {
                    // No, display the login page.
                    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"read_stream",@"publish_stream", nil] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                        
                        if (!error){
                            NSLog(@"%@",session.accessToken);
                           
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",session.accessToken] forKey:@"fb_access_token"];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",session.expirationDate] forKey:@"fb_exp_date"];
                            
                        }
                        else {
                            NSLog(@"error:%@",error.localizedDescription);
                        }
                    }];
                }

                    
            }
            
                
//            NSArray *permissions =  [NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access",nil];
//            [_facebook authorize:permissions];
            
        }
        else if(sender.tag==2){
            if([sender isOn]){
                if(!engine)
                {
                    engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
                    engine.consumerKey    = TWITTER_CONSUMER_KEY;
                    engine.consumerSecret = TWITTER_CONSUMER_SECRET;
                }
                
                if(![engine isAuthorized])
                {
                    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:engine delegate:self];
                    
                    if (controller)
                        [self presentModalViewController:controller animated:YES];
                }
                
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"is_app_upgraded"] isEqualToString:@"UPGRADED"])
                    strTwitterText = @"Test with ad";//txtvwStatusWithoutAd.text;
                else
                    strTwitterText = @"Test with status";//txtvwStatus.text;
                
                if ([strTwitterText length] > 140)
                {
                    UIAlertView *alTWSucceed = [[UIAlertView alloc] initWithTitle:@"Social Status" message:@"You can not post this status as it exceeds the limit of 140 characters!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alTWSucceed show];
                    return;
                }
                else
                {
                    //1212
//                    [self.view addSubview:vwTwitter];
//                    [self AddTwitterWithAnimated];
                    
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSelector:@selector(PostFeed:) withObject:nil];
    return YES;
}


- (IBAction)btnShare_Click:(id)sender {
    @try {
        
        BOOL isFaceBookShareOn = [switchFacebook isOn];
        if(isFaceBookShareOn){
            NSString *strAccessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_access_token"];
            NSString *strFbExpDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_exp_date"];
            NSLog(@"strAccessToken : %@,strFbExpDate : %@",strAccessToken,strFbExpDate);
            
            //2013-07-06 09:39:05 +0000
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
            NSDate* fbdate = [df dateFromString:strFbExpDate];
            
            NSDate *todayDate = [NSDate date];
            
            if ([fbdate earlierDate:todayDate]) {
                
                NSLog(@"fbdate : %@",fbdate);
                NSLog(@"todayDate : %@",todayDate);
                NSLog(@"YES");
            }
            else{
                NSLog(@"NO");
                
                return;
            }  
            
            
            if(strAccessToken.length>0){
                
                NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
                ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
                [newRequest setPostValue:@"Helloo message Test" forKey:@"message"];
                [newRequest setPostValue:@"Hello Test1" forKey:@"name"];
                [newRequest setPostValue:@"HelloCaption Test" forKey:@"caption"];
                [newRequest setPostValue:@"Hellodescription test" forKey:@"description"];
                [newRequest setPostValue:@"http://www.google.co.in" forKey:@"link"];
                 
                [newRequest setPostValue:strAccessToken forKey:@"access_token"];
                [newRequest setDidFinishSelector:@selector(postToWallFinished:)];
                [newRequest setDidFailSelector:@selector(postToWallFailed:)];
                
                [newRequest setDelegate:self];
                [newRequest startAsynchronous];
            }
        }
        
        BOOL isTwitterShareOn = [switchTwitter isOn];
        if(isTwitterShareOn){
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"is_app_upgraded"] isEqualToString:@"UPGRADED"])
                [engine sendUpdate:strTwitterText];
            else
                [engine sendUpdate:strTwitterText];
        }
        
    }
    @catch (NSException *exception) {
        
    }
}

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username{
    @try {
        NSLog(@"User name : %@",username);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"twitterLogin"];
        
    }
    @catch (NSException *exception) {
        
    }
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller{
    @try {
        
    }
    @catch (NSException *exception) {
        
    }
    
}
- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller{
    @try {
        
    }
    @catch (NSException *exception) {
        
    }
    
}
- (void)postToWallFinished:(ASIHTTPRequest *)request
{
    //    [self stopLoading];
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *postId = [responseJSON objectForKey:@"id"];
    NSLog(@"Post id is: %@", postId);
    BOOL isTwitterShareOn = [switchTwitter isOn];
    if(isTwitterShareOn){
        UIAlertView *av = [[UIAlertView alloc]
                           initWithTitle:@"Sucessfully posted to Facebook wall And Twitter!"
                           message:@"Check out your Facebook and Twitter to see!"
                           delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
        [av show];
    }
    else{
        UIAlertView *av = [[UIAlertView alloc]
                           initWithTitle:@"Sucessfully posted to Facebook wall!"
                           message:@"Check out your Facebook to see!"
                           delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
        [av show];
    }
    
}

- (void)postToWallFailed:(ASIHTTPRequest *)request
{    
    UIAlertView *av = [[UIAlertView alloc]
                       initWithTitle:@"Post Failed!"
                       message:@"Try Again."
                       delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil];
	[av show];
    
}


-(void) userinterfaceCommandSucceeded:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully Checked In." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES]; 
    NSLog(@"tabBarController:%@",self.tabBarController); 
    //[[[self.navigationController.viewControllers objectAtIndex:0] tabBarController] setSelectedIndex:0];
    [self.tabBar setSelectedIndex:0]; 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
