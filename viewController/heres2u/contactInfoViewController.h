//
//  contactInfoViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/26/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contactInfoViewController : UIViewController <UITextFieldDelegate>

{
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *phoneTextField; 
}
@property (nonatomic, strong) IBOutlet UITableView *tblContactInfo;

@end