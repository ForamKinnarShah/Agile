//
//  MytabViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "MytabViewController.h"
#import "ProfileViewController.h"
#import "utilities.h" 
#import "orderItemView.h"

@interface MytabViewController ()

@end

@implementation MytabViewController
@synthesize caller, util, receivedItems, sentItems, usedItems;
//@synthesize myparser;
@synthesize arrayData,arrayTransactionsID,arrayLocationID,arrayLocationImage,arrayLocationName,arrayMiles,arrayPrice,arraySenderID,arraySenderName,arrayStatus,arrayCoupanNumber,arrayLatitude,arrayLongitude,arraySayThanksReceived;

@synthesize arrayData1,arrayTransactionsID1,arrayLocationID1,arrayLocationImage1,arrayLocationName1,arrayMiles1,arrayPrice1,arraySenderID1,arraySenderName1,arrayStatus1,arrayLatitude1,arrayLongitude1;

@synthesize arrayData2,arrayTransactionsID2,arrayLocationID2,arrayLocationImage2,arrayLocationName2,arrayMiles2,arrayPrice2,arraySenderID2,arraySenderName2,arrayStatus2,arraySayThanks2,arrayLatitude2,arrayLongitude2;
@synthesize HUD;


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
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    isViewDisApper = NO;
    locationIndex=0;
    
        
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - objTableView.bounds.size.height, self.view.frame.size.width, objTableView.bounds.size.height)];
		view.delegate = self;
		[objTableView addSubview:view];
		_refreshHeaderView = view;
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    isLatLong = NO;
    
    
    hostURl = [NSGlobalConfiguration URL];
 //   NSLog(@"hostURl : %@",hostURl);
    
    [segmented addTarget:self action:@selector(segmentControlChanged) forControlEvents:UIControlEventValueChanged];

    caller = [[phpCaller alloc] init];
    caller.delegate = self;

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    //array
    self.arrayData = [[NSMutableArray alloc] init];
    self.arrayTransactionsID = [[NSMutableArray alloc] init];
    self.arrayLocationID = [[NSMutableArray alloc] init];
    self.arrayLocationImage = [[NSMutableArray alloc] init];
    self.arrayLocationName = [[NSMutableArray alloc] init];
    self.arrayMiles = [[NSMutableArray alloc] init];
    self.arrayPrice = [[NSMutableArray alloc] init];
    self.arraySenderID = [[NSMutableArray alloc] init];
    self.arraySenderName = [[NSMutableArray alloc] init];
    self.arrayStatus = [[NSMutableArray alloc] init];
    self.arrayLatitude = [[NSMutableArray alloc] init];
    self.arrayLongitude = [[NSMutableArray alloc] init];
    self.arrayCoupanNumber = [[NSMutableArray alloc] init];
    self.arraySayThanksReceived = [[NSMutableArray alloc] init];
    
    //array1
    self.arrayData1 = [[NSMutableArray alloc] init];
    self.arrayTransactionsID1 = [[NSMutableArray alloc] init];
    self.arrayLocationID1 = [[NSMutableArray alloc] init];
    self.arrayLocationImage1 = [[NSMutableArray alloc] init];
    self.arrayLocationName1 = [[NSMutableArray alloc] init];
    self.arrayMiles1 = [[NSMutableArray alloc] init];
    self.arrayPrice1 = [[NSMutableArray alloc] init];
    self.arraySenderID1 = [[NSMutableArray alloc] init];
    self.arraySenderName1 = [[NSMutableArray alloc] init];
    self.arrayStatus1 = [[NSMutableArray alloc] init];
    self.arrayLatitude1 = [[NSMutableArray alloc] init];
    self.arrayLongitude1 = [[NSMutableArray alloc] init];
    
    //array2
    self.arrayData2 = [[NSMutableArray alloc] init];
    self.arrayTransactionsID2 = [[NSMutableArray alloc] init];
    self.arrayLocationID2 = [[NSMutableArray alloc] init];
    self.arrayLocationImage2 = [[NSMutableArray alloc] init];
    self.arrayLocationName2 = [[NSMutableArray alloc] init];
    self.arrayMiles2 = [[NSMutableArray alloc] init];
    self.arrayPrice2 = [[NSMutableArray alloc] init];
    self.arraySenderID2 = [[NSMutableArray alloc] init];
    self.arraySenderName2 = [[NSMutableArray alloc] init];
    self.arrayStatus2 = [[NSMutableArray alloc] init];
    self.arraySayThanks2 = [[NSMutableArray alloc] init];
    self.arrayLatitude2 = [[NSMutableArray alloc] init];
    self.arrayLongitude2 = [[NSMutableArray alloc] init];
    
    //[self callReceivedData];
   
}


