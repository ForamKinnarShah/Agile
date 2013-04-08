//
//  Heres2uViewController.h
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "phpCaller.h"
#import "heres2uitemdelegate.h"  

@interface Heres2uViewController : UIViewController <UITabBarControllerDelegate,UINavigationControllerDelegate, phpCallerDelegate, heres2uitemdelegate>

@property NSMutableArray *friendItems; 
@property UIActivityIndicatorView *UIBlocker;

-(IBAction)search:(id)sender;

@end
