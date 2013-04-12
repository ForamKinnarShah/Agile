//
//  ProfileViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "ProfileViewController.h"
#import "menuViewController.h"
#import "settingsViewController.h"
#import "checkinCommentViewController.h"
#import "utilities.h" 

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize ProfilePicture,FollowButton,FollowersCount,FollowersRect,FollowingCount,btnFollowBack,FollowingRect,ImageLoader,UserName,ProSroll, defaultViewButton, UIBlocker;
//Initializers:
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
                // Custom initialization
    }
    return self;
}
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ProfileID:(NSInteger)ID{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        ProfileID=ID;
       
        
    }
    return self;
}
//Delegates
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"Profile ID:%i",ProfileID);
    Profile=[[NSProfile alloc] initWithProfileID:ProfileID];
    [Profile setDelegate:self];
    [Profile startFetching];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBlocker = [[utilities alloc] init];
    [UIBlocker startUIBlockerInView:self.tabBarController.view];
    
    Profile=[[NSProfile alloc] initWithProfileID:ProfileID];
    [Profile setDelegate:self];
    [Profile startFetching];
    
    
    //    self.title = @"Profile";
//    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"dot.png"];
//    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:self.title image:img tag:5];
//    self.tabBarItem = tab;

    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(goToSettings:)]];
   // NSLog(@"Loaded");
    //Setup Following Taps:
    UITapGestureRecognizer *FollowingTapRect=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FollowingPressed:)];
    [FollowingRect addGestureRecognizer:FollowingTapRect];
    [FollowingRect setUserInteractionEnabled:YES];
    UITapGestureRecognizer *FollowingTapCount=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FollowingPressed:)];
    [FollowingCount addGestureRecognizer:FollowingTapCount];
    [FollowingCount setUserInteractionEnabled:YES];
    UITapGestureRecognizer *FollowersTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FollowersPressed:)];
    [FollowersRect addGestureRecognizer:FollowersTap];
    [FollowersRect setUserInteractionEnabled:YES];
    UITapGestureRecognizer *FollowersTapCount=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FollowersPressed:)];
    [FollowersCount addGestureRecognizer:FollowersTapCount];
    [FollowersCount setUserInteractionEnabled:YES];
    
    
}
-(void) FollowingPressed:(UIGestureRecognizer *)gesture{
    FollowingViewController *Following=[[FollowingViewController alloc] initWithNibName:@"Following" bundle:nil];
    [self.navigationController pushViewController:Following animated:YES];
}
-(void) FollowersPressed:(UIGestureRecognizer *)gesture{
    FollowingViewController *Following=[[FollowingViewController alloc] initWithNibName:@"Followers" bundle:nil];
    [self.navigationController pushViewController:Following animated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goToSettings:(id)sender {
         settingsViewController *settings = [[settingsViewController alloc] initWithNibName:@"settingsViewController" bundle:nil];
         
         [self.navigationController pushViewController:settings animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

-(IBAction)sheet:(id)sender {
    UIActionSheet *choose = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"SHARE", @"Report Inappropriate", nil];
    [choose showInView:self.view];
}
-(void) ProfileLoadingCompleted:(NSProfile *)profile{
    //Parse Data
    if ([Profile.Feeds count] > 0)
    {
        [defaultViewButton removeFromSuperview];
    }
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];
    
    [FollowersCount setText:[NSString stringWithFormat:@"%i",[Profile Followers]]];
  [FollowingCount setText:[NSString stringWithFormat:@"%i",[Profile Following]]];
    [UserName setText:[Profile FullName]];
    if(![profile canFollow]){
        [FollowButton setText:@""];
        [FollowButton setUserInteractionEnabled:NO];
        [btnFollowBack setUserInteractionEnabled:NO];
    }
    NSImageLoaderToImageView *Loader=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[Profile ImageURL]] ImageView:ProfilePicture];
    [Loader setDelegate:self];
    [ImageLoader startAnimating];
    [Loader start];
    [self loadActivities];
}
-(void) loadActivities{
   // NSLog(@"Loading Activity");
    for(NSInteger i=0; i<[Profile.Feeds count];i++){
        UIActivityView *activity=[[UIActivityView alloc] initWithFrame:CGRectMake(0, (i*166), 320, 156)];
        NSDictionary *ItemData=[Profile.Feeds objectAtIndex:i];
        [activity setID:[(NSString *)[ItemData valueForKey:@"FeedID"] integerValue]];
        [activity.UserName setText:[ItemData valueForKey:@"FullName"]];
        [activity.lblComment setText:[ItemData valueForKey:@"UserComment"]];
        [activity.lblLocation setText:[ItemData valueForKey:@"Location"]];
        [activity.lblTime setText:[ItemData valueForKey:@"DateCreated"]];
        [activity.ProfilePicture setImage:[ProfilePicture image]];
        [activity setDelegate:self];
        
        if ([[ItemData valueForKey:@"UserID"] isEqual:[NSGlobalConfiguration getConfigurationItem:@"ID"]])
        {
            [activity.btnBuy removeFromSuperview];
        }
        
        //[activity setFrame:];
        [ProSroll addSubview:activity];
        NSLog(@"added");
    }
    [ProSroll setScrollEnabled:YES];
    [ProSroll setContentSize:CGSizeMake(320, ([Profile.Feeds count]*156))];
    NSLog(@"%i",([Profile.Feeds count]*156));
}
-(void)activityviewRequestComment:(UIActivityView *)activity{
    //Load Comments View Controller and PUsh it with ID
    CommentViewController *comment=[[CommentViewController alloc] initWithNibName:@"UICommentView" bundle:nil ActivityView:activity];
    [self.navigationController pushViewController:comment animated:YES];
}
-(void) ProfileLoadingFailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
-(void)imageviewloaderLoadingCompleted:(NSImageLoaderToImageView *)loader{
    [ImageLoader stopAnimating];
}

@end
