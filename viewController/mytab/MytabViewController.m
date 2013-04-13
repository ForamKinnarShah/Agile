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
@synthesize arrayData,arrayTransactionsID,arrayLocationID,arrayLocationImage,arrayLocationName,arrayMiles,arrayPrice,arraySenderID,arraySenderName,arrayStatus;
@synthesize arrayData1,arrayTransactionsID1,arrayLocationID1,arrayLocationImage1,arrayLocationName1,arrayMiles1,arrayPrice1,arraySenderID1,arraySenderName1,arrayStatus1;
@synthesize arrayData2,arrayTransactionsID2,arrayLocationID2,arrayLocationImage2,arrayLocationName2,arrayMiles2,arrayPrice2,arraySenderID2,arraySenderName2,arrayStatus2;

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
    
    [segmented addTarget:self action:@selector(segmentControlChanged) forControlEvents:UIControlEventValueChanged];

    caller = [[phpCaller alloc] init];
    caller.delegate = self;

    isSent = NO;
    isUsed = NO;
    
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
    
    
    
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"mytab_received" ofType:@"xml"];
//    NSURL *url = [[NSURL alloc] initFileURLWithPath:bundlePath];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://50.62.148.155:8080/heres2u/api/index.php?webservice=ui&action=getsentitems&ID=36&Page=1&Lat=-33.7501&Long=18.4533"];
    myparser = [[MyTabXmlParse alloc] initWithURL:url];
    
//    NSLog(@"arrayTransactionsID : %@",myparser.arrayTransactionsID);
//    self.arrayTransactionsID = myparser.arrayTransactionsID;
    //dictTransaction
    NSLog(@"dicReceived: %@",dicReceived);
    self.arrayLocationID = [dicReceived valueForKey:@"LocationID"];
    self.arrayLocationImage = [dicReceived valueForKey:@"LocationImage"];
    self.arrayLocationName = [dicReceived valueForKey:@"LocationName"];
    self.arrayMiles = [dicReceived valueForKey:@"Miles"];
    self.arrayPrice = [dicReceived valueForKey:@"Price"];
    self.arrayStatus = [dicReceived valueForKey:@"Status"];
    self.arraySenderID = [dicReceived valueForKey:@"senderId"];
    self.arraySenderName  = [dicReceived valueForKey:@"senderName"];
    [objTableView reloadData];

    
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

