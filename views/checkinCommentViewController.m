//
//  checkinCommentViewController.m
//  HERES2U
//
//  Created by Paul Amador on 12/16/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "checkinCommentViewController.h"

@interface checkinCommentViewController ()

@end

@implementation checkinCommentViewController
@synthesize CommentField,lblName,POSTButton,lblTitle,UserImage;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Checkin:(UICheckIns *)checkin{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        Checkin=checkin;
    }
    return self;
}
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
    [lblTitle setText:[Checkin.Location text]];
    [lblName setText:@"Paul Amador"];
    [UserImage setImage:[Checkin.Picture image] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)PostFeed:(id)sender {
    [NSUserInterfaceCommands PostFeed:[(NSString *)[NSGlobalConfiguration getConfigurationItem:@"ID"] integerValue] Comment:[CommentField text] LocationID:[Checkin ID] CallbackDelegate:self];
    
}
-(void) userinterfaceCommandFailed:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void) userinterfaceCommandSucceeded:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully Checked In." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
