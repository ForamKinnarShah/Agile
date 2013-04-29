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
    
float preFeeTotal = drinkTotal + foodTotal + dessertTotal;
    float feeTotal;
    NSLog(@"prefeetotal:%f",preFeeTotal); 
    feeTotal = 1.36;
    
float totalTotal = preFeeTotal + feeTotal;

drinkTotalLbl.text = [NSString stringWithFormat:@"$%.2f",drinkTotal];
foodTotalLbl.text = [NSString stringWithFormat:@"$%.2f",foodTotal];
dessertTotalLbl.text = [NSString stringWithFormat:@"$%.2f",dessertTotal];
feeTotalLbl.text = [NSString stringWithFormat:@"$%.2f",feeTotal];
totalTotalLbl.text = [NSString stringWithFormat:@"$%.2f",totalTotal];

    NSMutableArray *creditCards = [NSGlobalConfiguration getConfigurationItem:[NSGlobalConfiguration getConfigurationItem:@"Email"]];
    
       
    if ([creditCards count] != 0)
    {
        NSMutableDictionary *creditCardInfo = [creditCards objectAtIndex:0];
        creditCardNumber = [creditCardInfo objectForKey:@"cardNumberLast4Digits"];
        NSString *cardType = [creditCardInfo objectForKey:@"cardType"];
        self.creditCardLbl.text = [NSString stringWithFormat:@"%@ %@",cardType,creditCardNumber];
    }
    else{
        NSLog(@"no cards found"); 
        self.creditCardLbl.text = @"";
        self.changeCardBtn.titleLabel.text = @"add Card"; 
//        [self.creditCardLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToCreditCardPage)]]; 
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToSend{
    sendViewController *send = [[sendViewController alloc] initWithNibName:@"sendViewController" bundle:nil];
    send.restaurantInfo = self.restaurantInfo; 
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
        NSString *walletID = [cards[0] objectForKey:@"walletID"];
        util = [[utilities alloc] init];
        [util startUIBlockerInView:self.view];
        
        QBMSRequester *qbms = [[QBMSRequester alloc] init];
        qbms.delegate = self;
        [qbms sendChargeRequestWithWalletID:walletID customerID:[NSGlobalConfiguration getConfigurationItem:@"ID"] forAmount:[totalTotalLbl.text substringFromIndex:1]];
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
    
    NSLog(@"http://50.62.148.155:8080/heres2u/api/addtransactionrequest.php?sendingUserID=%@&receivingUserID=%@&chargeAmount=%@&creditTransID=%@&locationID=%@",[NSGlobalConfiguration getConfigurationItem:@"ID"],[self.userInfo objectForKey:@"ID"],[totalTotalLbl.text substringFromIndex:1],code,[self.restaurantInfo objectForKey:@"ID"]);
    
    NSURL *request = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://50.62.148.155:8080/heres2u/api/addtransactionrequest.php?sendingUserID=%@&receivingUserID=%@&chargeAmount=%@&creditTransID=%@&locationID=%@",[NSGlobalConfiguration getConfigurationItem:@"ID"],[self.userInfo objectForKey:@"ID"],[totalTotalLbl.text substringFromIndex:1],code,[self.restaurantInfo objectForKey:@"ID"]]];
    
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

@end
