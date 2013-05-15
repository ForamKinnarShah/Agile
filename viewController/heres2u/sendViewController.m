//
//  sendViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "sendViewController.h"
#import "MBProgressHUD.h"
#import "GTLPlusConstants.h"

@interface sendViewController ()

@end

static NSString * const kClientId = @"731819402156.apps.googleusercontent.com";

@implementation sendViewController


@synthesize selectedFriends,accountStore;

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
//    [(UIScrollView*)self.view setContentSize:self.view.bounds.size];
    [_tblGreetings setScrollEnabled:NO];
    
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES]; 
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(goBackToHeres2U)]];

    for (UIButton *button in [NSArray arrayWithObjects:fbButton,SMSButton,emailButton,buttonF,buttonT,buttonG, nil])
    {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside]; 
    }

    [_lblGreetings setText:[NSString stringWithFormat:@"You've purchased a gift for %@ via Heres2U.",_strRecieverName]];

    // allocate switch instde tableview
    _switchFacebook = [[UISwitch alloc] initWithFrame:CGRectMake(190, 5, 77, 27)];
    _switchTwitter = [[UISwitch alloc] initWithFrame:CGRectMake(190, 5, 77, 27)];

    // navigation image
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_small.png"]];
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    @try {
        //[CommentField becomeFirstResponder];
        
        //check switch condition
        NSString *strAccessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_access_token"];
        NSString *strFbExpDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_exp_date"];
     //   NSLog(@"strAccessToken : %@,strFbExpDate : %@",strAccessToken,strFbExpDate);
        
        //2013-07-06 09:39:05 +0000
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSDate* fbdate = [df dateFromString:strFbExpDate];
        NSDate *todayDate = [NSDate date];
        
     //   NSLog(@"fbdate %@",fbdate);
     //   NSLog(@"todayDate %@",todayDate);
      //  NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FB"]);
        if ([todayDate earlierDate:fbdate] && fbdate)
        {
       //     NSLog(@"YES");
            [_switchFacebook setOn:YES];
        }
        else{
      //      NSLog(@"NO");
            [_switchFacebook setOn:NO];
        }
        //For twitter
        BOOL isTwitterLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"twitterLogin"];
        if(!isTwitterLogin)
            [_switchTwitter setOn:NO];
        else
        {
            [_switchTwitter setOn:YES];
            
            if(!engine)
            {
                engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
                engine.consumerKey    = TWITTER_CONSUMER_KEY;
                engine.consumerSecret = TWITTER_CONSUMER_SECRET;
                BOOL isAu = [engine isAuthorized];
                
                if (isAu)
                    [_switchTwitter setOn:YES];
                else
                    [_switchTwitter setOn:NO];
            }
        }
    }
    @catch (NSException *exception) {
  //      NSLog(@"exception : %@",exception);
    }
}

-(void)goBackToHeres2U
{
    [self.navigationController popToRootViewControllerAnimated:YES]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)FBButtonClicked:(id)sender
{
    //if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
    if (FBSession.activeSession.isOpen){
        // get friend details & display friend picker
        if (![FBSession.activeSession.permissions containsObject:@"publish_actions"])
        {
            [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObjects:@"publish_actions",@"publish_stream",@"manage_friendlists", nil] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error)
             {
                 if (!error)
                     [self loadFriends];
             }];
        }
    }
    else {
        // No, display the login page.
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if (!error)
                [self loadFriends]; 
           }];
    }
}

-(void)loadFriends
{
    FBFriendPickerViewController *friendPicker = [[FBFriendPickerViewController alloc] init];
    
    // Set up the friend picker to sort and display names the same way as the
    // iOS Address Book does.
    
    // Need to call ABAddressBookCreate in order for the next two calls to do anything.
    ABAddressBookCreate();
    ABPersonSortOrdering sortOrdering = ABPersonGetSortOrdering();
    ABPersonCompositeNameFormat nameFormat = ABPersonGetCompositeNameFormat();
    
    friendPicker.sortOrdering = (sortOrdering == kABPersonSortByFirstName) ? FBFriendSortByFirstName : FBFriendSortByLastName;
    friendPicker.displayOrdering = (nameFormat == kABPersonCompositeNameFormatFirstNameFirst) ? FBFriendDisplayByFirstName : FBFriendDisplayByLastName;
    
    [friendPicker loadData];
    friendPicker.delegate = self;
    
    [friendPicker presentModallyFromViewController:self animated:YES handler:^(FBViewController *sender, BOOL donePressed)
    {
        if (donePressed)
        {
            self.selectedFriends = friendPicker.selection;

            if ([self.selectedFriends count] != 0)
                [self FeedDialog];
            else
            {
                UIAlertView *alSelect = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Please select a friend to be shared with!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alSelect show];
                return;
            }
        }
     
    }];
    
 
    return;
    
}