-(void)segmentControlChanged
{
    NSLog(@"[segmented selectedSegmentIndex] : %d",[segmented selectedSegmentIndex]);
    selectedSegment = [segmented selectedSegmentIndex];
    
    if ([segmented selectedSegmentIndex] == 0)
    {
       /* NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"mytab_received" ofType:@"xml"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:bundlePath];
       
        myparser = [[MyTabXmlParse alloc] initWithURL:url];

//        NSLog(@"arrayTransactionsID : %@",arrayTransactionsID);
//        self.arrayTransactionsID = myparser.arrayTransactionsID;
        
        //dictTransaction
        NSLog(@"dicReceived: %@",dicReceived);
       
        self.arrayLocationID = [dicReceived valueForKey:@"LocationID"];
        self.arrayLocationImage = [dicReceived valueForKey:@"LocationImage"];
        self.arrayLocationName = [dicReceived valueForKey:@"LocationName"];
        self.arrayMiles = [dicReceived valueForKey:@"Miles"];
        self.arrayPrice = [dicReceived valueForKey:@"Price"];
        self.arrayStatus = [dicReceived valueForKey:@"Status"];
        self.arraySenderID = [dicReceived valueForKey:@"senderId"];
        self.arraySenderName  = [dicReceived valueForKey:@"senderName"];
        
        
//        [util startUIBlockerInView:self.view]; 
//        [caller invokeWebService:@"ui" forAction:@"getReceivedItems" withParameters:[NSMutableArray arrayWithObject:[NSGlobalConfiguration getConfigurationItem:@"ID"]]];*/
    }
    else if ([segmented selectedSegmentIndex] == 1)
    {
        
        if(!isSent){
            isSent = YES;
//            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"mytab_sent" ofType:@"xml"];
//            NSURL *url = [[NSURL alloc] initFileURLWithPath:bundlePath];
            NSURL *url = [[NSURL alloc] initWithString:@"http://50.62.148.155:8080/heres2u/api/index.php?webservice=ui&action=getsentitems&ID=36&Page=1&Lat=-33.7501&Long=18.4533"];

            myTabSent = [[MyTabSent alloc] initWithURL:url];
            
            //        NSLog(@"arrayTransactionsID : %@",arrayTransactionsID);
            //        self.arrayTransactionsID = myparser.arrayTransactionsID;
            
            //dictTransaction
            NSLog(@"dicReceived: %@",dicSent);
            self.arrayLocationID1 = [dicSent valueForKey:@"LocationID"];
            self.arrayLocationImage1 = [dicSent valueForKey:@"LocationImage"];
            self.arrayLocationName1 = [dicSent valueForKey:@"LocationName"];
            self.arrayMiles1 = [dicSent valueForKey:@"Miles"];
            self.arrayPrice1 = [dicSent valueForKey:@"Price"];
            self.arrayStatus1 = [dicSent valueForKey:@"Status"];
            self.arraySenderID1 = [dicSent valueForKey:@"senderId"];
            self.arraySenderName1 = [dicSent valueForKey:@"senderName"];
        }
//        [util startUIBlockerInView:self.view];
//        [caller invokeWebService:@"ui" forAction:@"getSentItems" withParameters:[NSMutableArray arrayWithObject:[NSGlobalConfiguration getConfigurationItem:@"ID"]]];
    }
    if ([segmented selectedSegmentIndex] == 2)
    {
        if(!isUsed){
            isUsed = YES;
//            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"mytab_used" ofType:@"xml"];
//            NSURL *url = [[NSURL alloc] initFileURLWithPath:bundlePath];
            NSURL *url = [[NSURL alloc] initWithString:@"http://50.62.148.155:8080/heres2u/api/index.php?webservice=ui&action=getuseditems&ID=37&Page=1&Lat=-33.7501&Long=18.4533"];
            
            myTabUsed = [[MyTabUsed alloc] initWithURL:url];
            
            //        NSLog(@"arrayTransactionsID : %@",arrayTransactionsID);
            //        self.arrayTransactionsID = myparser.arrayTransactionsID;
            
            //dictTransaction
            NSLog(@"dicReceived: %@",dicUsed);
            self.arrayLocationID2 = [dicUsed valueForKey:@"LocationID"];
            self.arrayLocationImage2 = [dicUsed valueForKey:@"LocationImage"];
            self.arrayLocationName2 = [dicUsed valueForKey:@"LocationName"];
            self.arrayMiles2 = [dicUsed valueForKey:@"Miles"];
            self.arrayPrice2 = [dicUsed valueForKey:@"Price"];
            self.arrayStatus2 = [dicUsed valueForKey:@"Status"];
            self.arraySenderID2 = [dicUsed valueForKey:@"senderId"];
            self.arraySenderName2 = [dicUsed valueForKey:@"senderName"];
        }

//        [util startUIBlockerInView:self.view];
//        [caller invokeWebService:@"ui" forAction:@"getUsedItems" withParameters:[NSMutableArray arrayWithObject:[NSGlobalConfiguration getConfigurationItem:@"ID"]]];
    }
    [objTableView reloadData];
}

-(void) phpCallerFailed:(NSError *)error
{
    [utilities showAlertWithTitle:@"loading failed" Message:nil]; 
}

-(void) phpCallerFinished:(NSMutableArray*)returnData
{
    NSLog(@"phpCaller finished with items:%@",returnData); 
    
    if ([segmented selectedSegmentIndex] == 0)
    {
        receivedItems = returnData;
    }
    if ([receivedItems count] != 0)
    {
        [_defaultBtn setHidden:YES]; 
        [self loadActivitiesWithItems:receivedItems];
    }
}

