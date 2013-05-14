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
    
//    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(btnShare_Click:)];
//    [self.navigationItem setRightBarButtonItem:btnShare];
    
    [lblResName setText:[Checkin.Name text]];
    [lblResDis setText:[Checkin.Distance text]];
    [lblResAddress setText:[Checkin.Location text]];
        
    [lblName setText:[NSGlobalConfiguration getConfigurationItem:@"FullName"]];
    NSLog(@"Checkin.Picture: %@",Checkin.Picture);

    ProfileID = [[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue];
    NSLog(@"%d",ProfileID);
    
    locationId = (int)Checkin.ID;
    NSLog(@"locationId : %d",locationId);
    
    NSString *strUrl = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[NSGlobalConfiguration getConfigurationItem:@"ImageURL"]]];
    NSLog(@"strUrl >> %@",strUrl);

    ImageViewLoading *imgView = [[ImageViewLoading alloc] initWithFrame:CGRectMake(0, 0, 80, 80) ImageUrl:strUrl];
    [UserImage addSubview:imgView];
    
    
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"Name >> %@",lblName);
    NSLog(@"Res address >> %@",lblResAddress);
    
    switchFacebook = [[UISwitch alloc] initWithFrame:CGRectMake(190, 5, 77, 27)];
    switchTwitter = [[UISwitch alloc] initWithFrame:CGRectMake(190, 5, 77, 27)];

    [CommentField becomeFirstResponder];
    
    if(!isiPhone5){
        objToolbar.frame = CGRectMake(0, 160, 320, 44);
        _tblShare.frame = CGRectMake(_tblShare.frame.origin.x, _tblShare.frame.origin.y - 12, _tblShare.frame.size.width, _tblShare.frame.size.height);
    }
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
        
        NSLog(@"fbdate %@",fbdate);
        NSLog(@"todayDate %@",todayDate);
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FB"]);
        if ([todayDate earlierDate:fbdate] && fbdate)
        {
            NSLog(@"YES");
            [switchFacebook setOn:YES];
        }
        else{
            NSLog(@"NO");
            [switchFacebook setOn:NO];
        }
        //For twitter
        BOOL isTwitterLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"twitterLogin"];
        if(!isTwitterLogin){
            [switchTwitter setOn:NO];
        }
        else{
            [switchTwitter setOn:YES];
            
            if(!engine)
            {
                engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
                engine.consumerKey    = TWITTER_CONSUMER_KEY;
                engine.consumerSecret = TWITTER_CONSUMER_SECRET;
                BOOL isAu = [engine isAuthorized];
                
                if (isAu)
                    [switchTwitter setOn:YES];
                else
                    [switchTwitter setOn:NO];
             }
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
    
    
    //WE DO NOT NEED TO REQUIRE A COMMENT - P.S., 5.10.2013
//    if(CommentField.text.length==0){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Please Fill the Text." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//        return;
//    } 
    
    CommentField.text = [CommentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(CommentField.text.length!=0){
        [NSUserInterfaceCommands PostFeed:[(NSString *)[NSGlobalConfiguration getConfigurationItem:@"ID"] integerValue] Comment:[CommentField text] LocationID:[Checkin ID] CallbackDelegate:self];
        [self performSelector:@selector(btnShare_Click:) withObject:nil];
    }
    [CommentField setText:nil];
}
-(void) userinterfaceCommandFailed:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}



