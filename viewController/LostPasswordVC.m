//
//  LostPasswordVC.m
//  HERES2U
//
//  Created by agilepc-103 on 4/18/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "LostPasswordVC.h"
#import "NSGlobalConfiguration.h"
@interface LostPasswordVC ()

@end

@implementation LostPasswordVC
{}

#pragma mark
#pragma mark view life cycle

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
    UIBlocker = [[utilities alloc] init]; 
    // Do any additional setup after loading the view from its nib.
    // allow user to enter email address
    [_txtEmail becomeFirstResponder];
    // Initialization code
    UIToolbar *NavigationBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [NavigationBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *BackButton=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemAction target:self action:@selector(back)];
    NSArray *TBButtons=[[NSArray alloc] initWithObjects:BackButton, nil];
    [NavigationBar setItems:TBButtons];
    [self.view addSubview:NavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark
# pragma mark button actions

- (IBAction)Submit:(id)sender
{
    //[NSUserAccessControl LostPassword:_txtEmail.text Delegate:self];
    
    NSString *URLString = [[NSString stringWithFormat:@"%@resetpassword.php?Email=%@",[NSGlobalConfiguration URL],_txtEmail.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URLString : %@",URLString);
    NSURL *url = [[NSURL alloc] initWithString:URLString];
    
    [UIBlocker performSelectorOnMainThread:@selector(startUIBlockerInView:) withObject:self.navigationController.view waitUntilDone:NO];
    
    NSString *response = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"response:%@",response);
    [UIBlocker stopUIBlockerInView:self.navigationController.view]; 
    [_txtEmail resignFirstResponder]; 
}

#pragma mark
#pragma mark invoked methods

// invoked from navigation
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
