//
//  CheckinViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "CheckinViewController.h"
#import "addViewController.h"
#import "checkinCommentViewController.h"
#import "menuViewController.h" 
#import "Heres2uViewController.h" 

@interface CheckinViewController ()

@end

@implementation CheckinViewController
@synthesize FilterButton,FilterTextBox,LocationsView;
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
//    self.title = @"Check-in";
//    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"dot.png"];
//    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:self.title image:img tag:2];
//    self.tabBarItem = tab;
    // Custom initialization
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToAdd:)]];
    Locations=[[NSLocationLoader alloc] init];
    [Locations setDelegate:self];
    //[Locations downloadLocations];
    UIBlocker = [[utilities alloc] init];
    [UIBlocker startUIBlockerInView:self.tabBarController.view]; 
}

-(void)viewDidAppear:(BOOL)animated
{
    [Locations downloadLocations]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{ [textField resignFirstResponder];
    NSLog(@"fiterText:%@",FilterTextBox.text); 
    return YES;
}
     
-(IBAction)goToAdd:(id)sender {
         addViewController *add = [[addViewController alloc] initWithNibName:@"addViewController" bundle:nil];
         [self.navigationController pushViewController:add animated:YES];
}

-(IBAction)goToCheckinComment:(id)sender {
    checkinCommentViewController *add = [[checkinCommentViewController alloc] initWithNibName:@"checkinCommentViewController" bundle:nil];
    [self.navigationController pushViewController:add animated:YES];
}
-(void)locationloaderCompleted:(NSLocationLoader *)loader{
    
    [UIBlocker stopUIBlockerInView:self.tabBarController.view]; 
    //Clear Everything in LocationsView
    for(UIView *CurrentView in LocationsView.subviews){
        [CurrentView removeFromSuperview];
    }
    for(NSInteger i=0;i<[Locations count];i++){
        NSDictionary *ItemData=[Locations getLocationAtIndex:i];
        UICheckIns *CheckIn=[[UICheckIns alloc] initWithFrame:CGRectMake(0, (100*i), 0, 0)];
        [CheckIn.Distance setText:@"0.0 m"];
        [CheckIn.Name setText:[ItemData valueForKey:@"Title"]];
        [CheckIn.Location setText:[ItemData valueForKey:@"Address"]];
        [CheckIn setDelegate:self];
        [CheckIn setTag:i];
        
        if (self.presentingViewController)
        {
            CheckIn.checkInLabel.text = @"buy gift here"; 
        }
        
        [CheckIn setID:[(NSString *)[ItemData valueForKey:@"ID"] integerValue]];
        NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData valueForKey:@"Image"]] ImageView:CheckIn.Picture];
        [img start];
        [LocationsView addSubview:CheckIn];
    }
    [LocationsView setContentSize:CGSizeMake(320, ([Locations count]*100))];
    [LocationsView setScrollEnabled:YES];
}
-(void) locationloaderFailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];
    [alert show];
}
-(void)checkinRequested:(UICheckIns *)checkin{
    
   // NSLog(@"checkin requested");
    
    if (self.presentingViewController) //indicates it is being called from heres2u view controller, and should go to menu page next
    {  NSLog(@"isBeingPresented");
        
        //Heres2uViewController *h2u = [self.tabBarController.viewControllers objectAtIndex:2];
        
        [self.delegate setRestaurantInfo:[Locations getLocationAtIndex:checkin.tag]];
        [self dismissViewControllerAnimated:YES completion:^{
            
            NSLog(@"something"); 
            if ([self.delegate respondsToSelector:@selector(loadMenuView)])
            {
                NSLog(@"responds to selector");
                [self.delegate loadMenuView];
            }
        }];
        //menuViewController *menu = [[menuViewController alloc] initWithNibName:@"menuViewController" bundle:nil];
        
    }
    else {
    checkinCommentViewController *add = [[checkinCommentViewController alloc] initWithNibName:@"checkinCommentViewController" bundle:nil Checkin:checkin];
        add.tabBar = self.tabBarController; 
    [self.navigationController pushViewController:add animated:YES]
     ;}
}
@end
