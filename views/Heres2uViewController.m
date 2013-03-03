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

@interface Heres2uViewController ()

@end

@implementation Heres2uViewController

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
    self.title = @"HERES2U";
    // Custom initialization
    [self.navigationController.navigationBar setBackgroundColor:[UIColor grayColor]];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
    
    [self.navigationItem setRightBarButtonItem:searchBtn];
   
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
-(IBAction)search:(id)sender
{   searchViewController *search = [[searchViewController alloc] initWithNibName:@"searchViewController" bundle:nil];
    
    [self.navigationController pushViewController:search animated:YES];
}

@end
