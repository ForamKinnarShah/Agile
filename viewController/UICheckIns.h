//
//  UICheckIns.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/15/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICheckInsProtocol.h"
@interface UICheckIns : UIView
@property (strong, nonatomic) IBOutlet UILabel *Location;
@property (strong, nonatomic) IBOutlet UILabel *Distance;
@property (strong, nonatomic) IBOutlet UILabel *Name;
@property (strong, nonatomic) IBOutlet UIButton *CheckInButton;
@property (strong, nonatomic) IBOutlet UIImageView *Picture;
@property (nonatomic) NSInteger ID;
@property (strong,nonatomic) id Delegate;
@property IBOutlet UILabel *checkInLabel; 
@end
