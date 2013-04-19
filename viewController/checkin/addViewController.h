//
//  addViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface addViewController : UIViewController

{
    IBOutletCollection(UITextField)NSArray * collection;
}

-(IBAction)submitClicked:(id)sender;

@end