-(void) loadActivitiesWithItems:(NSMutableArray*)items{
    //NSLog(@"Loading Activity");
    for(NSInteger i=0; i<[items count];i++){
        
        orderItemView *item=[[orderItemView alloc] initWithFrame:CGRectMake(0, (i*81)+40, 320, 81)];
        NSDictionary *ItemData=[items objectAtIndex:i];
        item.senderNameBtn.titleLabel.text = [ItemData objectForKey:@"sendUserNameFullName"];
        item.restaurantNameLbl.text = [ItemData objectForKey:@"restaurantName"];
        item.itemNameLbl.text = [NSString stringWithFormat:@"%@ %@",[ItemData objectForKey:@"itemPrice"],[ItemData objectForKey:@"itemName"]]; 
       // NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData valueForKey:@"ImageURL"]] ImageView:friend.picture];
        //[img start];
        [item setDelegate:self];
        [self.view addSubview:item];
        // NSLog(@"added");
    }
    [(UIScrollView *)self.view setScrollEnabled:YES];
    [(UIScrollView *)self.view setContentSize:CGSizeMake(320, ([items count]*85))];
    // NSLog(@"%i",([Profile.Feeds count]*166));
}


#pragma Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count;
    
    if(selectedSegment==0){
        count = [arrayLocationName count];
    }
    else if(selectedSegment==1){
        count = [arrayLocationName1 count];
    }
    else if(selectedSegment==2){
        count = [arrayLocationName2 count];
    }
    
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        if(selectedSegment==0){
            strImageUrl = [NSString stringWithFormat:@"%@",[self.arrayLocationImage objectAtIndex:indexPath.row]];
        }
        else if(selectedSegment==1){
            strImageUrl = [NSString stringWithFormat:@"%@",[self.arrayLocationImage1 objectAtIndex:indexPath.row]];
        }
        else if(selectedSegment==2){
            strImageUrl = [NSString stringWithFormat:@"%@",[self.arrayLocationImage2 objectAtIndex:indexPath.row]];
        }
        
        
        ImageViewLoading *imgView = [[ImageViewLoading alloc] initWithFrame:CGRectMake(5, 5, 70, 70) ImageUrl:strImageUrl];
        [cell addSubview:imgView];
        
        /*UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
//        [imageView setBackgroundColor:[UIColor redColor]];
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = [UIColor blackColor].CGColor;
        imageView.layer.borderWidth = 1.0;
        [cell addSubview:imageView];*/
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, 30)];
        if(selectedSegment==0){
            [lblTitle setText:[NSString stringWithFormat:@"%@",[self.arrayLocationName objectAtIndex:indexPath.row]]];
        }
        else if(selectedSegment==1){
            [lblTitle setText:[NSString stringWithFormat:@"%@",[self.arrayLocationName1 objectAtIndex:indexPath.row]]];
        }
        else if(selectedSegment==2){
            [lblTitle setText:[NSString stringWithFormat:@"%@",[self.arrayLocationName2 objectAtIndex:indexPath.row]]];
        }
        
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
        [cell addSubview:lblTitle];
        
        UILabel *lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(265, 0, 50, 30)];
        if(selectedSegment==0){
            [lblDistance setText:[NSString stringWithFormat:@"%@",[self.arrayMiles objectAtIndex:indexPath.row]]];
        }
        else if(selectedSegment==1){
            [lblDistance setText:[NSString stringWithFormat:@"%@",[self.arrayMiles1 objectAtIndex:indexPath.row]]];
        }
        else if(selectedSegment==2){
            [lblDistance setText:[NSString stringWithFormat:@"%@",[self.arrayMiles2 objectAtIndex:indexPath.row]]];
        }
        [lblDistance setBackgroundColor:[UIColor clearColor]];
        [lblDistance setTextColor:[UIColor blackColor]];
        [cell addSubview:lblDistance];
        
        UILabel *lblPersonName = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 200, 30)];
        if(selectedSegment==0){
            [lblPersonName setText:[NSString stringWithFormat:@"%@",[self.arraySenderName objectAtIndex:indexPath.row]]];
        }
        else if(selectedSegment==1){
            [lblPersonName setText:[NSString stringWithFormat:@"%@",[self.arraySenderName1 objectAtIndex:indexPath.row]]];
        }
        else if(selectedSegment==2){
            [lblPersonName setText:[NSString stringWithFormat:@"%@",[self.arraySenderName2 objectAtIndex:indexPath.row]]];
        }
        [lblPersonName setBackgroundColor:[UIColor clearColor]];
        [lblPersonName setTextColor:[UIColor blueColor]];
        [lblPersonName setFont:[UIFont systemFontOfSize:14.0]];
        [cell addSubview:lblPersonName];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, 50, 310, 32)];
        bottomView.layer.cornerRadius = 5.0;
        bottomView.clipsToBounds = YES;
        bottomView.layer.borderColor = [UIColor blackColor].CGColor;
        bottomView.layer.borderWidth = 2.0;
        [cell addSubview:bottomView];
        
        UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 150, 30)];
        if(selectedSegment==0){
            [lblPrice setText:[NSString stringWithFormat:@"%@",[self.arrayPrice objectAtIndex:indexPath.row]]];
        }
        else if(selectedSegment==1){
            [lblPrice setText:[NSString stringWithFormat:@"%@",[self.arrayPrice1 objectAtIndex:indexPath.row]]];
        }
        else if(selectedSegment==2){
            [lblPrice setText:[NSString stringWithFormat:@"%@",[self.arrayPrice2 objectAtIndex:indexPath.row]]];
        }
        [lblPrice setBackgroundColor:[UIColor clearColor]];
        [lblPrice setTextColor:[UIColor blackColor]];
        [lblPrice setFont:[UIFont systemFontOfSize:15.0]];
        [bottomView addSubview:lblPrice];
        
        
        UIButton *btnUseOrSent = [UIButton buttonWithType:UIButtonTypeCustom];
        btnUseOrSent.frame = CGRectMake(150, 2, 170, 30);
        btnUseOrSent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btnUseOrSent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnUseOrSent.tag = indexPath.row;
        if(selectedSegment==0){
            [btnUseOrSent setTitle:@"USE" forState:UIControlStateNormal];
            [btnUseOrSent addTarget:self action:@selector(callAlertViewPopup1:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(selectedSegment==1){
            [btnUseOrSent setTitle:@"SENT" forState:UIControlStateNormal];
            [btnUseOrSent addTarget:self action:@selector(callAlertViewPopup2:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if(selectedSegment==2){
            [btnUseOrSent setTitle:@"THANKS SENT!" forState:UIControlStateNormal];
            [btnUseOrSent addTarget:self action:@selector(callAlertViewPopup3:) forControlEvents:UIControlEventTouchUpInside];
        }
        [bottomView addSubview:btnUseOrSent];
        
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


-(void)callAlertViewPopup1:(UIButton*)sender{
    @try {
        NSLog(@"%d",sender.tag);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"USE GIFT",@"Say Thanks",@"Navigate Here",@"File a Complaint", nil];
        [alert show];
        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)callAlertViewPopup2:(UIButton*)sender{
    @try {
        NSLog(@"%d",sender.tag);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"USE GIFT",@"RECEIPT",@"File a Complaint", nil];
        [alert show];
        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)callAlertViewPopup3:(UIButton*)sender{
    @try {
        NSLog(@"%d",sender.tag);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Say Thanks",@"RECEIPT",@"File a Complaint", nil];
        [alert show];
        
    }
    @catch (NSException *exception) {
        
    }
}

@end
