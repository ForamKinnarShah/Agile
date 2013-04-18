//
//  NSUserAccessControl.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/25/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSTaggedURLConnection.h"
#import "NSTaggedXMLParser.h"
#import "NSUserAccessControlProtocol.h"
@interface NSUserAccessControl : NSObject<NSXMLParserDelegate,NSURLConnectionDataDelegate>

+(void) RegisterUser:(NSString *)email Password:(NSString *)password ProfilePicture:(UIImage *)profilepicture Phone:(NSString *)phone DateOfBirth:(NSString *)dob Name:(NSString *)name ZipCode:(NSString *)zip CallBackDelegate:(id)Delegate;
+(void) Login:(NSString *)email Password:(NSString *)password Delegate:(id) Delegate;
+(void) LostPassword:(NSString *)email Delegate:(id) Delegate;

@end
//NSTaggedURLConnection *RegisterConnection;
//typedef enum NSInteger NSUserAccessControlRequestType;
typedef enum {
    NSUserAccessControlTypeRegisterUser=1,
    NSUserAccessControlTypeLoginUser=2
} NSUserAccessControlRequestType;