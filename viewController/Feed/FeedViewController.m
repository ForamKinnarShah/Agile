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
        [feedManager getFeeds];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    length = 0;
    activityViews = [NSMutableArray arrayWithCapacity:0];
    UIScrollView* scrollview = self.view;
    scrollview.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearView) name:logOutNotification object:nil]; 
    timer=[NSTimer timerWithTimeInterval:5 target:self selector:@selector(checkActivity) userInfo:nil repeats:YES];
    //[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes ];
    self.title = @"Feed";
   // if([NSGlobalConfiguration getConfigurationItem:@"ID"]){
    feedManager=[[NSFeedManager alloc] init];
    [feedManager setDelegate:self];
    //[feedManager getFeeds];
   // }
    [self.navigationController.navigationBar setBackgroundColor:[UIColor grayColor]];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
    [self.navigationItem setRightBarButtonItem:searchBtn];
    
    //login code
    NSString *Email=[NSGlobalConfiguration getConfigurationItem:@"Email"];
    NSString *Password=[NSGlobalConfiguration getConfigurationItem:@"Password"];
    if(!Email || !Password){
        LoginViewController *login=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:login animated:YES completion:nil];
//    }else{
//        //Attempt Login
//        [NSUserAccessControl Login:Email Password:Password Delegate:self];
//        if(!UIBlocker){
//            UIBlocker=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//            [UIBlocker setFrame:[self.tabBarController .view frame]];
//            [UIBlocker setBackgroundColor:[UIColor grayColor]];
//            [UIBlocker setAlpha:0.8];
//            [UIBlocker setHidesWhenStopped:YES];
//            [self.tabBarController.view addSubview:UIBlocker];
//        }
//        [UIBlocker startAnimating];
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

-(IBAction)goToMenu:(UIActivityView*)sender {
    menuViewController *menu = [[menuViewController alloc] initWithNibName:@"menuViewController" bundle:nil];
    menu.userInfo = [NSMutableDictionary dictionaryWithDictionary:[feedManager getFeedAtIndex:sender.tag]];
    menu.restaurantInfo = [NSMutableDictionary dictionaryWithObjects:[[feedManager getFeedAtIndex:sender.tag] objectsForKeys:[NSArray arrayWithObjects:@"locationID",@"Title", nil] notFoundMarker:@"none"] forKeys:[NSArray arrayWithObjects:@"ID",@"Title",nil]];
    menu.followeePicImg = sender.ProfilePicture.image;
    menu.followeeNametxt = sender.UserName.text;
    menu.timeLabelText = sender.lblTime.text;
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



-(void) feedmanagerFailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];
    [alert show];
}
-(void) feedmanagerCompleted:(NSFeedManager *)feedmanager{
    //Load Feeds
    NSLog(@"feed manager loaded");
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];
    length = 0;
    
//    if (![oldFeeds isEqual:feedManager.Feeds])
//    {
    [self loadActivities];
    //}
}

-(void)loggingInFailed:(NSError *)error{
    //Display login controller
    LoginViewController *login=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:login animated:YES completion:nil];
}
-(void) loggingInSucceeded:(NSString *)message{
    // Stop UI Blocked and load feed etc
    //[UIBlocker stopUIBlockerInView:self.tabBarController.view];
}