-(void)viewWillAppear:(BOOL)animated{
    @try {
        [super viewWillAppear:animated];
        
    //    NSLog(@"selectedSegment : %d",selectedSegment);
        if(selectedSegment==1){
            isSent = NO;
            [self startLoading];
            [self performSelector:@selector(callSegment1) withObject:self afterDelay:1.0];
            return;
        }
        else if(selectedSegment==2){
            isUsed = NO;
            [self startLoading];
            [self performSelector:@selector(callSegment2) withObject:self afterDelay:1.0];
            return;
        }
        else{
            segmented.selectedSegmentIndex=0;
            selectedSegment =0;
            if(selectedSegment==0){
                isReceived  = NO;
                
                [self.arrayTransactionsID removeAllObjects];
                [self.arrayLocationID  removeAllObjects];
                [self.arrayLocationImage removeAllObjects];
                [self.arrayLocationName removeAllObjects];
                [self.arrayMiles removeAllObjects];
                [self.arrayPrice removeAllObjects];
                [self.arrayStatus removeAllObjects];
                [self.arraySenderID removeAllObjects];
                [self.arraySenderName  removeAllObjects];
                [self.arrayCoupanNumber  removeAllObjects];
                [self.arrayLongitude  removeAllObjects];
                [self.arrayLatitude  removeAllObjects];
                [self.arraySayThanksReceived removeAllObjects];
            }
            
            [self startLoading];
            [self performSelector:@selector(callReceivedData) withObject:nil afterDelay:1.0];
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    @try {
        isViewDisApper = YES;
        
        isReceived  = NO;
        
        [self.arrayTransactionsID removeAllObjects];
        [self.arrayLocationID  removeAllObjects];
        [self.arrayLocationImage removeAllObjects];
        [self.arrayLocationName removeAllObjects];
        [self.arrayMiles removeAllObjects];
        [self.arrayPrice removeAllObjects];
        [self.arrayStatus removeAllObjects];
        [self.arraySenderID removeAllObjects];
        [self.arraySenderName  removeAllObjects];
        [self.arrayCoupanNumber  removeAllObjects];
        [self.arrayLongitude  removeAllObjects];
        [self.arrayLatitude  removeAllObjects];
        
        isSent=NO;
        
        [self.arrayTransactionsID1 removeAllObjects];
        [self.arrayLocationID1  removeAllObjects];
        [self.arrayLocationImage1 removeAllObjects];
        [self.arrayLocationName1 removeAllObjects];
        [self.arrayMiles1 removeAllObjects];
        [self.arrayPrice1 removeAllObjects];
        [self.arrayStatus1 removeAllObjects];
        [self.arraySenderID1 removeAllObjects];
        [self.arraySenderName1  removeAllObjects];
        [self.arrayLongitude1  removeAllObjects];
        [self.arrayLatitude1  removeAllObjects];
        
        isUsed=NO;
        
        [self.arrayTransactionsID2 removeAllObjects];
        [self.arrayLocationID2  removeAllObjects];
        [self.arrayLocationImage2  removeAllObjects];
        [self.arrayLocationName2  removeAllObjects];
        [self.arrayMiles2  removeAllObjects];
        [self.arrayPrice2  removeAllObjects];
        [self.arrayStatus2  removeAllObjects];
        [self.arraySenderID2  removeAllObjects];
        [self.arraySenderName2  removeAllObjects];
        [self.arraySayThanks2  removeAllObjects];
        [self.arrayLongitude2  removeAllObjects];
        [self.arrayLatitude2 removeAllObjects];
    }
    @catch (NSException *exception) {
        
    }
}

-(void)startLoading{
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	self.HUD = [[MBProgressHUD alloc] initWithView:appDelegate.window];
	self.HUD.animationType = MBProgressHUDAnimationZoom;
	// Add HUD to screen
	[appDelegate.window addSubview:self.HUD];
	
	// Regisete for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	self.HUD.labelText = @"Loading";
    [self.HUD show:YES];
    [appDelegate.window bringSubviewToFront:self.HUD];
    
    
    //[self performSelectorInBackground:@selector(doLogin) withObject:nil];
//    if(selectedSegment==0){
//       // [self.HUD showWhileExecuting:@selector(callReceivedData) onTarget:self withObject:nil animated:YES];
//        [self.HUD show:YES];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self callReceivedData];
//        });
//    }
//    else{
//        //segmentControlChanged
//        //[self.HUD showWhileExecuting:@selector(segmentControlChanged) onTarget:self withObject:nil animated:YES];
//    }
}

-(void)stopLoading{
    [self.HUD hide:YES];
    [MBProgressHUD hideHUDForView:appDelegate.window animated:YES];
    [self.HUD removeFromSuperview];
}


-(void)callReceivedData{
    @try {
        
        uId = (NSString *)[NSGlobalConfiguration getConfigurationItem:@"ID"];
    //    NSLog(@"uId : %@",uId);
    //    NSLog(@"status:%u",[CLLocationManager authorizationStatus]);
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized)
        {
     //       NSLog(@"locations not authorized, stopping locationmanager");
            [locationManager stopUpdatingLocation];
            isLatLong = YES;
            currentLat = @"0";
            currentLong = @"0";
        }
        
        if(isLatLong){
            
            //http://50.62.148.155:8080/heres2u/api/index.php?webservice=ui&action=getreceiveditems&ID=33&Lat=-33.7501&Long=18.4533
            
            isReceived = YES;            
            NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@index.php?webservice=ui&action=getreceiveditems&ID=%@&Lat=-%@&Long=%@",hostURl,uId,currentLat,currentLong]];
       //     NSLog(@" : %@",url);
            
            
            [dicReceived removeAllObjects];
            myparser = [[MyTabXmlParse alloc] initWithURL:url];
       //     NSLog(@"dicReceived: %@",dicReceived);
            if(dicReceived.count==0){
                if(isParseFailed){
                    isParseFailed = NO;
                    [objTableView reloadData];
                    [self stopLoading];
                    return;
                }
                else{
                    [objTableView reloadData];
                    [self stopLoading];
                    
                    UIAlertView *alertReceived = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"No Gifts Found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertReceived performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                    
                    return;
                }
            }
            
            
            NSArray *arrayCouynt = [dicReceived valueForKey:@"TransactionsID"];
            for(int i=0;i<arrayCouynt.count;i++){
                [self.arrayTransactionsID addObject:[[dicReceived valueForKey:@"TransactionsID"] objectAtIndex:i]];
                [self.arrayLocationID  addObject:[[dicReceived valueForKey:@"LocationID"] objectAtIndex:i]];
                [self.arrayLocationImage addObject:[[dicReceived valueForKey:@"LocationImage"]objectAtIndex:i]];
                [self.arrayLocationName addObject:[[dicReceived valueForKey:@"LocationName"] objectAtIndex:i]];
                [self.arrayMiles addObject:[[dicReceived valueForKey:@"Miles"] objectAtIndex:i]];
                [self.arrayPrice addObject:[[dicReceived valueForKey:@"Price"] objectAtIndex:i]];
                [self.arrayStatus addObject:[[dicReceived valueForKey:@"Status"] objectAtIndex:i]];
                [self.arraySenderID addObject:[[dicReceived valueForKey:@"senderId"] objectAtIndex:i]];
                [self.arraySenderName  addObject:[[dicReceived valueForKey:@"senderName"] objectAtIndex:i]];
                [self.arrayCoupanNumber  addObject:[[dicReceived valueForKey:@"CoupanCode"] objectAtIndex:i]];
                [self.arrayLongitude  addObject:[[dicReceived valueForKey:@"Longitude"] objectAtIndex:i]];
                [self.arrayLatitude  addObject:[[dicReceived valueForKey:@"Latitude"] objectAtIndex:i]];
                [self.arraySayThanksReceived  addObject:[[dicReceived valueForKey:@"SayThanksId"] objectAtIndex:i]];
                
            }
            [objTableView reloadData];
            [self stopLoading];
//            [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];

//            dispatch_async(dispatch_get_main_queue(), ^{
                
//            }); 
            
            if(dicReceived.count==0){
                
                UIAlertView *alertReceived = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"No More Data Found!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertReceived show];
            }
            else{
            }
        }
        else{
            [self performSelector:@selector(callReceivedData) withObject:nil afterDelay:1.0];
        }

    }
    @catch (NSException *exception) {
 //       NSLog(@"exception : %@",exception);
    }
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

-(void)segmentControlChanged
{
  //  NSLog(@"[segmented selectedSegmentIndex] : %d",[segmented selectedSegmentIndex]);
    selectedSegment = [segmented selectedSegmentIndex];
    
    [self startLoading];
    if ([segmented selectedSegmentIndex] == 0)
    {
        if(!isReceived){
            isReceived = YES;
            
//            [self.arrayTransactionsID removeAllObjects];
//            [self.arrayLocationID  removeAllObjects];
//            [self.arrayLocationImage removeAllObjects];
//            [self.arrayLocationName removeAllObjects];
//            [self.arrayMiles removeAllObjects];
//            [self.arrayPrice removeAllObjects];
//            [self.arrayStatus removeAllObjects];
//            [self.arraySenderID removeAllObjects];
//            [self.arraySenderName  removeAllObjects];
//            [self.arrayCoupanNumber  removeAllObjects];
//            [self.arrayLongitude  removeAllObjects];
//            [self.arrayLatitude  removeAllObjects];
            
            [self performSelector:@selector(callReceivedData) withObject:self afterDelay:0.5];
        }
        else{
            [objTableView reloadData];
            [self stopLoading];
        }
    }
    else if ([segmented selectedSegmentIndex] == 1)
    {
        if(!isSent ){
            isSent = YES;
           
//            [self.arrayTransactionsID1 removeAllObjects];
//            [self.arrayLocationID1  removeAllObjects];
//            [self.arrayLocationImage1 removeAllObjects];
//            [self.arrayLocationName1 removeAllObjects];
//            [self.arrayMiles1 removeAllObjects];
//            [self.arrayPrice1 removeAllObjects];
//            [self.arrayStatus1 removeAllObjects];
//            [self.arraySenderID1 removeAllObjects];
//            [self.arraySenderName1  removeAllObjects];

            
            [self performSelector:@selector(callSegment1) withObject:self afterDelay:0.5];
        }
        else{
            [objTableView reloadData];
            [self stopLoading];
        }
    }
    else if ([segmented selectedSegmentIndex] == 2)
    {   
        if(!isUsed){
            isUsed = YES;
            
//            [self.arrayTransactionsID2 removeAllObjects];
//            [self.arrayLocationID2  removeAllObjects];
//            [self.arrayLocationImage2  removeAllObjects];
//            [self.arrayLocationName2  removeAllObjects];
//            [self.arrayMiles2  removeAllObjects];
//            [self.arrayPrice2  removeAllObjects];
//            [self.arrayStatus2  removeAllObjects];
//            [self.arraySenderID2  removeAllObjects];
//            [self.arraySenderName2  removeAllObjects];
//            [self.arraySayThanks2  removeAllObjects];
            
            [self performSelector:@selector(callSegment2) withObject:self afterDelay:0.5];
        }
        else{
            [objTableView reloadData];
            [self stopLoading];
        }
    }
}

-(void)callSegment1{
    @try {
        
        //http://50.62.148.155:8080/heres2u/api/index.php?webservice=ui&action=getsentitems&ID=36&Lat=-33.7501&Long=18.4533
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@index.php?webservice=ui&action=getsentitems&ID=%@&Lat=%@&Long=%@",hostURl,uId,currentLat,currentLong]];
    //    NSLog(@"url : %@",url);
        myTabSent = [[MyTabSent alloc] initWithURL:url];
        
        //dictTransaction
     //   NSLog(@"dicSent: %@",dicSent);
    //    NSLog(@"count : %d",dicSent.count);
        
        if(dicSent.count==0){
            if(isParseFailed){
                isParseFailed = NO;
                [objTableView reloadData];
                [self stopLoading];
                return;
            }
            else{
                [objTableView reloadData];
                [self stopLoading];
                
                 UIAlertView *alertReceived = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"No Sent Data Found!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertReceived show];
                return;
            }
        }
        else{
            [self.arrayTransactionsID1 removeAllObjects];
            [self.arrayLocationID1  removeAllObjects];
            [self.arrayLocationImage1 removeAllObjects];
            [self.arrayLocationName1 removeAllObjects];
            [self.arrayMiles1 removeAllObjects];
            [self.arrayPrice1 removeAllObjects];
            [self.arrayStatus1 removeAllObjects];
            [self.arraySenderID1 removeAllObjects];
            [self.arraySenderName1  removeAllObjects];
            [self.arrayLongitude1  removeAllObjects];
            [self.arrayLatitude1  removeAllObjects];

        }

        
        NSArray *arrayCouynt = [dicSent valueForKey:@"TransactionsID"];
        for(int i=0;i<arrayCouynt.count;i++){
         //   NSLog(@"I : %d",i);
            [self.arrayTransactionsID1  addObject:[[dicSent valueForKey:@"TransactionsID"] objectAtIndex:i]];
            [self.arrayLocationID1  addObject:[[dicSent valueForKey:@"LocationID"] objectAtIndex:i]];
            [self.arrayLocationImage1 addObject:[[dicSent valueForKey:@"LocationImage"]objectAtIndex:i]];
            [self.arrayLocationName1 addObject:[[dicSent valueForKey:@"LocationName"] objectAtIndex:i]];
            [self.arrayMiles1 addObject:[[dicSent valueForKey:@"Miles"] objectAtIndex:i]];
            [self.arrayPrice1 addObject:[[dicSent valueForKey:@"Price"] objectAtIndex:i]];
            [self.arrayStatus1 addObject:[[dicSent valueForKey:@"Status"] objectAtIndex:i]];
            [self.arraySenderID1 addObject:[[dicSent valueForKey:@"senderId"] objectAtIndex:i]];
            [self.arraySenderName1  addObject:[[dicSent valueForKey:@"senderName"] objectAtIndex:i]];
            [self.arrayLongitude1  addObject:[[dicSent valueForKey:@"Longitude"] objectAtIndex:i]];
            [self.arrayLatitude1  addObject:[[dicSent valueForKey:@"Latitude"] objectAtIndex:i]];
        }
        
        if(dicSent.count==0){
            UIAlertView *alertReceived = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"No More Data Found!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertReceived show];
        }
        else{
        }
        [objTableView reloadData];
        [self stopLoading];
        
    }
    @catch (NSException *exception) {
        
    }
}


-(void)callSegment2{
    @try {
       //http://50.62.148.155:8080/heres2u/api/index.php?webservice=ui&action=getuseditems&ID=39&Lat=-33.7501&Long=18.4533
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@index.php?webservice=ui&action=getuseditems&ID=%@&Lat=%@&Long=%@",hostURl,uId,currentLat,currentLong]];
    //    NSLog(@"url : %@",url);
       
        myTabUsed = [[MyTabUsed alloc] initWithURL:url];
        //dictTransaction
    //    NSLog(@"dicReceived: %@",dicUsed);
        if(dicUsed.count==0){
            if(isParseFailed){
                isParseFailed = NO;
                [objTableView reloadData];
                [self stopLoading];
                return;
            }
            else{
                [objTableView reloadData];
                [self stopLoading];
                
                UIAlertView *alertReceived = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"No Used Data Found!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertReceived show];
                return;
            }
        }
        else{
            [self.arrayTransactionsID2 removeAllObjects];
            [self.arrayLocationID2  removeAllObjects];
            [self.arrayLocationImage2  removeAllObjects];
            [self.arrayLocationName2  removeAllObjects];
            [self.arrayMiles2  removeAllObjects];
            [self.arrayPrice2  removeAllObjects];
            [self.arrayStatus2  removeAllObjects];
            [self.arraySenderID2  removeAllObjects];
            [self.arraySenderName2  removeAllObjects];
            [self.arraySayThanks2  removeAllObjects];
            [self.arrayLongitude2  removeAllObjects];
            [self.arrayLatitude2  removeAllObjects];
        }
        
        NSArray *arrayCouynt = [dicUsed valueForKey:@"TransactionId"];
        for(int i=0;i<arrayCouynt.count;i++){
            [self.arrayTransactionsID2  addObject:[[dicUsed valueForKey:@"TransactionId"] objectAtIndex:i]];
            [self.arrayLocationID2  addObject:[[dicUsed valueForKey:@"LocationID"] objectAtIndex:i]];
            [self.arrayLocationImage2 addObject:[[dicUsed valueForKey:@"LocationImage"]objectAtIndex:i]];
            [self.arrayLocationName2 addObject:[[dicUsed valueForKey:@"LocationName"] objectAtIndex:i]];
            [self.arrayMiles2 addObject:[[dicUsed valueForKey:@"Miles"] objectAtIndex:i]];
            [self.arrayPrice2 addObject:[[dicUsed valueForKey:@"Price"] objectAtIndex:i]];
            [self.arrayStatus2 addObject:[[dicUsed valueForKey:@"Status"] objectAtIndex:i]];
            [self.arraySenderID2 addObject:[[dicUsed valueForKey:@"senderId"] objectAtIndex:i]];
            [self.arraySenderName2  addObject:[[dicUsed valueForKey:@"senderName"] objectAtIndex:i]];
            [self.arraySayThanks2 addObject:[[dicUsed valueForKey:@"SayThanksId"] objectAtIndex:i]];
            [self.arrayLongitude2  addObject:[[dicUsed valueForKey:@"Longitude"] objectAtIndex:i]];
            [self.arrayLatitude2  addObject:[[dicUsed valueForKey:@"Latitude"] objectAtIndex:i]];
        }
        
        if(dicUsed.count==0){
            UIAlertView *alertReceived = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"No More Data Found !" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertReceived show];
        }
        else{
        }
        [objTableView reloadData];
        [self stopLoading];

    }
    @catch (NSException *exception) {
        
    }
}

//-(void) phpCallerFailed:(NSError *)error
//{
//    [utilities showAlertWithTitle:@"loading failed" Message:nil];
//}

//-(void) phpCallerFinished:(NSMutableArray*)returnData
//{
//    NSLog(@"phpCaller finished with items:%@",returnData);
//    
//    if ([segmented selectedSegmentIndex] == 0)
//    {
//        receivedItems = returnData;
//    }
//    if ([receivedItems count] != 0)
//    {
//        [_defaultBtn setHidden:YES]; 
//        [self loadActivitiesWithItems:receivedItems];
//    }
//}
//
//-(void) loadActivitiesWithItems:(NSMutableArray*)items{
//    //NSLog(@"Loading Activity");
//    for(NSInteger i=0; i<[items count];i++){
//        
//        orderItemView *item=[[orderItemView alloc] initWithFrame:CGRectMake(0, (i*81)+40, 320, 81)];
//        NSDictionary *ItemData=[items objectAtIndex:i];
//        item.senderNameBtn.titleLabel.text = [ItemData objectForKey:@"sendUserNameFullName"];
//        item.restaurantNameLbl.text = [ItemData objectForKey:@"restaurantName"];
//        item.itemNameLbl.text = [NSString stringWithFormat:@"%@ %@",[ItemData objectForKey:@"itemPrice"],[ItemData objectForKey:@"itemName"]]; 
//       // NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData valueForKey:@"ImageURL"]] ImageView:friend.picture];
//        //[img start];
//        [item setDelegate:self];
//        [self.view addSubview:item];
//        // NSLog(@"added");
//    }
//    [(UIScrollView *)self.view setScrollEnabled:YES];
//    [(UIScrollView *)self.view setContentSize:CGSizeMake(320, ([items count]*85))];
//    // NSLog(@"%i",([Profile.Feeds count]*166));
//}



#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
       
    if(selectedSegment==0){
        isReceived  = NO;
     
        [self.arrayTransactionsID removeAllObjects];
        [self.arrayLocationID  removeAllObjects];
        [self.arrayLocationImage removeAllObjects];
        [self.arrayLocationName removeAllObjects];
        [self.arrayMiles removeAllObjects];
        [self.arrayPrice removeAllObjects];
        [self.arrayStatus removeAllObjects];
        [self.arraySenderID removeAllObjects];
        [self.arraySenderName  removeAllObjects];
        [self.arrayCoupanNumber  removeAllObjects];
        [self.arrayLongitude  removeAllObjects];
        [self.arrayLatitude  removeAllObjects];
        
        //[self performSelector:@selector(callReceivedData) withObject:nil afterDelay:2.0];
    }
    else if (selectedSegment==1 || selectedSegment==2){
        if(selectedSegment==1){
            isSent=NO;
            
            [self.arrayTransactionsID1 removeAllObjects];
            [self.arrayLocationID1  removeAllObjects];
            [self.arrayLocationImage1 removeAllObjects];
            [self.arrayLocationName1 removeAllObjects];
            [self.arrayMiles1 removeAllObjects];
            [self.arrayPrice1 removeAllObjects];
            [self.arrayStatus1 removeAllObjects];
            [self.arraySenderID1 removeAllObjects];
            [self.arraySenderName1  removeAllObjects];
            [self.arrayLongitude1  removeAllObjects];
            [self.arrayLatitude1  removeAllObjects];

        }
        else{
            isUsed=NO;
            
            [self.arrayTransactionsID2 removeAllObjects];
            [self.arrayLocationID2  removeAllObjects];
            [self.arrayLocationImage2  removeAllObjects];
            [self.arrayLocationName2  removeAllObjects];
            [self.arrayMiles2  removeAllObjects];
            [self.arrayPrice2  removeAllObjects];
            [self.arrayStatus2  removeAllObjects];
            [self.arraySenderID2  removeAllObjects];
            [self.arraySenderName2  removeAllObjects];
            [self.arraySayThanks2  removeAllObjects];
            [self.arrayLongitude2  removeAllObjects];
            [self.arrayLatitude2  removeAllObjects];

        }
    }
   [self segmentControlChanged];
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:objTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:5.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
 //   NSLog(@"didFailWithError: %@", error);
    [self stopLoading];
    [locationManager stopUpdatingLocation]; 
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error!" message:@"Failed to Get Your Location. Please Turn on your device location services." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES]; 
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
 //   NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    currentLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    currentLong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    
 //   NSLog(@"strLat : %@",currentLat);
 //   NSLog(@"strLat : %@",currentLong);
    
    isLatLong  = YES;
    
    // Reverse Geocoding
 //   NSLog(@"Resolving the Address");
     
}

