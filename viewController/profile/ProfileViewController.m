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
    numberOfFeedsToLoad = 15; 
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
    self.ProSroll.delegate = self; 
    
    UIBlocker = [[utilities alloc] init];
    [UIBlocker startUIBlockerInView:self.tabBarController.view];
    
    ProfileID = [[NSGlobalConfiguration getConfigurationItem:@"ID"] intValue];
    Profile=[[NSProfile alloc] initWithProfileID:ProfileID];
    [Profile setDelegate:self];
    
    // Set the Profile Image
    [[AsyncImageLoader sharedLoader] cancelLoadingURL:[NSURL URLWithString:[NSGlobalConfiguration getConfigurationItem:@"ImageURL"]]];
    NSString *strUrl = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[NSGlobalConfiguration getConfigurationItem:@"ImageURL"]]];
    NSURL *urlImg = [[NSURL alloc] initWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [_ProfilePicture setImageURL:urlImg];
    NSLog(@"Profile Pic >>  %@",_ProfilePicture.image);
    // ----------
    
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
    [_ProfilePicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)]];
    [_ProfilePicture setUserInteractionEnabled:YES];
    
    
}
-(void) FollowingPressed:(UIGestureRecognizer *)gesture{
    FollowingViewController *Following=[[FollowingViewController alloc] initWithNibName:@"Following" bundle:nil];
    [self.navigationController pushViewController:Following animated:YES];
}

-(void) FollowersPressed:(UIGestureRecognizer *)gesture{
    FollowingViewController *Following=[[FollowingViewController alloc] initWithNibName:@"Followers" bundle:nil];
    [self.navigationController pushViewController:Following animated:YES];
}

-(IBAction)goToMenu:(id)sender
{
    menuViewController *menu = [[menuViewController alloc] initWithNibName:@"menuViewController" bundle:nil];
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
    if(![profile canFollow]){
        [FollowButton setText:@""];
        [FollowButton setUserInteractionEnabled:NO];
        [btnFollowBack setUserInteractionEnabled:NO];
    }
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
        defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 120, 320, self.view.frame.size.height-120)];
        [defaultButton setTitle:@"You have no followees yet. Search for them on the Profile page!" forState:UIControlStateNormal];
        [defaultButton setBackgroundImage:[UIImage imageNamed:@"dot-green.png"] forState:UIControlStateNormal];
        [defaultButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.view addSubview:defaultButton];
    }
    else {
        [defaultButton removeFromSuperview]; 
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
        [activity.ProfilePicture setImage:[_ProfilePicture image]];
        
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
        }
        
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *PickedImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    _ProfilePicture.image=[PickedImage copy];

    [AppDelegate sharedInstance].ProfilePicture_global.image = _ProfilePicture.image;

    if ([picker sourceType]==UIImagePickerControllerSourceTypeCamera)
    {
        //NSLog(@"Saved Image");
        UIImageWriteToSavedPhotosAlbum(PickedImage, nil, nil, nil);
    }
    
    
    if ([picker sourceType]==UIImagePickerControllerSourceTypeCamera)
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[PickedImage CGImage] orientation:(ALAssetOrientation)[PickedImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                NSLog(@"error");
            } else {
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
    UIGraphicsEndImageContext();
    
    // ------- Upload image over the server for specific user
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@updateuserimage.php",[NSGlobalConfiguration URL]]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:URL];
    [request setDelegate:self];
    [request addPostValue:[NSGlobalConfiguration getConfigurationItem:@"Email"] forKey:@"Email"];

    
    if(ScaledImage)
    {
        NSData *imageData1 = UIImageJPEGRepresentation(ScaledImage, 100);
        [request setData:imageData1 withFileName:imgName1 andContentType:@"png" forKey:@"ProfilePicture"];
    }
    
    [request setDidFinishSelector:@selector(returnSuccessfulPost:)];
    [request setDidFailSelector:@selector(failedPost:)];
    [request startAsynchronous];
    
    // --------------------------------------
    
    [_ProfilePicture setImage:ScaledImage];
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
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding]];
    parser.delegate = self;
    [parser parse]; 
    
    SBJSON *json = [SBJSON new];
    NSDictionary *dict = [json objectWithString:strResponse error:&error];
    NSLog(@"dict: %@",dict);
    //[NSGlobalConfiguration setConfigurationItem:@"ImageURL" Item:[dict objectForKey:@"Url"]];
     [Profile startFetching];
    
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
@end
