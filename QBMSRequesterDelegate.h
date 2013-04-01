//
//  QBMSRequesterDelegate.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/27/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QBMSRequesterDelegate <NSObject>

-(void)QBMSRequesterDelegateFinishedWithCode:(NSString*)code;
-(void)QBMSRequesterDelegateFailedWithError:(NSError*)error;


@end
