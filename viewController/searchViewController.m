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

@implementation searchViewController

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
        if (![FBSession.activeSession.permissions containsObject:@"publish_stream"])
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
    [friendPicker presentModallyFromViewController:self
                                          animated:YES
                                           handler:^(FBViewController *sender, BOOL donePressed) {
                                               if (donePressed) {
                                                   self.selectedFriends = friendPicker.selection;
                                                   [self postToFriends]; 
                                               }
                                           }];
    return;
}

-(void)postToFriends
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Try out Heres2U!",@"name",
                            nil];
    
    for (NSDictionary<FBGraphUser> *user in self.selectedFriends)
    {
        NSLog(@"postPath:%@/feed",user.id); 
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/feed",user.id] parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                NSLog(@"post worked for user:%@",user.id); 
            }
            else {
                NSLog(@"error:%@",error.localizedDescription); 
            }
        }]; 
    }
    
}

-(IBAction)findOnGPlus:(id)sender
{
    
}

-(IBAction)findOnContacts:(id)sender
{
    
}
@end
