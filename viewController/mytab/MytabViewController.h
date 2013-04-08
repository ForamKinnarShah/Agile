//
//  MytabViewController.h
//  HERES2U
//
//  Created by Paul Amador on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "phpCallerDelegate.h"
#import "phpCaller.h" 
#import "utilities.h" 

@interface MytabViewController : UIViewController <UITabBarControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate, phpCallerDelegate>
{
    UISegmentedControl IBOutlet *segmented;
}
@property phpCaller *caller;
@property utilities *util;
@property NSMutableArray *receivedItems;
@property NSMutableArray *sentItems;
@property NSMutableArray *usedItems; 
@property IBOutlet UIButton *defaultBtn;

@end