-(IBAction)switchValueChanged:(UISwitch*)sender{
    @try {
        if(sender.tag==1){
           
            if([sender isOn])
            {
               [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FB"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FB"]);


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
            else
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FB"];
                [[NSUserDefaults standardUserDefaults] synchronize];
         
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FB"]);

            }
   
//            NSArray *permissions =  [NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access",nil];
//            [_facebook authorize:permissions];
            
        }
        else if(sender.tag==2){
            if([sender isOn])
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TW"];
                [[NSUserDefaults standardUserDefaults] synchronize];

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
                    strTwitterText = [NSString stringWithFormat:@"%@ checked in at %@ via Heres2U app",lblName.text,lblResName.text];//txtvwStatusWithoutAd.text;
                else
                    strTwitterText = [NSString stringWithFormat:@"%@ checked in at %@ via Heres2U app",lblName.text,lblResName.text];//txtvwStatus.text;
                
                if ([strTwitterText length] > 140)
                {
                    UIAlertView *alTWSucceed = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"You can not post this status as it exceeds the limit of 140 characters!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
            else
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TW"];
                [[NSUserDefaults standardUserDefaults] synchronize];
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
            else
            {
                NSLog(@"NO");
            }
            
            
            if(strAccessToken.length>0){
                
                NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
                ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
                [newRequest setPostValue:[NSString stringWithFormat:@"%@ checked in at %@ via Heres2U app",lblName.text,lblResName.text] forKey:@"message"];
                [newRequest setPostValue:@"Heres2U App" forKey:@"name"];
                [newRequest setPostValue:@"Locaiton Name" forKey:@"caption"];
                [newRequest setPostValue:nil forKey:@"description"];
                [newRequest setPostValue:[NSString stringWithFormat:@"http://50.62.148.155:8080/heres2u/sendgift_home.php?receivingUserID=%d&locationID=%d",ProfileID,locationId] forKey:@"link"];
                 
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

- (void)postToWallFinished:(ASIHTTPRequest *)request
{
    //    [self stopLoading];
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *postId = [responseJSON objectForKey:@"id"];
    NSLog(@"Post id is: %@", postId);
            UIAlertView *av = [[UIAlertView alloc]
                           initWithTitle:@"Sucessfully posted to Facebook wall!"
                           message:@"Check out your Facebook to see!"
                           delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
        [av show];
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

#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username
{
    NSLog(@"User name : %@",username);
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"twitterLogin"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"authData"];
    [defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate

- (void) requestSucceeded: (NSString *) requestIdentifier
{
    NSLog(@"Request %@ succeeded", requestIdentifier);
    UIAlertView *alTWSucceed = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Message has been posted successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alTWSucceed show];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error
{
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    NSArray *arrayError = [[NSArray alloc] init];
    arrayError = [[error localizedDescription] componentsSeparatedByString:@"("];
    NSLog(@"Error Code >> %@",[arrayError objectAtIndex:1]);
    
    UIAlertView *alTwitterError;
    if ([[arrayError objectAtIndex:1] isEqualToString:@"HTTP error 403.)"])
    {
        alTwitterError = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"You can't tweet same post again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alTwitterError show];
    }
    else
    {
        alTwitterError = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Oops! Something is going wrong. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alTwitterError show];
    }
}


-(void) userinterfaceCommandSucceeded:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully Checked In." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
   // [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"tabBarController:%@",self.tabBarController); 
    //[[[self.navigationController.viewControllers objectAtIndex:0] tabBarController] setSelectedIndex:0];
    [self.tabBar setSelectedIndex:0]; 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark tableview methods

// datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil)
    {
        Cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [Cell setSelectionStyle:UITableViewCellEditingStyleNone];
   
        if (indexPath.row == 0)
        {
            UILabel *lblfb = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 130, 30)];
            [lblfb setText:@"Post on Facebook"];
            [lblfb setBackgroundColor:[UIColor clearColor]];
            [lblfb setFont:[UIFont boldSystemFontOfSize:13.0]];
            [Cell.contentView addSubview:lblfb];
      
            [switchFacebook addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            switchFacebook.tag = 1;
            [Cell.contentView addSubview:switchFacebook];
        }
        else
        {
            UILabel *lbltw = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 130, 30)];
            [lbltw setText:@"Post on Twitter"];
            [lbltw setBackgroundColor:[UIColor clearColor]];
            [lbltw setFont:[UIFont boldSystemFontOfSize:13.0]];
            [Cell.contentView addSubview:lbltw];
            
            [switchTwitter addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            switchTwitter.tag = 2;
            [Cell.contentView addSubview:switchTwitter];
        }
        
    }
    return Cell;
}


@end
