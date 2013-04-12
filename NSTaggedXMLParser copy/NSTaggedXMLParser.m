//
//  NSTaggedXMLParser.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/25/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "NSTaggedXMLParser.h"

@implementation NSTaggedXMLParser
@synthesize Tag,CallBackDelegate,ParsedPairs,lastTag,currentCharacters;
-(id) initWithData:(NSData *)data{
    self=[super initWithData:data];
    if(self){
        ParsedPairs=[[NSMutableDictionary alloc] init];
        lastTag=@"";
        currentCharacters=@"";
    }
    return self;
}
@end