-(void) loadActivities{
    //NSLog(@"Loading Activity");
    
    if ([feedManager count] == 0)
    {
//        defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 300, 50)];
//        defaultLabel.text = @"You have no feed activity yet. Check-in somewhere or add some friends!";
        defaultButton = [[UIButton alloc] initWithFrame:self.view.frame];
        [defaultButton setTitle:@"You have no feed activity yet. Check-in somewhere or find some friends on the Profile page!" forState:UIControlStateNormal];
        [defaultButton setBackgroundImage:[UIImage imageNamed:@"dot-green.png"] forState:UIControlStateNormal]; 
        [defaultButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping]; 
        [self.view addSubview:defaultButton];
    }
    else{
        [defaultButton removeFromSuperview];
    }
    
    for (UIView *activity in activityViews)
    {
        [activity removeFromSuperview];
    }
    [activityViews removeAllObjects];
    length = 0; 
    
    if (numberOfPostsToLoad > [feedManager count])
    {
        numberOfPostsToLoad = [feedManager count]; 
    }

    for(NSInteger i=0; i<numberOfPostsToLoad;i++){
        
        NSDictionary *ItemData=[feedManager getFeedAtIndex:i];
        UIActivityView *activity; 
        if (![[ItemData objectForKey:@"UserComment"] isEqualToString:@""])
             {
                 activity=[[UIActivityView alloc] initWithFrame:CGRectMake(0, length+10, 320, 156) andView:0];
                 length = length + 156; 
             }
        else {
            activity=[[UIActivityView alloc] initWithFrame:CGRectMake(0, length+10, 320, 128) andView:1];
            length = length + 124;
        }
        NSLog(@"itemData:%@",ItemData);
        
        [activity setID:[(NSString *)[ItemData valueForKey:@"FeedID"] integerValue]];
        [activity.UserName setText:[ItemData valueForKey:@"FullName"]];
        [activity.lblComment setText:[ItemData valueForKey:@"UserComment"]];
        [activity.lblLocation setText:[ItemData valueForKey:@"Title"]];
        activity.commentNumberLabel.text = [ItemData valueForKey:@"nComments"]; 
        [activity setTag:i]; 
        
        NSString *time = [ItemData valueForKey:@"Time"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *timeDate = [format dateFromString:time];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *hour = [cal components:NSHourCalendarUnit fromDate:[NSDate date] toDate:timeDate options:0];
        NSDateComponents *minutes = [cal components:NSMinuteCalendarUnit fromDate:[NSDate date] toDate:timeDate options:0]; 
                
        int offset = [[NSTimeZone localTimeZone] secondsFromGMT];
        //PST is -28800 s, PDT - 25200. This is the timestamp our server gives to check-ins and must be adjusted for other time zones. 
       // NSLog(@"offest:%i",offset);
        NSTimeZone* systemTimeZone = [NSTimeZone systemTimeZone];
        BOOL dstIsOn = [systemTimeZone isDaylightSavingTime];
        int adjustSeconds; 
        if (dstIsOn){
         adjustSeconds = offset + 25200;
        }
        else {
             adjustSeconds = offset + 28800;
        }
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:timeDate];
        NSTimeInterval adjusted = interval - adjustSeconds;
        float minutesDiff = adjusted / 60;
        float hoursDiff = minutesDiff/60;
        float daysDiff = hoursDiff/24;
        float monthsDiff = daysDiff/30;
        
        if (minutesDiff < 1)
        {
            [activity.lblTime setText:@"less than 1 minute ago"];
        }
        else if (minutesDiff > 1 && hoursDiff < 1)
        {
            [activity.lblTime setText:[NSString stringWithFormat:@"%.0f minutes ago",minutesDiff]]; 
        }
        else if (hoursDiff > 1 && daysDiff < 1)
        {
            [activity.lblTime setText:[NSString stringWithFormat:@"%.0f hours ago",hoursDiff]];

        }
        else if (daysDiff >1 && monthsDiff < 1)
        {
            [activity.lblTime setText:[NSString stringWithFormat:@"%.0f days ago",daysDiff]];
            
        }
        else {
            [activity.lblTime setText:[NSString stringWithFormat:@"%.0f months ago",monthsDiff]];
 
        }
        
        //[activity.lblTime setText:[ItemData valueForKey:@"Time"]];
       // [activity.lblTime setText:[NSString stringWithFormat:@"%i",hoursDiff]];

        [activity setDelegate:self];
        [activity setTag:i];
        
        if ([[ItemData valueForKey:@"UserID"] isEqual:[NSGlobalConfiguration getConfigurationItem:@"ID"]])
        {
            [activity.btnBuy removeFromSuperview]; 
        }
        
        NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData valueForKey:@"UserImage"]] ImageView:activity.ProfilePicture];
        [img start];
        
        [self.view addSubview:activity];
        [activityViews addObject:activity]; 
       // NSLog(@"added");
    }
    [(UIScrollView *)self.view setScrollEnabled:YES];
    [(UIScrollView *)self.view setContentSize:CGSizeMake(320, length)];
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];

   // NSLog(@"%i",([Profile.Feeds count]*166));
}
-(void)activityviewRequestComment:(UIActivityView *)activity{
    //Load Comments View Controller and PUsh it with ID
    CommentViewController *comment=[[CommentViewController alloc] initWithNibName:@"UICommentView" bundle:nil ActivityView:activity];
    [self.navigationController pushViewController:comment animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    numberOfPostsToLoad = 15;
    UIScrollView *sv = self.view;
    [sv setContentOffset:CGPointMake(0, 0)]; 
    NSString *Email=[NSGlobalConfiguration getConfigurationItem:@"Email"];
    if (Email){ // means logged in already 
        NSLog(@"feedManagercount:%i",[feedManager count]); 
        if ([feedManager count] == 0) //means we haven't gotten any feeds yet
        {
            UIBlocker = [[utilities alloc] init];
            [UIBlocker startUIBlockerInView:self.tabBarController.view]; 
        }
    [feedManager getFeeds];
    }
}

-(void)clearView
{
    for (UIView *activity in self.view.subviews)
    {
        [activity removeFromSuperview]; 
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.y;
    //NSLog(@"offest:%f length:%f",offset,length);
    if (offset > length *0.8 && (numberOfPostsToLoad < [feedManager count]))
    {
        numberOfPostsToLoad = numberOfPostsToLoad + 15;
        [UIBlocker startUIBlockerInView:self.tabBarController.view];
        [feedManager getFeeds]; 
    }
}
@end
