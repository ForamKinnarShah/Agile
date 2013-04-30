//
//  NSFeedManager.m
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "NSFeedManager.h"

@implementation NSFeedManager
@synthesize Delegate, Feeds;
-(NSInteger) count{
    return [Feeds count];
}
-(NSDictionary *)getFeedAtIndex:(NSInteger)index{
    return [Feeds objectAtIndex:index];
}
-(void) getFeeds{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=getfeeds&userid=%@", [NSGlobalConfiguration URL],[NSGlobalConfiguration getConfigurationItem:@"ID"]]];
    NSLog(@"URL : %@",URL);
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:URL];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    RawData=[[NSMutableData alloc] init];
  //  Feeds=[[NSM]]
    [connection start];
}
//Delegates
//Connection Delegates
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [RawData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    SEL ErrorSelector=@selector(feedmanagerFailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate feedmanagerFailedWithError:error];
    }
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //XML PARSER:
    encounteredServerReply=NO;
    Feeds=[[NSMutableArray alloc] init];
    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:RawData];
    [parser setDelegate:self];
    [parser parse];
}
//XML Parser
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([[elementName lowercaseString] isEqualToString:@"activity"]){
        [Feeds addObject:attributeDict];
    }else{
        if([[elementName lowercaseString] isEqualToString:@"serverreply"]){
            encounteredServerReply=YES;
        }
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(encounteredServerReply){
        //Throw Error
        [parser abortParsing];
    }
}
-(void) parserDidEndDocument:(NSXMLParser *)parser{
    SEL CompetionSelector=@selector(feedmanagerCompleted:);
    if([Delegate respondsToSelector:CompetionSelector]){
        [Delegate feedmanagerCompleted:self];
    }
}
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    SEL ErrorSelector=@selector(feedmanagerFailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate feedmanagerFailedWithError:parseError];
    }
    [parser abortParsing];
}
-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    SEL ErrorSelector=@selector(feedmanagerFailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate feedmanagerFailedWithError:validationError];
    }
    [parser abortParsing];
}
@end
