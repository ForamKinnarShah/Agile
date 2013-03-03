//
//  FeedViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "FeedViewController.h"
#import "searchViewController.h"
#import "menuViewController.h"
#import "ProfileViewController.h"
#import "checkinCommentViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}
-(void) checkActivity{
    if([NSGlobalConfiguration getConfigurationItem:@"ID"]){
       // [feedManager ]
        [feedManager getFeeds];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    timer=[NSTimer timerWithTimeInterval:5 target:self selector:@selector(checkActivity) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes ];
    self.title = @"Feed";
   // if([NSGlobalConfiguration getConfigurationItem:@"ID"]){
    feedManager=[[NSFeedManager alloc] init];
    [feedManager setDelegate:self];
    [feedManager getFeeds];
   // }
    [self.navigationController.navigationBar setBackgroundColor:[UIColor grayColor]];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
    [self.navigationItem setRightBarButtonItem:searchBtn];
    NSString *Email=[NSGlobalConfiguration getConfigurationItem:@"Email"];
    NSString *Password=[NSGlobalConfiguration getConfigurationItem:@"Password"];
    if(!Email || !Password){
        LoginViewController *login=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        //Attempt Login
        [NSUserAccessControl Login:Email Password:Password Delegate:self];
        if(!UIBlocker){
            UIBlocker=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [UIBlocker setFrame:[self.tabBarController .view frame]];
            [UIBlocker setBackgroundColor:[UIColor grayColor]];
            [UIBlocker setAlpha:0.8];
            [UIBlocker setHidesWhenStopped:YES];
            [self.tabBarController.view addSubview:UIBlocker];
        }
        [UIBlocker startAnimating];
    }
    // Custom initialization
//    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"dot.png"];
//    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:self.title image:img tag:1];
//    self.tabBarItem = tab;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goToMenu:(id)sender {
    menuViewController *menu = [[menuViewController alloc] initWithNibName:@"menuViewController" bundle:nil];
    [self.navigationController pushViewController:menu animated:YES];
}

-(IBAction)goToProfile:(id)sender {
    ProfileViewController *menu = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    [self.navigationController pushViewController:menu animated:YES];
}

-(IBAction)goToCheckinComment:(id)sender {
    checkinCommentViewController *menu = [[checkinCommentViewController alloc] initWithNibName:@"checkinCommentViewController" bundle:nil];
    [self.navigationController pushViewController:menu animated:YES];
}

-(IBAction)search:(id)sender
{   searchViewController *search = [[searchViewController alloc] initWithNibName:@"searchViewController" bundle:nil];
    
    [self.navigationController pushViewController:search animated:YES]; 
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}
-(void) feedmanagerFailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
    [alert show];
}
-(void) feedmanagerCompleted:(NSFeedManager *)feedmanager{
    //Load Feeds
    NSLog(@"Loaded");
    [self loadActivities];
}
-(IBAction)sheet:(id)sender {
UIActionSheet *choose = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"SHARE", @"Report Inappropriate", nil];
[choose showInView:self.view];
}
-(void)loggingInFailed:(NSError *)error{
    //Display login controller
    LoginViewController *login=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:login animated:YES completion:nil];
}
-(void) loggingInSucceeded:(NSString *)message{
    // Stop UI Blocked and load feed etc
    [UIBlocker stopAnimating];
}

-(void) loadActivities{
    //NSLog(@"Loading Activity");
    for(NSInteger i=0; i<[feedManager count];i++){
        UIActivityView *activity=[[UIActivityView alloc] initWithFrame:CGRectMake(0, (i*166), 320, 156)];
        NSDictionary *ItemData=[feedManager getFeedAtIndex:i];
         [activity setID:[(NSString *)[ItemData valueForKey:@"FeedID"] integerValue]];
        [activity.UserName setText:[ItemData valueForKey:@"FullName"]];
        [activity.lblComment setText:[ItemData valueForKey:@"UserComment"]];
        [activity.lblLocation setText:[ItemData valueForKey:@"Title"]];
        [activity.lblTime setText:[ItemData valueForKey:@"Time"]];
        [activity setDelegate:self];
      //  [activity.ProfilePicture setImage:[ProfilePicture image]];
        //[activity setFrame:];
        [self.view addSubview:activity];
       // NSLog(@"added");
    }
    [(UIScrollView *)self.view setScrollEnabled:YES];
    [(UIScrollView *)self.view setContentSize:CGSizeMake(320, ([feedManager count]*156))];
   // NSLog(@"%i",([Profile.Feeds count]*166));
}
-(void)activityviewRequestComment:(UIActivityView *)activity{
    //Load Comments View Controller and PUsh it with ID
    CommentViewController *comment=[[CommentViewController alloc] initWithNibName:@"UICommentView" bundle:nil ActivityView:activity];
    [self.navigationController pushViewController:comment animated:YES];
}
@end
