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
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "AsyncImageView.h"
#import "UIImageView+WebCache.h"
#import "XMLReader.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize FollowButton,FollowersCount,FollowersRect,FollowingCount,btnFollowBack,FollowingRect,ImageLoader,UserName,ProSroll, UIBlocker, SourceSelector;
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

    // Set the Profile Image
    NSString *strUrl = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[NSGlobalConfiguration getConfigurationItem:@"ImageURL"]]];
    _urlImg = [[NSURL alloc] initWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //[_ProfilePicture setImageWithURL:_urlImg placeholderImage:[UIImage imageNamed:@""]];
    NSLog(@"Profile Pic >> %@",_ProfilePicture.image);
    // ----------

    numberOfFeedsToLoad = 15;
    // get profileid
    Profile=[[NSProfile alloc] initWithProfileID:ProfileID];
    [Profile setDelegate:self];
    //[NSGlobalConfiguration setConfigurationItem:@"ID" Item:[NSString stringWithFormat:@"%i",ProfileID]];

    if (!Profile.ProfileID)
    {
    ProfileID = [[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue];
    Profile.ProfileID = ProfileID;
    }
    [Profile startFetching];
    
    feedManager=[[NSFeedManager alloc] init];
    [feedManager setDelegate:self];
    [feedManager getFeeds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearView) name:logOutNotification object:nil]; 
    self.ProSroll.delegate = self; 
    
    UIBlocker = [[utilities alloc] init];
    [UIBlocker startUIBlockerInView:self.tabBarController.view];
    
    //ProfileID = [[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue];
    Profile=[[NSProfile alloc] initWithProfileID:ProfileID];
    [Profile setDelegate:self];
    
    // Set the Profile Image
    [[AsyncImageLoader sharedLoader] cancelLoadingURL:[NSURL URLWithString:[NSGlobalConfiguration getConfigurationItem:@"ImageURL"]]];
    NSString *strUrl = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[NSGlobalConfiguration getConfigurationItem:@"ImageURL"]]];
    NSURL *urlImg = [[NSURL alloc] initWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //[_ProfilePicture setImageURL:urlImg];
    NSLog(@"Profile Pic >>  %@",_ProfilePicture.image);
    // ----------
    
    //[Profile startFetching];
    
    
    //    self.title = @"Profile";
//    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"dot.png"];
//    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:self.title image:img tag:5];
//    self.tabBarItem = tab;

    // Do any additional setup after loading the view from its nib.
   // [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarBu target:self action:@selector(goToSettings:)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear2.png"] style:UIBarButtonSystemItemAction target:self action:@selector(goToSettings:)]];
   // [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"gear2.png"]];
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
    
    NSLog(@"%ld",(long)ProfileID);
    NSLog(@"%d",[[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue]);
    
    if (ProfileID == [[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue]){
        [_ProfilePicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)]];
    }
    else {
        [_ProfilePicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followUser)]];
        [self.UserName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followUser)]];
        [self.UserName setUserInteractionEnabled:YES]; 
    }
    [_ProfilePicture setUserInteractionEnabled:YES];
}

-(void) FollowingPressed:(UIGestureRecognizer *)gesture{
    FollowingViewController *Following=[[FollowingViewController alloc] initWithNibName:@"Following" bundle:nil ID:ProfileID];
    NSLog(@"ProfileID:%i",ProfileID);
    Following.ID = ProfileID; 
    [self.navigationController pushViewController:Following animated:YES];
}

-(void) FollowersPressed:(UIGestureRecognizer *)gesture{
    FollowingViewController *Following=[[FollowingViewController alloc] initWithNibName:@"Followers" bundle:nil ID:ProfileID];
    Following.ID = ProfileID; 
    [self.navigationController pushViewController:Following animated:YES];
}

-(IBAction)goToMenu:(UIActivityView*)sender
{
    
    NSLog(@"feedManager : %@",feedManager);
    menuViewController *menu = [[menuViewController alloc] initWithNibName:@"menuViewController" bundle:nil];
    menu.userInfo = [NSMutableDictionary dictionaryWithDictionary:[feedManager getFeedAtIndex:sender.tag]];
    menu.restaurantInfo = [NSMutableDictionary dictionaryWithObjects:[[feedManager getFeedAtIndex:sender.tag] objectsForKeys:[NSArray arrayWithObjects:@"locationID",@"Title",@"Address", nil] notFoundMarker:@"none"] forKeys:[NSArray arrayWithObjects:@"ID",@"Title",@"Address",nil]];
    menu.followeePicImg = sender.ProfilePicture.image;
    menu.followeeNametxt = sender.UserName.text;
    menu.timeLabelText = sender.lblTime.text;
    [self.navigationController pushViewController:menu animated:YES];
}

