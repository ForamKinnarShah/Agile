//
//  NSTaggedURLConnection.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/25/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "NSTaggedURLConnection.h"

@implementation NSTaggedURLConnection
@synthesize Data,tag,CallBackDelegate;
-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate{
    self=[super initWithRequest:request delegate:delegate];
    if(self){
        Data=[[NSMutableData alloc] init];
        self.didCallBegin=NO;
    }
    return self;
}
-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately{
    self=[super initWithRequest:request delegate:delegate startImmediately:startImmediately];
    if(self){
        Data=[[NSMutableData alloc] init];
    }
    return self;
}
@end
