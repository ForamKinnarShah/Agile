//
//  checkinCommentViewController.m
//  HERES2U
//
//  Created by Paul Amador on 12/16/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "checkinCommentViewController.h"
#import "FeedViewController.h" 

@interface checkinCommentViewController ()

@end

@implementation checkinCommentViewController
@synthesize CommentField,lblName,POSTButton,UserImage;
@synthesize lblResAddress,lblResDis,lblResName;

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
    
    NSString *centerImageName = @"logo_small.png";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
    
    [lblResName setText:[Checkin.Name text]];
    [lblResDis setText:[Checkin.Distance text]];
    [lblResAddress setText:[Checkin.Location text]];
    
    
    
    [lblName setText:[NSGlobalConfiguration getConfigurationItem:@"FullName"]];
    NSLog(@"Checkin.Picture: %@",Checkin.Picture);

    
    ProfileID = [[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue];
    NSLog(@"%d",ProfileID);
    NSString *strUrl = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[NSGlobalConfiguration getConfigurationItem:@"ImageURL"]]];
    NSLog(@"strUrl >> %@",strUrl);

    ImageViewLoading *imgView = [[ImageViewLoading alloc] initWithFrame:CGRectMake(0, 0, 80, 80) ImageUrl:strUrl];
    [UserImage addSubview:imgView];
    
    
    // Do any additional setup after loading the view from its nib.
}



-(void)viewWillAppear:(BOOL)animated{
    @try {
        [CommentField becomeFirstResponder];
    }
    @catch (NSException *exception) {
        NSLog(@"exception : %@",exception);
    }
}

- (IBAction)PostFeed:(id)sender
{
//    if ([CommentField.text length] == 0)
//    {
//        UIAlertView *alPost = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Please provide your comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alPost show];
//        return;
//    }
    [NSUserInterfaceCommands PostFeed:[(NSString *)[NSGlobalConfiguration getConfigurationItem:@"ID"] integerValue] Comment:[CommentField text] LocationID:[Checkin ID] CallbackDelegate:self];
    
}
-(void) userinterfaceCommandFailed:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void) userinterfaceCommandSucceeded:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfully Checked In." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES]; 
    NSLog(@"tabBarController:%@",self.tabBarController); 
    //[[[self.navigationController.viewControllers objectAtIndex:0] tabBarController] setSelectedIndex:0];
    [self.tabBar setSelectedIndex:0]; 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