-(IBAction)goToCheckinComment:(id)sender
{
    checkinCommentViewController *menu = [[checkinCommentViewController alloc] initWithNibName:@"checkinCommentViewController" bundle:nil];
    [self.navigationController pushViewController:menu animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goToSettings:(id)sender
{
    settingsViewController *settings = [[settingsViewController alloc] initWithNibName:@"settingsViewController" bundle:nil];
    [settings setTabBarC:self.tabBarController];
    [self.navigationController pushViewController:settings animated:YES];
}


-(void) ProfileLoadingCompleted:(NSProfile *)profile{
    //Parse Data
    if ([Profile.Feeds count] > 0)
    {
        [defaultButton removeFromSuperview];
    }
    
    [FollowersCount setText:[NSString stringWithFormat:@"%i",[Profile Followers]]];
    [FollowingCount setText:[NSString stringWithFormat:@"%i",[Profile Following]]];
    [UserName setText:[Profile FullName]];
    UserName.textAlignment = NSTextAlignmentCenter;
    if(![profile canFollow]){
        [FollowButton setText:@""];
        [FollowButton setUserInteractionEnabled:NO];
        [btnFollowBack setUserInteractionEnabled:NO];
    }
    NSLog(@"_ProfilePicture >> %@",_ProfilePicture.image);
    NSImageLoaderToImageView *Loader=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[Profile ImageURL]] ImageView:self.ProfilePicture]; //[AppDelegate sharedInstance].ProfilePicture_global]; //self.ProfilePicture];//
    [Loader setDelegate:self];
    [ImageLoader startAnimating];
    [Loader start];
    
    contentLength = 0;
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];

    [self loadActivities];
}
-(void) loadActivities{
    //NSLog(@"Loading Activity");
    
    if ([Profile.Feeds count] == 0)
    {
        if (!defaultButton){
        defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 120, 320, self.view.frame.size.height-120)];
        [defaultButton setTitle:@"You have no check-in history yet. Check-in at a restaurant soon!" forState:UIControlStateNormal];
        defaultButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [defaultButton setBackgroundImage:[UIImage imageNamed:@"dot-green.png"] forState:UIControlStateNormal];
        [defaultButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.view addSubview:defaultButton];
        }
        
    }
    else {
        [defaultButton removeFromSuperview];
        defaultButton = nil; 
    }
    
    if ([Profile.Feeds count]<numberOfFeedsToLoad){
        numberOfFeedsToLoad = [Profile.Feeds count]; 
    }
    
    for(NSInteger i=0; i<numberOfFeedsToLoad;i++){
        UIActivityView *activity=[[UIActivityView alloc] initWithFrame:CGRectMake(0, (i*166)+120, 320, 156) andView:0];
        NSDictionary *ItemData=[Profile.Feeds objectAtIndex:i];
        NSLog(@"profile item:%@",ItemData); 
        
        [activity setID:[(NSString *)[ItemData valueForKey:@"FeedID"] integerValue]];
        [activity.UserName setText:[ItemData valueForKey:@"FullName"]];
        [activity.lblComment setText:[ItemData valueForKey:@"UserComment"]];
        [activity.lblLocation setText:[ItemData valueForKey:@"Location"]];
        
        [activity.lblTime setText:[ItemData valueForKey:@"DateCreated"]];
        NSString *time = [ItemData valueForKey:@"DateCreated"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *timeDate = [format dateFromString:time];
        NSString *dateString = [self humanTimeSinceDate:timeDate];
        [activity.lblTime setText:dateString]; 
        
        [activity.lblAddress setText:[ItemData valueForKey:@"Address"]]; 
        NSLog(@"_ProfilePicture >> %@",_ProfilePicture.image);
        [activity.ProfilePicture setImage:[_ProfilePicture image]];
        
        // Set the Profile Image
        NSString *strUrl = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[NSGlobalConfiguration getConfigurationItem:@"ImageURL"]]];
        _urlImg = [[NSURL alloc] initWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //[_ProfilePicture setImageWithURL:_urlImg placeholderImage:[UIImage imageNamed:@""]];
        NSLog(@"Profile Pic >> %@",_ProfilePicture.image);

//        NSImageLoaderToImageView *Loader=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData objectForKey:@"ImageURL"]] ImageView:activity.ProfilePicture];//[AppDelegate sharedInstance].ProfilePicture_global];
//        [Loader setDelegate:self];
//        [ImageLoader startAnimating];
//        [Loader start];

        
        [activity setDelegate:self];
        [activity setTag:i+1];
        [activity.commentNumberLabel setText:[ItemData valueForKey:@"nComments"]]; 
        
        if ([[ItemData valueForKey:@"UserID"] isEqual:[NSGlobalConfiguration getConfigurationItem:@"ID"]])
        {
            [activity.btnBuy removeFromSuperview];
            [activity.nameButton setFrame:CGRectMake(activity.nameButton.frame.origin.x, activity.nameButton.frame.origin.y, 310, activity.nameButton.frame.size.height)];
        }
        
        [ProSroll addSubview:activity];
        NSLog(@"added");
    }
    [ProSroll setScrollEnabled:YES];
    [ProSroll setContentSize:CGSizeMake(0, (numberOfFeedsToLoad*166)+120)];
    NSLog(@"%i",([Profile.Feeds count]*156));
}
-(void)activityviewRequestComment:(UIActivityView *)activity{
    //Load Comments View Controller and PUsh it with ID
    CommentViewController *comment=[[CommentViewController alloc] initWithNibName:@"UICommentView" bundle:nil ActivityView:activity];
    [self.navigationController pushViewController:comment animated:YES];
}
-(void) ProfileLoadingFailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [UIBlocker stopUIBlockerInView:self.tabBarController.view]; 
    [alert show];
}
-(void)imageviewloaderLoadingCompleted:(NSImageLoaderToImageView *)loader{
    [ImageLoader stopAnimating];
    [self loadActivities];
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
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *PickedImage=[info objectForKey:UIImagePickerControllerEditedImage];
    _ProfilePicture.image=[PickedImage copy];

    NSLog(@"_ProfilePicture >> %@",_ProfilePicture.image);
    [AppDelegate sharedInstance].ProfilePicture_global.image = _ProfilePicture.image;

//    if ([picker sourceType]==UIImagePickerControllerSourceTypeCamera)
//    {
//        //NSLog(@"Saved Image");
//        UIImageWriteToSavedPhotosAlbum(PickedImage, nil, nil, nil);
//    }
    
    
    if ([picker sourceType]==UIImagePickerControllerSourceTypeCamera)
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[PickedImage CGImage] orientation:(ALAssetOrientation)[PickedImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error)
        {
            if (error)
            {
                NSLog(@"error");
            }
            else
            {
                NSLog(@"url %@", assetURL);
                NSURL *imagePath = assetURL;
                NSString *name = [NSString stringWithFormat:@"%@",imagePath];
                NSLog(@"name : %@",name);
                NSArray *listItems = [name componentsSeparatedByString:@"="];
                NSLog(@"listItems : %@",listItems);
                NSString *imgName = [listItems objectAtIndex:listItems.count-2];
                imgName = [NSString stringWithFormat:@"%@.png",imgName];
                NSString *extention = [listItems objectAtIndex:listItems.count-1];
                
                    img1 = PickedImage;
                    imgName1 = imgName;
                    imgExt1 = extention;
                }
        }];
        
    }
    else
    {
        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSString *name = [NSString stringWithFormat:@"%@",imagePath];
        NSLog(@"name : %@",name);
        NSArray *listItems = [name componentsSeparatedByString:@"="];
        NSLog(@"listItems : %@",listItems);
        NSString *imgName = [listItems objectAtIndex:listItems.count-2];
        imgName = [NSString stringWithFormat:@"%@.png",imgName];
        NSString *extention = [listItems objectAtIndex:listItems.count-1];
        
            img1 = PickedImage;
            imgName1 = imgName;
            imgExt1 = extention;
            
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

//PickedImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // ------- Upload image over the server for specific user
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@updateuserimage.php",[NSGlobalConfiguration URL]]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:URL];
    [request setDelegate:self];
    [request addPostValue:[NSGlobalConfiguration getConfigurationItem:@"Email"] forKey:@"Email"];

    
    if(ScaledImage)
  //  if(PickedImage)
    {
        NSLog(@"_ProfilePicture >> %@",_ProfilePicture.image);
        ScaledImage = [self imageByScalingProportionallyToSize:CGSizeMake(_ProfilePicture.frame.size.width, _ProfilePicture.frame.size.height) srcImg:_ProfilePicture.image];
        NSData *imageData1 = UIImageJPEGRepresentation(ScaledImage, 100);
   //     NSData *imageData1 = UIImageJPEGRepresentation(PickedImage, 100);
        [request setData:imageData1 withFileName:imgName1 andContentType:@"png" forKey:@"ProfilePicture"];
    }
    
    [request setDidFinishSelector:@selector(returnSuccessfulPost:)];
    [request setDidFailSelector:@selector(failedPost:)];
    [request startAsynchronous];
    
    // --------------------------------------
    
    NSLog(@"_ProfilePicture >> %@",_ProfilePicture.image);
    NSLog(@"ScaledImage >> %@",ScaledImage);

    [_ProfilePicture setImage:ScaledImage];
//     [_ProfilePicture setImage:PickedImage];

    [picker dismissViewControllerAnimated:YES completion:nil];
    [self cancelPhotoSet:nil];
}

