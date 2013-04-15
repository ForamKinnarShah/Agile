//
//  addCreditCardViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 4/14/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addCreditCardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView *cardTable;
@property NSMutableArray *creditCards; 

@end
