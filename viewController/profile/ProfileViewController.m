//
//  ProfileViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "ProfileViewController.h"
#import "menuViewController.h"
#import "settingsViewController.h"
#import "checkinCommentViewController.h"
#import "utilities.h" 
#import "NSGlobalConfiguration.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize ProfilePicture,FollowButton,FollowersCount,FollowersRect,FollowingCount,btnFollowBack,FollowingRect,ImageLoader,UserName,ProSroll, defaultViewButton, UIBlocker, SourceSelector;
//Initializers:
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
                // Custom initialization
    }
    return self;
}
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ProfileID:(NSInteger)ID{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        ProfileID=ID;
    }
    return self;
}
//Delegates
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"Profile ID:%i",ProfileID);
    //Profile=[[NSProfile alloc] initWithProfileID:ProfileID];
    [Profile setDelegate:self];
    ProfileID = [[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue];
    Profile.ProfileID = ProfileID; 
    [Profile startFetching];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearView) name:logOutNotification object:nil]; 
    
    UIBlocker = [[utilities alloc] init];
    [UIBlocker startUIBlockerInView:self.tabBarController.view];
    
    ProfileID = [[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue];
    Profile=[[NSProfile alloc] initWithProfileID:ProfileID];
    [Profile setDelegate:self];
    //[Profile startFetching];
    
    
    //    self.title = @"Profile";
//    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"dot.png"];
//    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:self.title image:img tag:5];
//    self.tabBarItem = tab;

    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(goToSettings:)]];
   // NSLog(@"Loaded");
    //Setup Following Taps:
    UITapGestureRecognizer *FollowingTapRect=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FollowingPressed:)];
    [FollowingRect addGestureRecognizer:FollowingTapRect];
    [FollowingRect setUserInteractionEnabled:YES];
    UITapGestureRecognizer *FollowingTapCount=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FollowingPressed:)];
    [FollowingCount addGestureRecognizer:FollowingTapCount];
    [FollowingCount setUserInteractionEnabled:YES];
    UITapGestureRecognizer *FollowersTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FollowersPressed:)];
    [FollowersRect addGestureRecognizer:FollowersTap];
    [FollowersRect setUserInteractionEnabled:YES];
    UITapGestureRecognizer *FollowersTapCount=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FollowersPressed:)];
    [FollowersCount addGestureRecognizer:FollowersTapCount];
    [FollowersCount setUserInteractionEnabled:YES];
    [ProfilePicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)]];
    [ProfilePicture setUserInteractionEnabled:YES]; 
    
    
}
-(void) FollowingPressed:(UIGestureRecognizer *)gesture{
    FollowingViewController *Following=[[FollowingViewController alloc] initWithNibName:@"Following" bundle:nil];
    [self.navigationController pushViewController:Following animated:YES];
}
-(void) FollowersPressed:(UIGestureRecognizer *)gesture{
    FollowingViewController *Following=[[FollowingViewController alloc] initWithNibName:@"Followers" bundle:nil];
    [self.navigationController pushViewController:Following animated:YES];
}
-(IBAction)goToMenu:(id)sender {
    menuViewController *menu = [[menuViewController alloc] initWithNibName:@"menuViewController" bundle:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goToSettings:(id)sender {
         settingsViewController *settings = [[settingsViewController alloc] initWithNibName:@"settingsViewController" bundle:nil];
         [settings setTabBarC:self.tabBarController]; 
         [self.navigationController pushViewController:settings animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

-(IBAction)sheet:(id)sender {
    UIActionSheet *choose = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"SHARE", @"Report Inappropriate", nil];
    [choose showInView:self.view];
}
-(void) ProfileLoadingCompleted:(NSProfile *)profile{
    //Parse Data
    if ([Profile.Feeds count] > 0)
    {
        [defaultViewButton removeFromSuperview];
    }
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];
    
    [FollowersCount setText:[NSString stringWithFormat:@"%i",[Profile Followers]]];
  [FollowingCount setText:[NSString stringWithFormat:@"%i",[Profile Following]]];
    [UserName setText:[Profile FullName]];
    if(![profile canFollow]){
        [FollowButton setText:@""];
        [FollowButton setUserInteractionEnabled:NO];
        [btnFollowBack setUserInteractionEnabled:NO];
    }
    NSImageLoaderToImageView *Loader=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[Profile ImageURL]] ImageView:ProfilePicture];
    [Loader setDelegate:self];
    [ImageLoader startAnimating];
    [Loader start];
    [self loadActivities];
}
-(void) loadActivities{
   // NSLog(@"Loading Activity");
    for(NSInteger i=0; i<[Profile.Feeds count];i++){
        UIActivityView *activity=[[UIActivityView alloc] initWithFrame:CGRectMake(0, (i*166)+120, 320, 156)];
        NSDictionary *ItemData=[Profile.Feeds objectAtIndex:i];
        [activity setID:[(NSString *)[ItemData valueForKey:@"FeedID"] integerValue]];
        [activity.UserName setText:[ItemData valueForKey:@"FullName"]];
        [activity.lblComment setText:[ItemData valueForKey:@"UserComment"]];
        [activity.lblLocation setText:[ItemData valueForKey:@"Location"]];
        [activity.lblTime setText:[ItemData valueForKey:@"DateCreated"]];
        [activity.ProfilePicture setImage:[ProfilePicture image]];
        [activity setDelegate:self];
        [activity setTag:i+1];
        
        if ([[ItemData valueForKey:@"UserID"] isEqual:[NSGlobalConfiguration getConfigurationItem:@"ID"]])
        {
            [activity.btnBuy removeFromSuperview];
        }
        
        //[activity setFrame:];
        [ProSroll addSubview:activity];
        NSLog(@"added");
    }
    [ProSroll setScrollEnabled:YES];
    [ProSroll setContentSize:CGSizeMake(0, ([Profile.Feeds count]*156)+120)];
    NSLog(@"%i",([Profile.Feeds count]*156));
}
-(void)activityviewRequestComment:(UIActivityView *)activity{
    //Load Comments View Controller and PUsh it with ID
    CommentViewController *comment=[[CommentViewController alloc] initWithNibName:@"UICommentView" bundle:nil ActivityView:activity];
    [self.navigationController pushViewController:comment animated:YES];
}
-(void) ProfileLoadingFailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
-(void)imageviewloaderLoadingCompleted:(NSImageLoaderToImageView *)loader{
    [ImageLoader stopAnimating];
}

