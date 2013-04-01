//
//  MytabViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "MytabViewController.h"
#import "ProfileViewController.h"
#import "utilities.h" 
#import "orderItemView.h"

@interface MytabViewController ()

@end

@implementation MytabViewController

@synthesize caller, util, receivedItems, sentItems, usedItems;

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
    self.title = @"MyTab";
    // Custom initialization
//    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"dot.png"];
//    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:self.title image:img tag:4];
//    self.tabBarItem = tab;
    // Do any additional setup after loading the view from its nib.
    [segmented addTarget:self
     
                          action:@selector(segmentControlChanged)
     
                forControlEvents:UIControlEventValueChanged];
    
    caller = [[phpCaller alloc] init];
    caller.delegate = self; 
}

-(IBAction)goToProfile:(id)sender {
    ProfileViewController *menu = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    [self.navigationController pushViewController:menu animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonPressed:(id)sender {
    
    //UIActionSheet *choose = [[UIActionSheet alloc] init];
    //choose.title = @"Menu";
    //choose.delegate = self;
    
    if ([segmented selectedSegmentIndex] == 0) {
                
    UIActionSheet *choose = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"USE GIFT", @"Say Thanks!",@"Navigate here", @"File a complaint", nil];
        [choose showInView:self.view];

    }
    
    else if ([segmented selectedSegmentIndex] == 1) {
        UIActionSheet *choose = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"USE GIFT", @"Receipt", @"File a complaint", nil];
        [choose showInView:self.view];

    }
    
    else if ([segmented selectedSegmentIndex] == 2) {
        UIActionSheet *choose = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"USE GIFT", @"Say Thanks!",@"Receipt", @"File a complaint", nil];
        [choose showInView:self.view];

    }
    
//[choose showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

-(void)segmentControlChanged
{
    if ([segmented selectedSegmentIndex] == 0)
    {
        [util startUIBlockerInView:self.view]; 
        [caller invokeWebService:@"ui" forAction:@"getReceivedItems" withParameters:[NSMutableArray arrayWithObject:[NSGlobalConfiguration getConfigurationItem:@"ID"]]]; 
    }
    else if ([segmented selectedSegmentIndex] == 1)
    {
        [util startUIBlockerInView:self.view];
        [caller invokeWebService:@"ui" forAction:@"getSentItems" withParameters:[NSMutableArray arrayWithObject:[NSGlobalConfiguration getConfigurationItem:@"ID"]]];
    }
    if ([segmented selectedSegmentIndex] == 2)
    {
        [util startUIBlockerInView:self.view];
        [caller invokeWebService:@"ui" forAction:@"getUsedItems" withParameters:[NSMutableArray arrayWithObject:[NSGlobalConfiguration getConfigurationItem:@"ID"]]];
    }
}

-(void) phpCallerFailed:(NSError *)error
{
    [utilities showAlertWithTitle:@"loading failed" Message:nil]; 
}

-(void) phpCallerFinished:(NSMutableArray*)returnData
{
    if ([segmented selectedSegmentIndex] == 0)
    {
    receivedItems = returnData;
    }
    if ([receivedItems count] != 0)
    {
        [_defaultBtn setHidden:YES]; 
        [self loadActivitiesWithItems:returnData];
    }
}

-(void) loadActivitiesWithItems:(NSMutableArray*)items{
    //NSLog(@"Loading Activity");
    for(NSInteger i=0; i<[items count];i++){
        orderItemView *item=[[orderItemView alloc] initWithFrame:CGRectMake(0, (i*81), 320, 81)];
        NSDictionary *ItemData=[items objectAtIndex:i];
        item.senderNameBtn.titleLabel.text = [ItemData objectForKey:@"sendUserNameFullName"];
        item.restaurantNameLbl.text = [ItemData objectForKey:@"restaurantName"];
        item.itemNameLbl.text = [NSString stringWithFormat:@"%@ %@",[ItemData objectForKey:@"itemPrice"],[ItemData objectForKey:@"itemName"]]; 
       // NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData valueForKey:@"ImageURL"]] ImageView:friend.picture];
        //[img start];
        [item setDelegate:self];
        [self.view addSubview:item];
        // NSLog(@"added");
    }
    [(UIScrollView *)self.view setScrollEnabled:YES];
    [(UIScrollView *)self.view setContentSize:CGSizeMake(320, ([items count]*85))];
    // NSLog(@"%i",([Profile.Feeds count]*166));
}

@end
