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

@protocol CheckinViewControllerDelegate;

@interface Heres2uViewController : UIViewController <UITabBarControllerDelegate,UINavigationControllerDelegate, phpCallerDelegate, heres2uitemdelegate>
{
    UIButton *defaultButton;
}
@property NSMutableArray *friendItems; 
@property UIActivityIndicatorView *UIBlocker;
@property NSDictionary *restaurantInfo; 
@property NSString *restaurantName; 
@property int senderNumber; 
@property UIImage *selectedImage; 

-(IBAction)search:(id)sender;
-(void)loadMenuView; 

@end

@protocol CheckinViewControllerDelegate <NSObject>

-(void)loadMenuView; 

@end