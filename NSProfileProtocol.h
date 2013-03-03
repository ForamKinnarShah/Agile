//
//  NSProfileProtocol.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/15/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSProfile;
@protocol NSProfileProtocol <NSObject>
@optional
-(void) ProfileLoadingCompleted:(NSProfile *)profile;
-(void) ProfileLoadingFailedWithError:(NSError *)error;
@end
