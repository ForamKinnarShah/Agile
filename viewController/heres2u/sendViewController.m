//
//  sendViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "sendViewController.h"

@interface sendViewController ()

@end

@implementation sendViewController

@synthesize selectedFriends;

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
     @"Heres2U iPhone App", @"name",
     @"Tagline here.", @"caption",
     @"Description here.", @"description",
     @"http://www.myapp.com", @"link",
     @"http://www.image-link-here.com", @"picture",
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
    [sender setSelected:YES]; 
}

-(IBAction)submitButtonClicked:(id)sender
{
    NSString *message = messageTextField.text;
}
@end
