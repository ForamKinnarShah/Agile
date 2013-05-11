//
//  paymentViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBMSRequesterDelegate.h" 
#import "utilities.h" 
#import "phpCaller.h"
#import "phpCallerDelegate.h" 

@interface paymentViewController : UIViewController <QBMSRequesterDelegate, phpCallerDelegate>
{
    NSString *creditCardNumber;
    utilities *util;
    float totalTotal;
    float preFeeTotal; 
}

@property NSArray *orderItems;
@property IBOutlet UILabel *drinkTotalLbl;
@property IBOutlet UILabel *foodTotalLbl;
@property IBOutlet UILabel *dessertTotalLbl;
@property IBOutlet UILabel *feeTotalLbl; 
@property IBOutlet UILabel *totalTotalLbl;
@property IBOutlet UILabel *creditCardLbl; 
@property IBOutlet UIButton *changeCardBtn;
@property NSMutableDictionary *userInfo; 
@property NSDictionary *restaurantInfo; 
@property float additionalGiftAmount; 

@property (nonatomic, strong) IBOutlet UITableView *tblPayment;
@property (nonatomic, strong) UILabel *lblItemList,*lblItemValueList;
@property (nonatomic, strong) NSMutableArray *arrItemList,*arrItemValueList;

-(IBAction)goToCreditCardPage:(id)sender;
-(IBAction)clickedAccept:(id)sender; 

@end