//-(void)checkPostingRights
//{
//   if ([FBSession.activeSession.permissions containsObject:@"publish_stream"])
//   {
//       [self postToFB];
//   }
//   else {
//    
//       [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
//           if (!error) {
//           [self postToFB];
//           }
//           else {
//               NSLog(@"authorizing publish permissions failed. error:%@",error.localizedDescription);
//           }
//       }];
//   }
//}


-(void)FeedDialog
{
    
    NSDictionary<FBGraphUser> *user =  selectedFriends[0];
    NSString *selectedID = user.id;
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"I bought you a gift at %@ using the Heres2U iPhone app. You should go pick it up!",[self.restaurantInfo objectForKey:@"Title"]],@"message",
     selectedID,@"to",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
       //      NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
             //    NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                  //   NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                //     NSLog(@"%@", msg);
                     // Show the result in an alert
                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:@"OK!"
                                       otherButtonTitles:nil]
                      show];
                 }
             }
         }
     }];
}

-(IBAction)ShareWithFB:(id)sender
{
    //if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
    if (FBSession.activeSession.isOpen){
        // get friend details & display friend picker
        if (![FBSession.activeSession.permissions containsObject:@"publish_actions"])
        {
            [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObjects:@"publish_actions",@"publish_stream",@"manage_friendlists", nil]
                                                       defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
                                                           if (!error)
                                                           {
                                                               [self postTheDamnThing];
                                                           }
                                                           else {
                                                         //      NSLog(@"error:%@",error.localizedDescription);
                                                           }
                                                       }];
        }
    }
    else {
        // No, display the login page.
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if (!error){
                [self postTheDamnThing];
            }
            else {
         //       NSLog(@"error:%@",error.localizedDescription);
            }
        }];
    }
}

