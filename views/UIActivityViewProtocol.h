//
//  UIActivityViewProtocol.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIActivityView;
@protocol UIActivityViewProtocol <NSObject>
@optional
-(void) activityviewRequestComment:(UIActivityView *) activity;
@end
