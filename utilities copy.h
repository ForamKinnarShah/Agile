//
//  utilities.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/27/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface utilities : NSObject


@property UIActivityIndicatorView *UIBlocker;

-(void)startUIBlockerInView:(UIView*)view; 
-(void)stopUIBlockerInView:(UIView*)view; 
+(void)showAlertWithTitle:(NSString*)title Message:(NSString*)message; 

@end