-(void)postTheDamnThing
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"www.heres2u.com", @"link",
     //thumbnail.image, @"source",
     @"http://50.62.148.155:8080/heres2u/images/logo.png",@"picture",
     //@"Icon.png",@"picture",
     @"Heres2U!", @"name",
     @"", @"caption",
     @"I'm using the Heres2U iPhone app to send gifts to friends! You should try it out too! ", @"description", nil];
    
    //[HUD show:YES];
    
    [FBRequestConnection
     startWithGraphPath:@"/me/feed"
     parameters:postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText; 
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Succesfully posted to wall!, id: %@",
                          [result objectForKey:@"id"]];
         }
         // Show the result in an alert
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
    
    //                     [[NSNotificationCenter defaultCenter]
    //                      postNotificationName:FBLoginSuccessNotification
    //                      object:session];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker;
{
    if ([friendPicker.selection count] >0)
    {
        self.selectedFriends = friendPicker.selection;
        [self dismissViewControllerAnimated:YES completion:^{
            [self FeedDialog];
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES; 
}

-(IBAction)buttonClicked:(UIButton*)sender
{
    //[sender setSelected:YES];
}

-(IBAction)submitButtonClicked:(id)sender
{
}

-(IBAction)sendWithEmail:(id)sender{
    
    
    MFMailComposeViewController *composer=[[MFMailComposeViewController alloc]init];
    [composer setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail]) {
        //[composer setToRecipients:[NSArray arrayWithObjects:@"support@heres2uapp.com", nil]];
        
        [composer setSubject:@"I just bought you a gift!"];
        
        NSMutableString *messageBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
        
        [messageBody appendString:[NSString stringWithFormat:@"I just bought you a gift at %@ using the Heres2u iPhone app. you should go pick it up!",[self.restaurantInfo objectForKey:@"Title"]]];
        
        [messageBody appendString:@"</body></html>"];
        [composer setMessageBody:messageBody isHTML:YES];
        
        [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:composer animated:YES completion:nil];
    }
    else {
   //     NSLog(@"controller cannot send mail");
    }
}

-(IBAction)postWithTwitter_v2:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        
        
        self.accountStore = [[ACAccountStore alloc] init];
        
        ACAccountType *twitterAccountType = [self.accountStore
                                             
                                             accountTypeWithAccountTypeIdentifier:
                                             
                                             ACAccountTypeIdentifierTwitter];
        
        [self.accountStore
         
         requestAccessToAccountsWithType:twitterAccountType
         
         options:NULL
         
         completion:^(BOOL granted, NSError *error) {
             
             if (granted) {
                 
                 
                 
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                     //  Step 2:  Create a request
                     
                     NSArray *twitterAccounts =
                     
                     [self.accountStore accountsWithAccountType:twitterAccountType];
                     
                     NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                                   
                                   @"/1.1/statuses/update.json"];
                     
                     
                  //  ACAccount *twAccount = [twitterAccounts lastObject];
                     
                     NSDictionary *params = @{@"status" : [NSString stringWithFormat:@"I just gifted a friend at %@ using the Heres2U iPhone app!",[self.restaurantInfo objectForKey:@"Title"]],
                                              
                                              @"trim_user" : @"1",
                                              
                                              };
                     
                     SLRequest *request =
                     
                     [SLRequest requestForServiceType:SLServiceTypeTwitter
                      
                                        requestMethod:SLRequestMethodPOST
                      
                                                  URL:url
                      
                                           parameters:params];
                     
                     
                     
                     //  Attach an account to the request
                     
                     [request setAccount:[twitterAccounts lastObject]];
                     
                     
                     
                     //  Step 3:  Execute the request
                     
                     [request performRequestWithHandler:^(NSData *responseData,
                                                          
                                                          NSHTTPURLResponse *urlResponse,
                                                          
                                                          NSError *error) {
                         
                         if (responseData) {
                             
                             if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                     [self showAlertMessage:@"Link successfully posted to Twitter" withTitle:@"Success"];
                                 });
                         //        NSLog(@"posted?");
                             }
                             
                             else {
                                 
                                 // The server did not respond successfully... were we rate-limited?
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     [self showAlertMessage:@"Please check whether you have recently posted a message for the same video. " withTitle:@"Link not posted"];
                                 });
                                 
                             //    NSLog(@"The response status code is %d", urlResponse.statusCode);
                                 
                             }
                             
                         }
                         
                     }];
                     
                 });
                 
             }
             
             else {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 // Access was not granted, or an error occurred
                 
            //     NSLog(@"%@", [error localizedDescription]);
                 
             }
             
         }];
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES]; 
        [self showAlertMessage:@"Please go to Settings>Twitter and sign into Twitter account for sharing with this button" withTitle:@"Please sign into twitter"];
        
    }
    
}

- (IBAction) shareWithGooglePlus:(id)sender {
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    // You previously set kClientID in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin, // defined in GTLPlusConstants.h
                     nil];
    signIn.delegate = self;
    
    if (![signIn trySilentAuthentication])
    {
        [signIn authenticate];
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    if (error)
    {
      //  NSLog(@"Received error %@ and auth object %@",error, auth);
    }
    else {
        [self realSharing];
    }
}

-(void)realSharing{
 //   NSLog(@"attempting sharing via google+");
    [GPPShare sharedInstance].delegate = self;
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    
    [shareBuilder setTitle:@"Heres2U!" description:[NSString stringWithFormat:@"I just bought someone a gift at %@ using the Heres2U iPhone app!",[self.restaurantInfo objectForKey:@"Title"]] thumbnailURL:[NSURL URLWithString:@"http://50.62.148.155:8080/heres2u/images/logo.png"]];
    [shareBuilder setContentDeepLinkID:[NSString stringWithFormat:@"http://www.google.com"]];
    
    // This line will manually fill out the title, description, and thumbnail of the
    // item you're sharing.
    [shareBuilder open];
}