-(void)openPopView:(NSString*)receNo{
    @try {
        lblReceCode.text = receNo;
        popView.hidden = NO;
        popView.frame = CGRectMake(0, 0, 320, 580);
        [appDelegate.window addSubview:popView];
        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)btnEmail_click{
    
    
    MFMailComposeViewController *composer=[[MFMailComposeViewController alloc]init];
    [composer setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail]) {
        [composer setToRecipients:[NSArray arrayWithObjects:@"support@heres2uapp.com", nil]];
       
        [composer setSubject:[NSString stringWithFormat:@"complaint from : %@",resName]];
        
        if(selectedSegment==1){
            NSMutableString *messageBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
       //     NSLog(@"arrayTransactionsID : %@",self.arrayTransactionsID);
            [messageBody appendString:[NSString stringWithFormat:@"Transaction Id: %@</br>",[arrayTransactionsID1 objectAtIndex:selectedRow]]];
            [messageBody appendString:[NSString stringWithFormat:@"Sender Name: %@</br>",[arraySenderName1 objectAtIndex:selectedRow]]];
            [messageBody appendString:[NSString stringWithFormat:@"Receiver Name: %@</br>",[NSGlobalConfiguration getConfigurationItem:@"FullName"]]];
            [messageBody appendString:[NSString stringWithFormat:@"Location : %@</br>",[arrayLocationName1 objectAtIndex:selectedRow]]];
            [messageBody appendString:[NSString stringWithFormat:@"Amount: %@\n",[arrayPrice1 objectAtIndex:selectedRow]]];
           // [messageBody appendString:[NSString stringWithFormat:@"Coupon Code: %@\n",[arrayCoupanNumber objectAtIndex:selectedRow]]];
            [messageBody appendString:@"</body></html>"];
            [composer setMessageBody:messageBody isHTML:YES];
        }
        [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:composer animated:YES completion:nil];
    }
    else {
   //     NSLog(@"controller cannot send mail");
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error)
    {
     //   NSLog(@"error:%@",error);
    }
    
    if (result == MFMailComposeResultSent)
    {
        [self showAlertMessage:@"Message was queued in outbox. Will send if/when connected to email" withTitle:@"Email Sent"];
    }
    else if (result == MFMailComposeErrorCodeSendFailed || result == MFMailComposeResultFailed)
    {
        [self showAlertMessage:@"" withTitle:@"message sending failed"];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(IBAction)btnClose_Click:(id)sender{
    @try {
        popView.hidden  = TRUE;
        [popView removeFromSuperview];
    }
    @catch (NSException *exception) {
        
    }
}



#pragma Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count;
    
   // NSLog(@"sortedLocations : %@",sortedLocations);
    
    if(selectedSegment==0){
        count = [self.arrayTransactionsID count];
    }
    else if(selectedSegment==1){
        count = [self.arrayTransactionsID1 count];
    }
    else if(selectedSegment==2){
        count = [self.arrayTransactionsID2 count];
    }
    
    else{
        count = 0;
    }
 //   NSLog(@"count : %d",count);
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = nil;
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            /*
             self.arrayLocationID = [dicReceived valueForKey:@"LocationID"];
             self.arrayLocationImage = [dicReceived valueForKey:@"LocationImage"];
             self.arrayLocationName = [dicReceived valueForKey:@"LocationName"];
             self.arrayMiles = [dicReceived valueForKey:@"Miles"];
             self.arrayPrice = [dicReceived valueForKey:@"Price"];
             self.arrayStatus = [dicReceived valueForKey:@"Status"];
             self.arraySenderID = [dicReceived valueForKey:@"senderId"];
             self.arraySenderName  = [dicReceived valueForKey:@"senderName"];
             */
            
            NSString *strImageUrl;
            if(selectedSegment==0 && self.arrayLocationImage.count>0){
                strImageUrl = [NSString stringWithFormat:@"%@%@",hostURl,[self.arrayLocationImage objectAtIndex:indexPath.row]];
            }
            else if(selectedSegment==1 && self.arrayLocationImage1.count>0){
           //     NSLog(@"self.arrayLocationImage1 : %@",self.arrayLocationImage1);
                strImageUrl = [NSString stringWithFormat:@"%@%@",hostURl,[self.arrayLocationImage1 objectAtIndex:indexPath.row]];
            }
            else if(selectedSegment==2 && self.arrayLocationImage2.count>0){
                strImageUrl = [NSString stringWithFormat:@"%@%@",hostURl,[self.arrayLocationImage2 objectAtIndex:indexPath.row]];
            }
                       
            ImageViewLoading *imgView = [[ImageViewLoading alloc] initWithFrame:CGRectMake(5, 0, 80, 80) ImageUrl:strImageUrl];
            [cell addSubview:imgView];
            
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(92, 0, 200, 30)];
            if(selectedSegment==0 && self.arrayLocationName.count>0){
                [lblTitle setText:[NSString stringWithFormat:@"%@",[self.arrayLocationName objectAtIndex:indexPath.row]]];
            }
            else if(selectedSegment==1 && self.arrayLocationName1.count>0){
                [lblTitle setText:[NSString stringWithFormat:@"%@",[self.arrayLocationName1 objectAtIndex:indexPath.row]]];
            }
            else if(selectedSegment==2 && self.arrayLocationName2.count>0){
                [lblTitle setText:[NSString stringWithFormat:@"%@",[self.arrayLocationName2 objectAtIndex:indexPath.row]]];
            }
            [lblTitle setBackgroundColor:[UIColor clearColor]];
            [lblTitle setTextColor:[UIColor blackColor]];
            [lblTitle setFont:[UIFont boldSystemFontOfSize:13.0]];
            [lblTitle setTextAlignment:NSTextAlignmentLeft];
            [lblTitle setNumberOfLines:2.0];
            [cell addSubview:lblTitle];
            
           NSString *locationLong;
            NSString *locationLat;
            if(selectedSegment==0 && self.arrayLatitude.count>0){
                locationLong = [NSString stringWithFormat:@"%@",[self.arrayLongitude objectAtIndex:indexPath.row]];
                locationLat = [NSString stringWithFormat:@"%@",[self.arrayLatitude objectAtIndex:indexPath.row]];
            }
            else if(selectedSegment==1 && self.arrayLatitude1.count>0){
                locationLong = [NSString stringWithFormat:@"%@",[self.arrayLongitude1 objectAtIndex:indexPath.row]];
                locationLat = [NSString stringWithFormat:@"%@",[self.arrayLatitude1 objectAtIndex:indexPath.row]];
            }
             else if(selectedSegment==2 && self.arrayLatitude2.count>0){
                 locationLong = [NSString stringWithFormat:@"%@",[self.arrayLongitude2 objectAtIndex:indexPath.row]];
                 locationLat = [NSString stringWithFormat:@"%@",[self.arrayLatitude2 objectAtIndex:indexPath.row]];
            }
            
       //     NSLog(@"Lat :%@,  Long:%@",locationLat,locationLong);
            
            //Haversine formala for calculating distance in miles between two long/lat coordinates
            float dLongRadians = fabsf(([locationLong floatValue] - currentLocation.coordinate.longitude) * 3.141596 / 180);
            float dlatRadians = fabsf(([locationLat floatValue] - currentLocation.coordinate.latitude) * 3.141596 / 180);
            
            float lat1 = [locationLat floatValue] * 3.141596/180;
            float lat2 = currentLocation.coordinate.latitude * 3.141596 / 180;
            //
            float a = sinf(dlatRadians/2) * sinf(dlatRadians/2) + sinf(dLongRadians/2) * sinf(dLongRadians/2) * cosf(lat1) * cosf(lat2);
            float c = 2 * atan2f(sqrtf(a), sqrtf((1-a)));
            float distanceFromLocation = c * 3959;
        //    NSLog(@"distanceFromLocation :%f",distanceFromLocation);
            
            
            UILabel *lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(250, 6, 65, 21)];
            if(selectedSegment==0 && self.arrayMiles.count>0){
                [lblDistance setText:[NSString stringWithFormat:@"%i mi",(int)distanceFromLocation]];
            }
            else if(selectedSegment==1 && self.arrayMiles1.count>0){
                [lblDistance setText:[NSString stringWithFormat:@"%i mi",(int)distanceFromLocation]];
            }
            else if(selectedSegment==2 && self.arrayMiles2.count>0){
                [lblDistance setText:[NSString stringWithFormat:@"%i mi",(int)distanceFromLocation]];
            }
            [lblDistance setBackgroundColor:[UIColor clearColor]];
            [lblDistance setTextColor:[UIColor redColor]];
            [lblDistance setTextAlignment:NSTextAlignmentRight];
            [lblDistance setNumberOfLines:1.0];
            [lblDistance setFont:[UIFont boldSystemFontOfSize:12.0]];
            [cell addSubview:lblDistance];
            
            UILabel *lblPersonName = [[UILabel alloc] initWithFrame:CGRectMake(93, 25, 218, 21)];
            if(selectedSegment==0 && self.arraySenderName.count>0){
                [lblPersonName setText:[NSString stringWithFormat:@"%@",[self.arraySenderName objectAtIndex:indexPath.row]]];
            }
            else if(selectedSegment==1 && self.arraySenderName1.count>0){
                [lblPersonName setText:[NSString stringWithFormat:@"%@",[self.arraySenderName1 objectAtIndex:indexPath.row]]];
            }
            else if(selectedSegment==2 && self.arraySenderName2.count>0){
                [lblPersonName setText:[NSString stringWithFormat:@"%@",[self.arraySenderName2 objectAtIndex:indexPath.row]]];
            }
            [lblPersonName setBackgroundColor:[UIColor clearColor]];
            [lblPersonName setTextColor:[UIColor darkGrayColor]];
            [lblPersonName setTextAlignment:NSTextAlignmentLeft];
            [lblPersonName setFont:[UIFont systemFontOfSize:10.0]];
            [cell addSubview:lblPersonName];
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, 50, 310, 30)];
            //bottomView.layer.cornerRadius = 5.0;
            bottomView.clipsToBounds = YES;
            //bottomView.layer.borderColor = [UIColor blackColor].CGColor;
            //bottomView.layer.borderWidth = 2.0;
            bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dot-green.png"]];
            bottomView.alpha = 0.7;
            [cell addSubview:bottomView];
            
            UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 150, 30)];
            if(selectedSegment==0 && self.arrayPrice.count>0){
                [lblPrice setText:[NSString stringWithFormat:@"$%@",[self.arrayPrice objectAtIndex:indexPath.row]]];
            }
            else if(selectedSegment==1 && self.arrayPrice1.count>0){
                [lblPrice setText:[NSString stringWithFormat:@"$%@",[self.arrayPrice1 objectAtIndex:indexPath.row]]];
            }
            else if(selectedSegment==2 && self.arrayPrice2.count>0){
                [lblPrice setText:[NSString stringWithFormat:@"$%@",[self.arrayPrice2 objectAtIndex:indexPath.row]]];
            }
            [lblPrice setBackgroundColor:[UIColor clearColor]];
            [lblPrice setTextColor:[UIColor whiteColor]];
            [lblPrice setFont:[UIFont boldSystemFontOfSize:15.0]];
            [bottomView addSubview:lblPrice];
            
            
            UIButton *btnUseOrSent = [UIButton buttonWithType:UIButtonTypeCustom];
            btnUseOrSent.frame = CGRectMake(150, 2, 150, 30);
            btnUseOrSent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [btnUseOrSent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnUseOrSent.tag = indexPath.row;
            btnUseOrSent.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
            if(selectedSegment==0){
                [btnUseOrSent setTitle:@"USE" forState:UIControlStateNormal];
                [btnUseOrSent addTarget:self action:@selector(callAlertViewPopup1:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if(selectedSegment==1){
                [btnUseOrSent setTitle:@"SENT" forState:UIControlStateNormal];
                [btnUseOrSent addTarget:self action:@selector(callAlertViewPopup2:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else if(selectedSegment==2){
                NSString *strSayThanks = [NSString stringWithFormat:@"%@",[self.arraySayThanks2 objectAtIndex:indexPath.row]];
                NSString *btnTitle;
                if([strSayThanks isEqualToString:@"0"]){
                    btnTitle = @"Say Thanks.";
                    btnUseOrSent.enabled = true;
                }
                else{
                    btnTitle = @"THANKS SENT!";
                    btnUseOrSent.enabled = false;
                }
                [btnUseOrSent setTitle:btnTitle forState:UIControlStateNormal];
                [btnUseOrSent addTarget:self action:@selector(callAlertViewPopup3:) forControlEvents:UIControlEventTouchUpInside];
            }
            [bottomView addSubview:btnUseOrSent];
            
        }
        return cell;
    }
    @catch (NSException *exception) {
     //   NSLog(@"NSException : %@",exception);
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


-(void)callAlertViewPopup1:(UIButton*)sender{
    @try {
       // NSLog(@"%d",sender.tag);
        selectedRow = sender.tag;
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"USE GIFT",@"Navigate Here",@"Say Thanks",@"File a Complaint", nil];
        alert1.tag=1;
        [alert1 show];
        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)callAlertViewPopup2:(UIButton*)sender{
    @try {
    //    NSLog(@"%d",sender.tag);
        selectedRow = sender.tag;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"RECEIPT",@"File a Complaint", nil];
        alert.tag=2;
        [alert show];
        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)callAlertViewPopup3:(UIButton*)sender{
    @try {
     //   NSLog(@"%d",sender.tag);
        selectedRow = sender.tag;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Say Thanks",@"File a Complaint", nil];
        alert.tag=3;
        [alert show];
    }
    @catch (NSException *exception) {
        
    }
}


///http://50.62.148.155:8080/heres2u/api/addtransactionrequest.php?sendingUserID=24&receivingUserID=33&chargeAmount=5.5&creditTransID=1&locationID=1

//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    @try {
  //      NSLog(@"btnIndex : %d",buttonIndex);
        
        if(alertView.tag==1){
            if(buttonIndex==1){
                //arrayCoupanNumber
                NSString *coupancode = [NSString stringWithFormat:@"%@",[self.arrayCoupanNumber objectAtIndex:selectedRow]];
                [self openPopView:coupancode];
            }
            else if(buttonIndex==2){
                NSString *myLatLong = [NSString stringWithFormat:@"%@",[self.arrayLongitude objectAtIndex:selectedRow]];
                NSString *latlong = [NSString stringWithFormat:@"%@",[self.arrayLatitude objectAtIndex:selectedRow]];
          //      NSLog(@"lat : %@ , Long : %@",latlong,myLatLong);
                
                CGFloat sysVers = [UIDevice currentDevice].systemVersion.floatValue;
                NSString* hostName = (sysVers < 6.0) ? @"maps.google.com" : @"maps.apple.com";
        //        NSLog(@"hostName : %@",hostName);
                NSString* url = [NSString stringWithFormat: @"http://%@/maps?saddr=Current+Location&daddr=%@,%@",hostName,latlong,myLatLong];
                
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
            }
            else if(buttonIndex==3){
                int checkThanksID = [[self.arraySayThanksReceived objectAtIndex:selectedRow] integerValue];
            //    NSLog(@"checkThanksID : %d",checkThanksID);
                if(checkThanksID==1){
                    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Message Already Sent!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
                else{
                    [self performSelector:@selector(sayThanks) withObject:self afterDelay:0.5];
                }
            }
            else if(buttonIndex==4){
                resName = [NSString stringWithFormat:@"%@",[self.arrayLocationName objectAtIndex:selectedRow]];
                [self btnEmail_click];
            }
        }
        else if(alertView.tag==2){
            if(buttonIndex==1){
                ReceiptViewController *reciptViewController = [[ReceiptViewController alloc] initWithNibName:@"ReceiptViewController" bundle:nil];
          
                NSMutableArray *receData = [[NSMutableArray alloc] init];
                [receData addObject:[self.arrayTransactionsID1 objectAtIndex:selectedRow]];
                [receData addObject:[NSGlobalConfiguration getConfigurationItem:@"FullName"]];
             //   NSLog(@"arraySenderName1 : %@",arraySenderName1);
                [receData addObject:[self.arraySenderName1 objectAtIndex:selectedRow]];
                [receData addObject:[self.arrayLocationName1 objectAtIndex:selectedRow]];
                [receData addObject:[self.arrayPrice1 objectAtIndex:selectedRow]];
                
                reciptViewController.arrayData = [receData mutableCopy];
                [self.navigationController pushViewController:reciptViewController animated:YES];
            }
            else if(buttonIndex==2){
                if(selectedSegment==0){
                    resName = [NSString stringWithFormat:@"%@",[self.arrayLocationName objectAtIndex:selectedRow]];
                }
                else if(selectedSegment==1){
                    resName = [NSString stringWithFormat:@"%@",[self.arrayLocationName1 objectAtIndex:selectedRow]];
                }
                else if (selectedSegment==2){
                    resName = [NSString stringWithFormat:@"%@",[self.arrayLocationName2 objectAtIndex:selectedRow]];
                }
                [self btnEmail_click];
            }
        }
        else if(alertView.tag==3){
            if(buttonIndex==1){
                [self performSelector:@selector(sayThanks) withObject:self afterDelay:0.5];
                               
            }
            else if(buttonIndex==2){
                if(selectedSegment==0){
                    resName = [NSString stringWithFormat:@"%@",[self.arrayLocationName objectAtIndex:selectedRow]];
                }
                else if(selectedSegment==1){
                    resName = [NSString stringWithFormat:@"%@",[self.arrayLocationName1 objectAtIndex:selectedRow]];
                }
                else if (selectedSegment==2){
                    resName = [NSString stringWithFormat:@"%@",[self.arrayLocationName2 objectAtIndex:selectedRow]];
                }
                [self btnEmail_click];
            }
        }
        else if(alertView.tag==4){
            if(selectedSegment==0){
                isReceived = NO;
                [self.arrayTransactionsID removeAllObjects];
                [self.arrayLocationID  removeAllObjects];
                [self.arrayLocationImage  removeAllObjects];
                [self.arrayLocationName  removeAllObjects];
                [self.arrayMiles  removeAllObjects];
                [self.arrayPrice  removeAllObjects];
                [self.arrayStatus  removeAllObjects];
                [self.arraySenderID  removeAllObjects];
                [self.arraySenderName  removeAllObjects];
                [self.arrayLongitude  removeAllObjects];
                [self.arrayLatitude  removeAllObjects];
                [self.arraySayThanksReceived removeAllObjects];
            }
            else{
                isUsed = NO;
                [self.arrayTransactionsID2 removeAllObjects];
                [self.arrayLocationID2  removeAllObjects];
                [self.arrayLocationImage2  removeAllObjects];
                [self.arrayLocationName2  removeAllObjects];
                [self.arrayMiles2  removeAllObjects];
                [self.arrayPrice2  removeAllObjects];
                [self.arrayStatus2  removeAllObjects];
                [self.arraySenderID2  removeAllObjects];
                [self.arraySenderName2  removeAllObjects];
                [self.arraySayThanks2  removeAllObjects];
                [self.arrayLongitude2  removeAllObjects];
                [self.arrayLatitude2  removeAllObjects];
            }
            
            [self performSelector:@selector(segmentControlChanged) withObject:self afterDelay:0.5];
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)sayThanks{
    @try {
     //   NSLog(@"self.arrayTransactionsID2 : %@",self.arrayTransactionsID2);
     //   NSLog(@"selectedRow: %d",selectedRow);
        
        [self startLoading];
        int strTransactionId;
        if(selectedSegment==0){
            strTransactionId = [[NSString stringWithFormat:@"%@",[self.arrayTransactionsID objectAtIndex:selectedRow]] integerValue];
        }
        else{
            strTransactionId = [[NSString stringWithFormat:@"%@",[self.arrayTransactionsID2 objectAtIndex:selectedRow]] integerValue];
        }
    //    NSLog(@"strTransactionId : %d",strTransactionId);
        //http://50.62.148.155:8080/heres2u/api/saythanks.php?TransactionID=1
        
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@saythanks.php?TransactionID=%d",hostURl,strTransactionId]];
        
        //http://50.62.148.155:8080/heres2u/api/dummy.php
        //                NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://50.62.148.155:8080/heres2u/api/dummy.php"]];
    //    NSLog(@"url : %@",url);
        sayThanksXML = [[SayThanksXML alloc] initWithURL:url];
        
        //                /[dicSayThanks setValue:arraySayThanks forKey:@"SayThanksId"];
        NSArray *arrayCount = [dicSayThanks valueForKey:@"SayThanksId"];
    //    NSLog(@"%@",arrayCount);
        int thanksId = [[arrayCount objectAtIndex:0] integerValue];
    //    NSLog(@"%d",thanksId);
        
        
        NSString *msg;
        if(thanksId==0){
            msg = @"Thanks not sent";
        }
        else if(thanksId==1){
            msg = @"Thanks sent Successfully";
        }
        else{
            msg = @"Something Wrong!";
        }
        [self stopLoading];
        
        UIAlertView *alertThanks = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        if(thanksId==1){
            alertThanks.tag=4;
            alertThanks.delegate = self;
        }
        [alertThanks show];

    }
    @catch (NSException *exception) {
        
    }
}

-(void)dealloc
{
    [locationManager stopUpdatingLocation]; 
}

-(void)viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized){
    [locationManager startUpdatingLocation];
    }
}
@end
