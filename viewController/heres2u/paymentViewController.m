//
//  paymentViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "paymentViewController.h"
#import "sendViewController.h"
#import "orderItem.h" 
#import "NSGlobalConfiguration.h" 
#import "creditCardInfoViewController.h"
#import "QBMSRequester.h"
#import "utilities.h" 


@interface paymentViewController ()

@end

@implementation paymentViewController

@synthesize drinkTotalLbl, foodTotalLbl, dessertTotalLbl, totalTotalLbl, feeTotalLbl;

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
    [(UIScrollView*)self.view setContentSize:self.view.bounds.size];

    // Do any additional setup after loading the view from its nib.
    NSString *centerImageName = @"logo_small.png";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];

    float drinkTotal;
    float foodTotal;
    float dessertTotal;
    
    for (orderItem *item in self.orderItems)
    {
        NSLog(@"itemName:%@, price:%f, type:%i",item.name, item.price, item.itemType); 
        
        if (item.itemType == food)
        {
            foodTotal = foodTotal + item.price; 
        }
        else if (item.itemType == drink)
        {
            drinkTotal = drinkTotal + item.price;
        }
        else if (item.itemType == dessert)
        {
            dessertTotal = dessertTotal + item.price; 
        }
    }
    
    if (!self.additionalGiftAmount)
    {
        self.additionalGiftAmount = 0; 
    }
    
    foodTotal = foodTotal + self.additionalGiftAmount; 
    
    preFeeTotal = drinkTotal + foodTotal + dessertTotal;
    float feeTotal;
    feeTotal = 1.36;
    
totalTotal = preFeeTotal + feeTotal;
    NSLog(@"totalTotal:%f",totalTotal);

drinkTotalLbl.text = [NSString stringWithFormat:@"$%.2f",drinkTotal];
foodTotalLbl.text = [NSString stringWithFormat:@"$%.2f",foodTotal];
dessertTotalLbl.text = [NSString stringWithFormat:@"$%.2f",dessertTotal];
feeTotalLbl.text = [NSString stringWithFormat:@"$%.2f",feeTotal];
totalTotalLbl.text = [NSString stringWithFormat:@"$%.2f",totalTotal];

    NSMutableArray *creditCards = [NSGlobalConfiguration getConfigurationItem:[NSGlobalConfiguration getConfigurationItem:@"Email"]];
    
       
    if ([creditCards count] != 0)
    {
        NSLog(@"credit Cards:%@",creditCards);
        
        NSMutableDictionary *creditCardInfo = [creditCards lastObject];
        creditCardNumber = [creditCardInfo objectForKey:@"cardNumberLast4Digits"];
        NSString *cardType = [creditCardInfo objectForKey:@"cardType"];
        _arrItemValueList = [[NSMutableArray alloc] init];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"$%.2f",drinkTotal]];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"$%.2f",foodTotal]];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"$%.2f",dessertTotal]];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"$%.2f",feeTotal]];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"$%.2f",totalTotal]];
        //[_arrItemValueList addObject:@"visa 1111"];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"%@ %@",cardType,creditCardNumber]];
        
        self.creditCardLbl.text = [NSString stringWithFormat:@"%@ %@",cardType,creditCardNumber];
    }
    else{
        NSLog(@"no cards found"); 
        self.creditCardLbl.text = @"";
        self.changeCardBtn.titleLabel.text = @"add Card";
        _arrItemValueList = [[NSMutableArray alloc] init];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"$%.2f",drinkTotal]];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"$%.2f",foodTotal]];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"$%.2f",dessertTotal]];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"$%.2f",feeTotal]];
        [_arrItemValueList addObject:[NSString stringWithFormat:@"$%.2f",totalTotal]];
        //[_arrItemValueList addObject:@"visa 1111"];
        [_arrItemValueList addObject:[NSString stringWithFormat:@""]];
//        [self.creditCardLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToCreditCardPage)]]; 
    }
    
    // assign array for item purchase
    _arrItemList = [[NSMutableArray alloc] initWithObjects:@"Drinks",@"Food",@"Dessert",@"Fees",@"Total",@"Payment Method",nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToSend{
    sendViewController *send = [[sendViewController alloc] initWithNibName:@"sendViewController" bundle:nil];
    send.restaurantInfo = self.restaurantInfo;
    send.strRecieverName = [NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"FullName"]];
    [self.navigationController pushViewController:send animated:YES];
}

-(IBAction)goToCreditCardPage:(id)sender
{
    creditCardInfoViewController *credit = [[creditCardInfoViewController alloc] initWithNibName:@"creditCardInfoViewController" bundle:nil];
    [self.navigationController pushViewController:credit animated:YES]; 
}