- (void)finishedSharing: (BOOL)shared {
    if (shared) {
        [self showAlertMessage:@"Shared link on google+!" withTitle:@"successfully shared"];
    //    NSLog(@"User successfully shared!");
    } else {
     //   NSLog(@"User didn't share.");
    }
}

- (void)viewDidUnload {
    [self setLblGreetings:nil];
    [super viewDidUnload];
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
            
            [_switchFacebook addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            _switchFacebook.tag = 1;
            [Cell.contentView addSubview:_switchFacebook];
        }
        else
        {
            UILabel *lbltw = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 130, 30)];
            [lbltw setText:@"Post on Twitter"];
            [lbltw setBackgroundColor:[UIColor clearColor]];
            [lbltw setFont:[UIFont boldSystemFontOfSize:13.0]];
            [Cell.contentView addSubview:lbltw];
            
            [_switchTwitter addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            _switchTwitter.tag = 2;
            [Cell.contentView addSubview:_switchTwitter];
        }
        
    }
    return Cell;
}

#pragma mark
#pragma mark invoked functions

#pragma mark switch value is changed
-(void)switchValueChanged:(UISwitch*)sender
{
    @try
    {
        if(sender.tag==1)
        {
            if([sender isOn])
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FB"];
                [[NSUserDefaults standardUserDefaults] synchronize];
       //         NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FB"]);
                
                NSString *strAccessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_access_token"];
                NSString *strFbExpDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_exp_date"];
          //      NSLog(@"strAccessToken : %@,strFbExpDate : %@",strAccessToken,strFbExpDate);
                
                //2013-07-06 09:39:05 +0000
                NSDateFormatter* df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
                NSDate* fbdate = [df dateFromString:strFbExpDate];
                
                NSDate *todayDate = [NSDate date];
                
                if ([fbdate earlierDate:todayDate])
                {
               //     NSLog(@"fbdate : %@",fbdate);
                //    NSLog(@"todayDate : %@",todayDate);
                //    NSLog(@"YES");
                    return;
                }
                else
                {
                    //   [FBSession set];
                //    NSLog(@"NO");
                }
                
                if (FBSession.activeSession.isOpen)
                {
                    // get friend details & display friend picker
                    if (![FBSession.activeSession.permissions containsObject:@"publish_actions"])
                    {
                        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access", nil] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error)
                        {
                            if (!error)
                            {
                     //           NSLog(@"%@",session.accessToken);
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",session.accessToken] forKey:@"fb_access_token"];
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",session.expirationDate] forKey:@"fb_exp_date"];
                            }
                            else
                                NSLog(@"error:%@",error.localizedDescription);
                        }];
                    }
                }
                else
                {
                    // No, display the login page.
                    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"read_stream",@"publish_stream", nil] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
                    {
                        if (!error)
                        {
                     //       NSLog(@"%@",session.accessToken);
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",session.accessToken] forKey:@"fb_access_token"];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",session.expirationDate] forKey:@"fb_exp_date"];
                        }
                        else
                            NSLog(@"error:%@",error.localizedDescription);
                    }];
                }
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FB"];
                [[NSUserDefaults standardUserDefaults] synchronize];
             //   NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FB"]);
            }
        }
        else if(sender.tag==2)
        {
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
                
                strTwitterText = [NSString stringWithFormat:@"I've purchased a gift for %@ via Heres2U. You can try this too.!",_strRecieverName];
                    
                if ([strTwitterText length] > 140)
                {
                    UIAlertView *alTWSucceed = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"You can not post this status as it exceeds the limit of 140 characters!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alTWSucceed show];
                    return;
                }
                else
                {
                }
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TW"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    @catch (NSException *exception)
    {
    }
}

#pragma mark ASIHTTP delegates for fb
- (void)postToWallFinished:(ASIHTTPRequest *)request
{
    //    [self stopLoading];
  //  NSString *responseString = [request responseString];
    
   // NSMutableDictionary *responseJSON = [responseString JSONValue];
   // NSString *postId = [responseJSON objectForKey:@"id"];
 //   NSLog(@"Post id is: %@", postId);
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
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Post Failed!" message:@"Try Again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[av show];
}

