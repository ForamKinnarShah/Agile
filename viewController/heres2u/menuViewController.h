//
//  menuViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menuViewController : UIViewController <UITextFieldDelegate>
{
    NSMutableArray *selectedItems;
    NSMutableArray *selectedIndices; 
    NSArray *menu; 
}

@property IBOutlet UISegmentedControl *segmentedControl;
@property IBOutlet UILabel *lowPricelbl;
@property IBOutlet UILabel *medPricelbl;
@property IBOutlet UILabel *highPricelbl; 
@property IBOutlet UITextField *enterPriceTxtField; 
@property IBOutlet UIButton *button1;
@property IBOutlet UIButton *button2;
@property IBOutlet UIButton *button3;
@property IBOutlet UILabel *followeeName;
@property NSString *followeeNametxt; 
@property IBOutlet UIImageView *followeePic;
@property UIImage *followeePicImg; 
@property IBOutlet UILabel *restaurantName; 
@property NSMutableDictionary *userInfo;
@property NSDictionary *restaurantInfo; 
@property IBOutlet UILabel *timeLabel; 
@property NSString *timeLabelText; 

// button action
- (IBAction)bg_clicked:(id)sender;

@end
