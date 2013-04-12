//
//  NSUserAccessControlProtocol.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/25/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSUserAccessControlProtocol <NSObject>
@optional
-(void) registrationDidBegin:(NSTaggedURLConnection *)connection;
-(void) registrationDidFail:(NSError *)error;
-(void)registrationDidSucceed:(NSString *)message;
-(void) loggingInDidBegin:(NSTaggedURLConnection *)connectio;
-(void) loggingInFailed:(NSError *)error;
-(void) loggingInSucceeded:(NSString *)message;
@end
