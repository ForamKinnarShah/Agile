//
//  orderItemView.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/25/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderItemView : UIView

@property IBOutlet UIImageView *image;
@property IBOutlet UILabel *restaurantNameLbl;
@property IBOutlet UIButton *senderNameBtn;
@property IBOutlet UILabel *itemNameLbl; 
@property id delegate;

@end