-(void)failedPost:(ASIHTTPRequest*)requestor
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Post Unsuccessful." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)returnSuccessfulPost:(ASIHTTPRequest*)requestor{
    
    NSString *strResponse = [requestor responseString];
    NSLog(@"strResponse >> %@",strResponse);
    NSError *error;
    
    NSDictionary *dict = [XMLReader dictionaryForXMLString:strResponse error:&error];
    NSLog(@"dict: %@",dict);
    
    // stores the new image url for the profile picture
    NSString *strNewImageUrl = [NSString stringWithFormat:@"http://50.62.148.155:8080/heres2u/api/%@",[[[[dict valueForKey:@"Response"] valueForKey:@"MessagePayload"] valueForKey:@"Url"] valueForKey:@"text"]];
    strNewImageUrl = [[[[[dict valueForKey:@"Response"] valueForKey:@"MessagePayload"] valueForKey:@"Url"] valueForKey:@"text"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [NSGlobalConfiguration setConfigurationItem:@"ImageURL" Item:strNewImageUrl];
    
    NSString *strUrl = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[NSGlobalConfiguration getConfigurationItem:@"ImageURL"]]];
    _urlImg = [[NSURL alloc] initWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [_ProfilePicture setImageWithURL:_urlImg placeholderImage:[UIImage imageNamed:@""]];
    
    //NSImageLoaderToImageView *loader = [[NSImageLoaderToImageView alloc] initWithURL:_urlImg ImageView:_ProfilePicture StartImmediately:YES];
    
    NSLog(@"Profile Pic >> %@",_ProfilePicture.image);
    // ----------

 /*
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding]];
    parser.delegate = self;
    [parser parse]; 
    
    SBJSON *json = [SBJSON new];
    NSDictionary *dict = [json objectWithString:strResponse error:&error];
    NSLog(@"dict: %@",dict);
    //[NSGlobalConfiguration setConfigurationItem:@"ImageURL" Item:[dict objectForKey:@"Url"]];
     [Profile startFetching];
    */
    
}


