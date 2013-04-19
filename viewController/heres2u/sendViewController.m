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
                                                               [self postToFB];
                                                           }
                                                           else {
                                                               NSLog(@"error:%@",error);
                                                           }
                                                       }];
        }
    }
    else {
        // No, display the login page.
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if (!error){
                [self postToFB];
            }
            else {
                NSLog(@"error:%@",error); 
            }
        }];
    }
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

-(void)postToFB
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *messageString = messageTextField.text; 
    
    NSMutableDictionary *postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"http://www.link.com", @"link",
     //thumbnail.image, @"source",
     //@"pictureURL",@"picture",
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
             NSLog(@"error:%@",error); 
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

-(void)feedDialog
{
    
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
