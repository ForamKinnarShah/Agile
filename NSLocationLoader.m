//
//  NSLocationLoader.m
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/15/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "NSLocationLoader.h"

@implementation NSLocationLoader
@synthesize Delegate;
-(id)init{
    self=[super init];
    if(self){
        
        
    }
    return self;
}
-(void) downloadLocations{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=getlocations",[NSGlobalConfiguration URL]]];
    NSLog(@"URL : %@",URL);
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:URL];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    RawData=[[NSMutableData alloc] init];
    Items=[[NSMutableArray alloc] init];
    [connection start];
}
-(NSInteger) count{
    return [Items count];
}
-(NSDictionary *)getLocationAtIndex:(NSInteger)index{
    return [Items objectAtIndex:index];
}
//Delegates
//Connection Delegates
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [RawData appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //Initialize Parser
    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:RawData];
    [parser setDelegate:self];
    [parser parse];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    SEL ErrorSelector=@selector(locationloaderFailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate locationloaderFailedWithError:error];
    }
}
//XML Parser Delegates
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([[elementName lowercaseString] isEqualToString:@"serverreply"]){
        ShouldThrowError=YES;
    }else{
        if([[elementName lowercaseString] isEqualToString:@"location"]){
            [Items addObject:attributeDict];
        }
    }
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(ShouldThrowError){
        NSMutableDictionary *errorDict=[[NSMutableDictionary alloc] init];
        [errorDict setValue:string forKey:NSLocalizedDescriptionKey];
        NSError *error=[[NSError alloc] initWithDomain:@"Heres2u" code:201 userInfo:errorDict];
        SEL ErrorSelector=@selector(locationloaderFailedWithError:);
        if([Delegate respondsToSelector:ErrorSelector]){
            [Delegate locationloaderFailedWithError:error];
        }
        [parser abortParsing];
    }
}
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
}
-(void) parserDidEndDocument:(NSXMLParser *)parser{
    //Completion
    SEL CompletionSelector=@selector(locationloaderCompleted:);
    if([Delegate respondsToSelector:CompletionSelector]){
        [Delegate locationloaderCompleted:self];
    }
}
-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    SEL ErrorSelector=@selector(locationloaderFailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate locationloaderFailedWithError:validationError];
    }
}
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    SEL ErrorSelector=@selector(locationloaderFailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate locationloaderFailedWithError:parseError];
    }
    
}
@end