-(void) selectPhoto:(UIGestureRecognizer *)gesture{
    NSLog(@"select photo"); 
    if(!SourceSelector){
        SourceSelector=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 216)];
        [SourceSelector setBackgroundColor:[UIColor grayColor]];
        //UIButton *CameraButton=[[UIButton alloc] initWithFrame:CGRectMake(12, 12, 296, 44)];
        UIButton *CameraButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [CameraButton setFrame:CGRectMake(12, 12, 296, 44)];
        [CameraButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
        [CameraButton setTitle:@"Take a Photo" forState:UIControlStateNormal];
        [CameraButton setTintColor:[UIColor grayColor]];
        UIButton *GalleryButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];//[[UIButton alloc] initWithFrame:CGRectMake(12, 68, 296, 44)];
        [GalleryButton setFrame:CGRectMake(12, 68, 296, 44)];
        [GalleryButton setTitle:@"Choose from Gallery" forState:UIControlStateNormal];
        [GalleryButton setTintColor:[UIColor grayColor]];
        [GalleryButton addTarget:self action:@selector(selectFromLibrary:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *CancelButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];//[[UIButton alloc] initWithFrame:CGRectMake(12, 80, 296, 44)];
        [CancelButton setFrame:CGRectMake(12, 124, 296, 44)];
        [CancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        //UIToolbar *back=[[UIToolbar alloc] initWithFrame:CancelButton.frame];
        [CancelButton setTintColor:[UIColor grayColor]];
        [CancelButton addTarget:self action:@selector(cancelPhotoSet:) forControlEvents:UIControlEventTouchUpInside];
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [CameraButton setEnabled:NO];
        }
        [SourceSelector addSubview:CameraButton];
        [SourceSelector addSubview:GalleryButton];
        [SourceSelector addSubview:CancelButton];
    }
    CGRect FinalFrame=CGRectMake(0, self.view.frame.size.height-216, 320, 216);
    [self.view addSubview:SourceSelector];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [SourceSelector setFrame:FinalFrame];
    }completion:nil];
    //[self dismissKeyboard:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *PickedImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    ProfilePicture.image=[PickedImage copy];
    if ([picker sourceType]==UIImagePickerControllerSourceTypeCamera) {
        //NSLog(@"Saved Image");
        UIImageWriteToSavedPhotosAlbum(PickedImage, nil, nil, nil);
    }
    CGSize newSize=PickedImage.size;
    if (PickedImage.size.height>PickedImage.size.width) {
        CGFloat Height=620.0;
        CGFloat Width= (620.0*PickedImage.size.width)/PickedImage.size.height;
        newSize.height=Height;
        newSize.width=Width;
    }else{
        CGFloat Width=620.0;
        CGFloat Height=(620.0*PickedImage.size.height)/PickedImage.size.width;
        newSize.width=Width;
        newSize.height=Height;
    }
    UIGraphicsBeginImageContext(newSize);
    [PickedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *ScaledImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [ProfilePicture setImage:ScaledImage];
    [picker dismissModalViewControllerAnimated:YES];
    [self cancelPhotoSet:nil];
}
-(IBAction)takePicture:(id)sender{
    UIImagePickerController *controller=[[UIImagePickerController alloc] init];
    [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
    [controller setShowsCameraControls:YES];
    [controller setDelegate:self];
    [self presentModalViewController:controller animated:YES];
}
-(IBAction)selectFromLibrary:(id)sender{
    NSLog(@"Select picture");
    UIImagePickerController *controller=[[UIImagePickerController alloc] init];
    [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [controller setDelegate:self];
    //[controller setShowsCameraControls:YES];
    [self presentModalViewController:controller animated:YES];
}
-(IBAction)cancelPhotoSet:(id)sender{
    CGRect Final=CGRectMake(0, self.view.frame.size.height, 320, 216);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [SourceSelector setFrame:Final];
    }completion:^(BOOL finished){
        [SourceSelector removeFromSuperview];
    }];
}

-(void)clearView
{
    for (UIActivityView *activity in ProSroll.subviews)
    {
        if (activity.tag)
        {
            [activity removeFromSuperview]; 
        }
    }
}
@end
