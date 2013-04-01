//
//  phpCallerDelegateProtocol.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/25/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
@class phpCaller;
@protocol phpCallerDelegate <NSObject>
@optional
-(void) phpCallerFailed:(NSError *)error;
-(void) phpCallerFinished:(NSMutableArray*)returnData;
@end