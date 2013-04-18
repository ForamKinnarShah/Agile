//
//  LostPasswordVC.h
//  HERES2U
//
//  Created by agilepc-103 on 4/18/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSUserAccessControl.h"

@interface LostPasswordVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)Submit:(id)sender;

@end
