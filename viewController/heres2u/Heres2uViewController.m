//
//  Heres2uViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "Heres2uViewController.h"
#import "menuViewController.h"
#import "searchViewController.h" 
#import "NSGlobalConfiguration.h"
#import "heres2uitemView.h"
#import "NSImageLoaderToImageView.h"
#import "CheckinViewController.h" 

@interface Heres2uViewController ()

@end

@implementation Heres2uViewController

@synthesize friendItems, UIBlocker,selectedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearView) name:logOutNotification object:nil];
    
    self.title = @"HERES2U";
    // Custom initialization
    [self.navigationController.navigationBar setBackgroundColor:[UIColor grayColor]];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
    
    [self.navigationItem setRightBarButtonItem:searchBtn];
    
    phpCaller *caller = [[phpCaller alloc] init];
    caller.delegate = self;
    UIBlocker=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [UIBlocker setFrame:[self.tabBarController .view frame]];
    [UIBlocker setBackgroundColor:[UIColor grayColor]];
    [UIBlocker setAlpha:0.8];
    [UIBlocker setHidesWhenStopped:YES];
    [self.tabBarController.view addSubview:UIBlocker];
    [UIBlocker startAnimating];
    [caller invokeWebService:@"ui" forAction:@"getfollowees" withParameters:[NSArray arrayWithObjects:[NSGlobalConfiguration getConfigurationItem:@"ID"], nil]];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//heres2uitemdelegate
-(void)giftAFriend:(heres2uitemView*)sender {
    
    //select Restaurant 
    CheckinViewController *checkin = [[CheckinViewController alloc] initWithNibName:@"CheckinViewController" bundle:nil];
    NSString *centerImageName = @"logo_small.png";
    checkin.navigationController.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];

    checkin.delegate = self;
    selectedImage = sender.picture.image;
    
   // [self.navigationController pushViewController:checkin animated:YES];
    [self presentViewController:checkin animated:NO completion:NULL];
    [[[UIAlertView alloc] initWithTitle:@"Select Restaurant" message:@"Please choose a restaurant at which to buy your gift!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
    _senderNumber = sender.tag; 
//    menuViewController *menu = [[menuViewController alloc] initWithNibName:@"menuViewController" bundle:nil];
//
//    NSLog(@"%@: name:%@",sender,sender.name.text);
//    
//    menu.followeeNametxt = sender.name.text;
//    menu.followeePicImg = sender.picture.image;
//    
//    menu.userInfo = [friendItems objectAtIndex:sender.tag]; 
////    menu.followeeName.text = sender.name.text;
////    menu.followeePic.image = sender.picture.image;
//    
//    [self.navigationController pushViewController:menu animated:YES];
    
}

-(void)loadMenuView
{
    NSLog(@"loading menu"); 
        menuViewController *menu = [[menuViewController alloc] initWithNibName:@"menuViewController" bundle:nil];
    //
    //    NSLog(@"%@: name:%@",sender,sender.name.text);
    //
    //    menu.followeeNametxt = sender.name.text;
    //    menu.followeePicImg = sender.picture.image;
    //
        menu.userInfo = [friendItems objectAtIndex:_senderNumber];
    menu.restaurantInfo = self.restaurantInfo; 
    ////    menu.followeeName.text = sender.name.text;
    menu.followeePicImg = selectedImage; 
    //
        [self.navigationController pushViewController:menu animated:YES];
  
}

-(IBAction)search:(id)sender
{   searchViewController *search = [[searchViewController alloc] initWithNibName:@"searchViewController" bundle:nil];
    
    [self.navigationController pushViewController:search animated:YES];
}

-(void) phpCallerFailed:(NSError *)error;
{
    NSLog(@"php caller failed with error:%@",error.localizedDescription); 
}

-(void) phpCallerFinished:(NSMutableArray *)returnData
{
    if ([friendItems count] != [returnData count])
    {
    friendItems = returnData;
    NSLog(@"php caller finished with items:%@",returnData);
    [self loadActivities];
    }
    [UIBlocker stopAnimating];
}

-(void) viewDidAppear:(BOOL)animated
{
    phpCaller *caller = [[phpCaller alloc] init];
    caller.delegate = self;
    [caller invokeWebService:@"ui" forAction:@"getfollowees" withParameters:[NSArray arrayWithObjects:[NSGlobalConfiguration getConfigurationItem:@"ID"], nil]];
}

-(void) loadActivities{
    //NSLog(@"Loading Activity");
    if ([friendItems count] == 0)
    {
        UILabel *dummyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x-100, self.view.center.y, 200, 50)];
        dummyLabel.text = @"no followees yet. Get some friends!";
        [self.view addSubview:dummyLabel]; 
        return; 
    }
    else {
        
    for(NSInteger i=0; i<[friendItems count];i++){
        heres2uitemView *friend=[[heres2uitemView alloc] initWithFrame:CGRectMake(5, (i*81), 320, 81)];
        NSDictionary *ItemData=[friendItems objectAtIndex:i];
        friend.name.text = [ItemData objectForKey:@"FullName"];
        friend.tag = i;
        //friend.picture.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[ItemData objectForKey:@"ImageName"]]];
        NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData valueForKey:@"ImageURL"]] ImageView:friend.picture];
        [img start];

        [friend setDelegate:self];
        //  [activity.ProfilePicture setImage:[ProfilePicture image]];
        //[activity setFrame:];
        [self.view addSubview:friend];
        // NSLog(@"added");
    }
    [(UIScrollView *)self.view setScrollEnabled:YES];
    [(UIScrollView *)self.view setContentSize:CGSizeMake(320, ([friendItems count]*85))];
    // NSLog(@"%i",([Profile.Feeds count]*166));
    }
}

-(void)clearView
{
    for (UIView *friend in self.view.subviews)
    {
        [friend removeFromSuperview]; 
    }
}
@end
