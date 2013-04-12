//
//  phpCaller.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/25/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "phpCallerDelegate.h"

@interface phpCaller : NSObject <NSURLConnectionDataDelegate, NSXMLParserDelegate>

{
    NSDictionary *inputsDictionary;
    NSDictionary *outputsDictionary;
    NSString *selectedActionName;
}
@property NSMutableData *rawData;
@property id delegate;
@property NSMutableArray *returnData; 
@property BOOL encounteredServerReply; 


-(BOOL) invokeWebService:(NSString*)webService forAction:(NSString*)action withParameters:(NSMutableArray*)parameters;

@end