#pragma mark mail composer delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error)
    {
  //      NSLog(@"error:%@",error);
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

# pragma mark message composer delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultFailed)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self showAlertMessage:@"" withTitle:@"message sending is failed"];
        }];
    }
    else if (result == MessageComposeResultCancelled)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else if (result == MessageComposeResultSent)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self showAlertMessage:@"" withTitle:@"message sent"];
        }];
    }
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username
{
 //   NSLog(@"User name : %@",username);
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
  //  NSLog(@"Request %@ succeeded", requestIdentifier);
    UIAlertView *alTWSucceed = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Message has been posted successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alTWSucceed show];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error
{
 //   NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    NSArray *arrayError = [[NSArray alloc] initWithArray:[[error localizedDescription] componentsSeparatedByString:@"("]];
//    arrayError = [[error localizedDescription] componentsSeparatedByString:@"("];
 //   NSLog(@"Error Code >> %@",[arrayError objectAtIndex:1]);
    
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

#pragma mark
#pragma mark button actions

-(IBAction)Share:(id)sender
{
    @try {
        
        BOOL isFaceBookShareOn = [_switchFacebook isOn];
        if(isFaceBookShareOn){
            NSString *strAccessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_access_token"];
            NSString *strFbExpDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_exp_date"];
         //   NSLog(@"strAccessToken : %@,strFbExpDate : %@",strAccessToken,strFbExpDate);
            
            //2013-07-06 09:39:05 +0000
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
            NSDate* fbdate = [df dateFromString:strFbExpDate];
            
            NSDate *todayDate = [NSDate date];
            
            if ([fbdate earlierDate:todayDate]) {
                
           //     NSLog(@"fbdate : %@",fbdate);
            //    NSLog(@"todayDate : %@",todayDate);
            //    NSLog(@"YES");
            }
            else
            {
             //   NSLog(@"NO");
            }
            
            
            if(strAccessToken.length>0){
                
                NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
                ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
                [newRequest setPostValue:[NSString stringWithFormat:@"I've purchased a gift for %@ via Heres2U. You can try this too.!",_strRecieverName] forKey:@"message"];
                [newRequest setPostValue:@"Heres2U App" forKey:@"name"];
                [newRequest setPostValue:@"Greetings!" forKey:@"caption"];
                [newRequest setPostValue:nil forKey:@"description"];
                [newRequest setPostValue:@"http://www.heres2uapp.com" forKey:@"link"];
                
                [newRequest setPostValue:strAccessToken forKey:@"access_token"];
                [newRequest setDidFinishSelector:@selector(postToWallFinished:)];
                [newRequest setDidFailSelector:@selector(postToWallFailed:)];
                
                [newRequest setDelegate:self];
                [newRequest startAsynchronous];
            }
        }
        
        BOOL isTwitterShareOn = [_switchTwitter isOn];
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

-(IBAction)Email:(id)sender
{
    MFMailComposeViewController *composer=[[MFMailComposeViewController alloc]init];
    [composer setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail]) {
     //   [composer setToRecipients:[NSArray arrayWithObjects:@"support@heres2uapp.com", nil]];
        
        [composer setSubject:@"Greetings!"];
        
        NSMutableString *messageBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
        
        [messageBody appendString:[NSString stringWithFormat:@"I've purchased a gift for %@ via Heres2U. You can try this too.!",_strRecieverName]];
        
        [messageBody appendString:@"</body></html>"];
        [composer setMessageBody:messageBody isHTML:YES];
        
        [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:composer animated:YES completion:nil];
    }
    else {
    //    NSLog(@"controller cannot send mail");
    }
}

-(IBAction)sendWithSMS:(id)sender
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *mcvc = [[MFMessageComposeViewController alloc] init];
        [mcvc setBody:[NSString stringWithFormat:@"I've purchased a gift for %@ via Heres2U. You can try this too.!",_strRecieverName]];
        mcvc.messageComposeDelegate = self;
        [self presentViewController:mcvc animated:YES completion:NULL];
    }
    else {
        [self showAlertMessage:@"device cannot currently send text messages" withTitle:@"cannot send text messages"];
    }
}

@end