-(IBAction)takePicture:(id)sender{
    UIImagePickerController *controller=[[UIImagePickerController alloc] init];
    [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
    [controller setShowsCameraControls:YES];
    [controller setDelegate:self];
    [controller setAllowsEditing:YES];
    [self presentModalViewController:controller animated:YES];
}
-(IBAction)selectFromLibrary:(id)sender{
    NSLog(@"Select picture");
    UIImagePickerController *controller=[[UIImagePickerController alloc] init];
    [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [controller setDelegate:self];
    [controller setAllowsEditing:YES];
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
    ProfileID = nil; 
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    CurrentString=@"";
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    CurrentString=[NSString stringWithFormat:@"%@%@",CurrentString,string];
    CurrentString = [CurrentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([[elementName lowercaseString] isEqualToString:@"url"]){
        NSLog(@"URL:%@",CurrentString);
        NSString *Directory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *ImageName = [CurrentString lastPathComponent];
        NSString *Path=[Directory stringByAppendingPathComponent:ImageName];
        BOOL created=[[NSFileManager defaultManager] createFileAtPath:Path contents:nil attributes:nil];
        if(created){
            NSFileHandle *handle=[NSFileHandle fileHandleForWritingAtPath:Path];
            [handle writeData:UIImagePNGRepresentation(self.ProfilePicture.image)];
            [handle closeFile];
        }
        
       }
}
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
    [parser abortParsing];
    parser=nil;
}
-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
        [parser abortParsing];
    parser=nil;
}
-(void) parserDidEndDocument:(NSXMLParser *)parser{
    //Send completion signal
       [parser abortParsing];
    parser=nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float contentOffset = scrollView.contentOffset.y;
    if (contentOffset > scrollView.contentSize.height*0.8 && numberOfFeedsToLoad < [Profile.Feeds count])
    {
        numberOfFeedsToLoad = numberOfFeedsToLoad + 15;
        [self loadActivities]; 
    }
}

#pragma mark
#pragma mark compress image

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize srcImg:(UIImage *)image
{
	UIImage *sourceImage = image;
	UIImage *newImage = nil;
	
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor < heightFactor)
			scaleFactor = widthFactor;
        else
			scaleFactor = heightFactor;
		
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
		
        if (widthFactor < heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
	}
	
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(newImage == nil) NSLog(@"could not scale image");
	
	
	return newImage ;
}

