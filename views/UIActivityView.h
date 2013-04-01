//
//  UIActivityView.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/8/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIActivityViewProtocol.h"
@interface UIActivityView : UIView
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UIImageView *ProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *UserName;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet UIButton *btnBuy;
@property (nonatomic) NSInteger ID;
@property (strong,nonatomic) id Delegate;

-(IBAction)buyWasClicked:(id)sender;

@end
