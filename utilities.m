//
//  utilities.m
//  HERES2U
//
//  Created by Paul Sukhanov on 3/27/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "utilities.h"

@implementation utilities

@synthesize UIBlocker;

-(void)startUIBlockerInView:(UIView*)view {
UIBlocker=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
[UIBlocker setFrame:[view frame]];
[UIBlocker setBackgroundColor:[UIColor grayColor]];
[UIBlocker setAlpha:0.8];
[UIBlocker setHidesWhenStopped:YES];
[view addSubview:UIBlocker];
[UIBlocker startAnimating];
}

-(void)stopUIBlockerInView:(UIView*)view {
    [UIBlocker stopAnimating];
    [UIBlocker removeFromSuperview]; 
}

+(void)showAlertWithTitle:(NSString*)title Message:(NSString*)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show]; 
}

@end