-(IBAction)clickedAccept:(id)sender
{
    //temp
   // NSMutableDictionary *creditCard = [NSGlobalConfiguration getConfigurationItem:@"creditCard"];
    NSMutableArray *cards = [NSGlobalConfiguration getConfigurationItem:[NSGlobalConfiguration getConfigurationItem:@"Email"]]; 
    //NSString *walletID = [NSGlobalConfiguration getConfigurationItem:@"walletID"];
    if (!cards)
    {
        [[[UIAlertView alloc] initWithTitle:@"no cards found" message:@"please add a credit card first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return; 
    }
        else
            {
                NSString *walletID = [[cards lastObject ]objectForKey:@"walletID"];
        util = [[utilities alloc] init];
        [util startUIBlockerInView:self.view];
        
        QBMSRequester *qbms = [[QBMSRequester alloc] init];
        qbms.delegate = self;
        [qbms sendChargeRequestWithWalletID:walletID customerID:[NSGlobalConfiguration getConfigurationItem:@"ID"] forAmount:[NSString stringWithFormat:@"%.2f",totalTotal]];
    }
    //creditCardNumber = @"4111111111111111";
    //[creditCard setObject:creditCardNumber forKey:@"cardNumber"];
    
    
    //[qbms sendChargeRequest:creditCard forAmount:[totalTotalLbl.text substringFromIndex:1]];
    
}

-(void)QBMSRequesterDelegateFinishedWithCode:(NSString*)code
{
    [util stopUIBlockerInView:self.view]; 
    NSLog(@"credit card transaction id:%@",code);
    [[[UIAlertView alloc] initWithTitle:@"credit card authorization succeeded:" message:@"A receipt has been emailed to you."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
       
    NSURL *request = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://50.62.148.155:8080/heres2u/api/addtransactionrequest.php?sendingUserID=%@&receivingUserID=%@&chargeAmount=%@&creditTransID=%@&locationID=%@",[NSGlobalConfiguration getConfigurationItem:@"ID"],[self.userInfo objectForKey:@"ID"],[NSString stringWithFormat:@"%.2f",preFeeTotal],code,[self.restaurantInfo objectForKey:@"ID"]]];
    
    NSLog(@"request:%@",request); 
    
   NSString *Items=[[NSString alloc] initWithContentsOfURL:request encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Items:%@",Items);
    
//    phpCaller *php = [[phpCaller alloc] init];
//    [php invokeWebService:@"ui" forAction:@"addTransactionRequest" withParameters:[NSMutableArray arrayWithObjects:[NSGlobalConfiguration getConfigurationItem:@"ID"],[self.userInfo objectForKey:@"ID"],[totalTotalLbl.text substringFromIndex:1],code,[self.restaurantInfo objectForKey:@"ID"],nil]];
    [self goToSend];
    
}

-(void)QBMSRequesterDelegateFailedWithError:(NSError*)error
{
    [util stopUIBlockerInView:self.view]; 
    [[[UIAlertView alloc] initWithTitle:@"credit card authorization failed:" message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show]; 
}

-(void) phpCallerFailed:(NSError *)error
{
    [util stopUIBlockerInView:self.view];
    [[[UIAlertView alloc] initWithTitle:@"add Transaction failed:" message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

-(void) phpCallerFinished:(NSMutableArray*)returnData
{
    [util stopUIBlockerInView:self.view];
}

#pragma mark
#pragma mark tableview methods

// datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  6;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (Cell == nil)
    {
        Cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [Cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
        _lblItemList = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 24)];
        [_lblItemList setBackgroundColor:[UIColor clearColor]];
        [_lblItemList setTextColor:[UIColor blackColor]];
        [_lblItemList setFont:[UIFont systemFontOfSize:14]];
        _lblItemList.tag = 10;
        [_lblItemList setTextAlignment:NSTextAlignmentLeft];
        [Cell.contentView addSubview:_lblItemList];
        
        _lblItemValueList = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 170, 24)];
        [_lblItemValueList setBackgroundColor:[UIColor clearColor]];
        [_lblItemValueList setTextColor:[UIColor blueColor]];
        [_lblItemValueList setFont:[UIFont systemFontOfSize:14]];
        _lblItemValueList.tag = 20;
        [_lblItemValueList setTextAlignment:NSTextAlignmentRight];
        [Cell.contentView addSubview:_lblItemValueList];
    }
    else
    {
        _lblItemList = (UILabel *)[Cell.contentView viewWithTag:10];
        _lblItemValueList = (UILabel *)[Cell.contentView viewWithTag:20];
    }
    
    [_lblItemList setText:[NSString stringWithFormat:@"%@ :",[_arrItemList objectAtIndex:indexPath.row]]];
    [_lblItemValueList setText:[NSString stringWithFormat:@"%@",[_arrItemValueList objectAtIndex:indexPath.row]]];
  
    return Cell;
}


@end
