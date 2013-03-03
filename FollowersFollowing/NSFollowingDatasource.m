//
//  NSFollowingDatasource.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 1/7/13.
//  Copyright (c) 2013 CSUS. All rights reserved.
//

#import "NSFollowingDatasource.h"

@implementation NSFollowingDatasource

@synthesize userID,Delegate;
-(id) init{
    self=[super init];
    if(self){
       // Data=[[NSMutableArray alloc] init];
        //RawData=[[NSMutableData alloc] init];
    }
    return self;
}
-(void) loadData{
    Data=[[NSMutableArray alloc] init];
    RawData=[[NSMutableData alloc] init];
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=getfollowees",[NSGlobalConfiguration URL]]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    NSMutableData *PostData=[[NSMutableData alloc] init];
    NSString *Boundary=@"------32423dsf345235";
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",userID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:PostData];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}
-(NSInteger) count{
    return [Data count];
}
-(NSDictionary *)dataAtIndex:(NSInteger)index{
    return (NSDictionary *)[Data objectAtIndex:index];
}
-(NSMutableArray *)getAllData{
    return [Data copy];
}
//Delegates:
//Connection Delegates:
-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSURLCredential *Credential=[[NSURLCredential alloc] initWithTrust:[challenge protectionSpace].serverTrust];
    [challenge.sender useCredential:Credential forAuthenticationChallenge:challenge];
}
-(BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [RawData appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //Do the XMLParsing
    // NSLog([[NSString alloc] initWithData:RawData encoding:NSUTF8StringEncoding]);
    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:RawData];
    [parser setDelegate:self];
    [parser parse];
    ErrorDetected=NO;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    SEL ErrorSelector=@selector(followingdatasource:FailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate followingdatasource:self FailedWithError:error];
    }
    
}
//XMLParser Delegates:
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"ServerReply"]){
        ErrorDetected=YES;
    }else{
        if([elementName isEqualToString:@"Followee"]){
            [Data addObject:attributeDict];
        }
    }
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(ErrorDetected){
        NSMutableDictionary *ErrorDictionary=[[NSMutableDictionary alloc] init];
        [ErrorDictionary setValue:string forKey:NSLocalizedDescriptionKey];
        NSError *error=[[NSError alloc] initWithDomain:@"FollowingAPI" code:200 userInfo:ErrorDictionary];
        SEL ErrorSelector=@selector(followersdatasource:FailedWithError:);
        if([Delegate respondsToSelector:ErrorSelector]){
            [Delegate followingdatasource:self FailedWithError:error];
            [parser abortParsing];
        }
        
    }
}
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    SEL ErrorSelector=@selector(followersdatasource:FailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate followingdatasource:self FailedWithError:parseError];
        [parser abortParsing];
    }
    
}
-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    SEL ErrorSelector=@selector(followersdatasource:FailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate followingdatasource:self FailedWithError:validationError];
    }
}
-(void) parserDidEndDocument:(NSXMLParser *)parser{
    SEL CompletionSelector=@selector(followersdatasourceFinishedLoading:);
    if([Delegate respondsToSelector:CompletionSelector]){
        [Delegate followingdatasourceFinishedLoading:self];
    }
}
@end