-(void)followUser
{
    [NSUserInterfaceCommands followUser:ProfileID FolloweeID:[[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue] CallbackDelegate:self]; 
}

-(void)userinterfaceCommandFailed:(NSString *)message{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}
-(void) userinterfaceCommandSucceeded:(NSString *)message{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
   
}

-(NSString*)humanTimeSinceDate:(NSDate*)date
{
    //assumes PST as reference date
    int offset = [[NSTimeZone localTimeZone] secondsFromGMT];
    //PST is -28800 s, PDT - 25200. This is the timestamp our server gives to check-ins and must be adjusted for other time zones.
    // NSLog(@"offest:%i",offset);
    NSTimeZone* systemTimeZone = [NSTimeZone systemTimeZone];
    BOOL dstIsOn = [systemTimeZone isDaylightSavingTime];
    int adjustSeconds;
    if (dstIsOn){
        adjustSeconds = offset + 25200;
    }
    else {
        adjustSeconds = offset + 28800;
    }
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    NSTimeInterval adjusted = interval - adjustSeconds;
    float minutesDiff = adjusted / 60;
    float hoursDiff = minutesDiff/60;
    float daysDiff = hoursDiff/24;
    float weeksDiff = daysDiff/7;
    float yearsDiff = weeksDiff/52;
    
    NSString *returnString;
    
    if (minutesDiff < 1)
    {
        returnString = @"1m";
    }
    else if (minutesDiff > 1 && hoursDiff < 1)
    {
        NSString *floatString = [NSString stringWithFormat:@"%0.f",minutesDiff];
        
        if ([floatString isEqualToString:@"1"]) {
            returnString = [NSString stringWithFormat:@"%.0fm",minutesDiff];
        }
        else {
            returnString = [NSString stringWithFormat:@"%.0fm",minutesDiff];
        }
    }
    else if (hoursDiff > 1 && daysDiff < 1)
    {
        NSString *floatString = [NSString stringWithFormat:@"%0.f",hoursDiff];
        
        if ([floatString isEqualToString:@"1"]) {
            
            returnString = [NSString stringWithFormat:@"%.0fh",hoursDiff];
        }
        else {
            returnString = [NSString stringWithFormat:@"%.0fh",hoursDiff];
        }
    }
    else if (daysDiff >1 && weeksDiff < 1)
    {
        NSString *floatString = [NSString stringWithFormat:@"%0.f",daysDiff];
        
        if ([floatString isEqualToString:@"1"]) {
            
            returnString = [NSString stringWithFormat:@"%.0fd",daysDiff];
        }
        else {
            returnString = [NSString stringWithFormat:@"%.0fd",daysDiff];
            
        }
    }
    else if (weeksDiff >1 && yearsDiff < 1){
        NSString *floatString = [NSString stringWithFormat:@"%0.f",weeksDiff];
        
        if ([floatString isEqualToString:@"1"]) {
            returnString = [NSString stringWithFormat:@"%.0fw",weeksDiff];
        }
        else {
            returnString = [NSString stringWithFormat:@"%.0fw",weeksDiff];
        }
    }
    else {
        returnString = [NSString stringWithFormat:@"%.0fy",yearsDiff];
    }
    return returnString;
}

@end
