//
//  searchViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "searchViewController.h"

@interface searchViewController ()

@end

#define APP_LINK  @"LINK"

@implementation searchViewController


@synthesize selectedFriends, selectedContacts;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)findOnFB:(id)sender
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

-(void)postToFriends
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Try out Heres2U!",@"name",
                                                                      @"http://www.mylink.com",@"link",
                                                                      @"This is a cool new app I'm trying out. You should try it too!",@"description",
                                                                      @"caption here",@"caption",
                            nil];
    
    for (NSDictionary<FBGraphUser> *user in self.selectedFriends)
    {
        NSLog(@"postPath:%@/feed",user.id); 
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/feed",user.id] parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                NSLog(@"post worked for user:%@",user.id); 
            }
            else {
                NSLog(@"error:%@",error);
            }
        }]; 
    }
    
}

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

-(IBAction)findOnGPlus:(id)sender
{
    
}

-(IBAction)findOnContacts:(id)sender
{
    [self shareWithSMS:self]; 
    
//    ABPeoplePickerNavigationController *abpp = [[ABPeoplePickerNavigationController alloc] init];
//    abpp.peoplePickerDelegate = self; 
//    [self presentViewController:abpp animated:YES completion:nil]; 
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [selectedContacts addObject:(__bridge id)(person)];
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES; 
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)shareWithSMS:(id)sender
{
    if ([MFMessageComposeViewController canSendText])
    {
        
        MFMessageComposeViewController *mcvc = [[MFMessageComposeViewController alloc] init];
        [mcvc setBody:[NSString stringWithFormat:@"Wanna try a fun app? %@",APP_LINK]];
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

- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
@end
