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
    [(UIScrollView*)self.view setContentSize:self.view.bounds.size];

    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES]; 
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(goBackToHeres2U)]];

    for (UIButton *button in [NSArray arrayWithObjects:fbButton,SMSButton,emailButton,buttonF,buttonT,buttonG, nil])
    {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside]; 
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
            [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObjects:@"publish_actions",@"publish_stream",@"manage_friendlists", nil]
                                                       defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
                                                           if (!error)
                                                           {
                                                               [self loadFriends];
                                                           }
                                                           else {
                                                               NSLog(@"error:%@",error.localizedDescription);
                                                           }
                                                       }];
        }
    }
    else {
        // No, display the login page.
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if (!error){
                [self loadFriends]; 
            }
            else {
                NSLog(@"error:%@",error.localizedDescription); 
            }
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
    [friendPicker presentModallyFromViewController:self
                                          animated:YES
                                           handler:^(FBViewController *sender, BOOL donePressed) {
                                               
                                               if (donePressed) {
                                                   self.selectedFriends = friendPicker.selection;
                                                   [self FeedDialog];
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
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                     NSLog(@"%@", msg);
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
                                                               NSLog(@"error:%@",error.localizedDescription);
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
                NSLog(@"error:%@",error.localizedDescription);
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

-(IBAction)sendWithSMS:(id)sender
{
    if ([MFMessageComposeViewController canSendText])
    {
        
        MFMessageComposeViewController *mcvc = [[MFMessageComposeViewController alloc] init];
        [mcvc setBody:[NSString stringWithFormat:@"I just bought you a gift at %@ using the Heres2u iPhone app. you should go pick it up!",[self.restaurantInfo objectForKey:@"Title"]]];
        mcvc.messageComposeDelegate = self;
        [self presentViewController:mcvc animated:YES completion:NULL];
    }
    else {
        [self showAlertMessage:@"device cannot currently send text messages" withTitle:@"cannot send text messages"];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultFailed)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self showAlertMessage:@"" withTitle:@"message send failure"];
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
        NSLog(@"controller cannot send mail");
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error)
    {
        NSLog(@"error:%@",error);
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
                     
                     
                     ACAccount *twAccount = [twitterAccounts lastObject];
                     
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
                                 NSLog(@"posted?");
                             }
                             
                             else {
                                 
                                 // The server did not respond successfully... were we rate-limited?
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     [self showAlertMessage:@"Please check whether you have recently posted a message for the same video. " withTitle:@"Link not posted"];
                                 });
                                 
                                 NSLog(@"The response status code is %d", urlResponse.statusCode);
                                 
                             }
                             
                         }
                         
                     }];
                     
                 });
                 
             }
             
             else {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 // Access was not granted, or an error occurred
                 
                 NSLog(@"%@", [error localizedDescription]);
                 
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
        NSLog(@"Received error %@ and auth object %@",error, auth);
    }
    else {
        [self realSharing];
    }
}

-(void)realSharing{
    NSLog(@"attempting sharing via google+");
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
        NSLog(@"User successfully shared!");
    } else {
        NSLog(@"User didn't share.");
    }
}

@end
