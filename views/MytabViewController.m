//
//  MytabViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "MytabViewController.h"
#import "ProfileViewController.h"

@interface MytabViewController ()

@end

@implementation MytabViewController

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

@end
