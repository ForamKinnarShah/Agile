//
//  heres2uitemView.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/25/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface heres2uitemView : UIView

@property IBOutlet UIImageView *picture;
@property IBOutlet UILabel *name;
@property id delegate;

-(IBAction)giftAFriendPressed:(id)sender;
@end
