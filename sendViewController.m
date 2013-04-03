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
    self.navigationItem.hidesBackButton = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)FBButtonClicked:(id)sender
{
    //check whether session is open
    if (FBSession.activeSession.isOpen)
    {
        [self checkPostingRights];
    }
    else {
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (!error)
            {
                [self checkPostingRights];
            }
            else{
                NSLog(@"could not open new session. error:%@",error.localizedDescription);
            }
        }];
    }
}

-(void)checkPostingRights
{
   if ([FBSession.activeSession.permissions containsObject:@"publish_stream"])
   {
       [self postToFB];
   }
   else {
    
       [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
           if (!error) {
           [self postToFB];
           }
           else {
               NSLog(@"authorizing publish permissions failed. error:%@",error.localizedDescription);
           }
       }];
   }
}

-(void)postToFB
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *messageString = messageTextField.text; 
    
    NSMutableDictionary *postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"", @"link",
     //thumbnail.image, @"source",
     @"pictureURL",@"picture",
     //@"Icon.png",@"picture",
     @"name", @"name",
     messageString, @"caption",
     @" ", @"description",
     nil];
        
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
         
         //[MBProgressHUD hideHUDForView:self.view animated:YES];
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
  
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES; 
}

@end
