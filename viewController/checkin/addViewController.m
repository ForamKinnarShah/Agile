//
//  addViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "addViewController.h"

@interface addViewController ()

@end

@implementation addViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submitClicked:(id)sender
{
    MFMailComposeViewController *mf = [[MFMailComposeViewController alloc] init];
    [mf setSubject:@"Request for new restaurant"];
    NSMutableString *messageBody = [[NSMutableString alloc] init];
    
    for (UITextField *field in collection)
    {
        
    }
    //[mf setMessageBody:@" isHTML: ]
}
@end
