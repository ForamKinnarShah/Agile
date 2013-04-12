//
//  NSSearchForUser.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 1/9/13.
//  Copyright (c) 2013 CSUS. All rights reserved.
//

#import "NSSearchForUser.h"

@implementation NSSearchForUser
@synthesize Delegate;
-(void)findUsersWhosNameStartsWith:(NSString *)searchString WhoAreNotBeingFollowedBy:(NSInteger) UserID{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=searchforuser",[NSGlobalConfiguration URL]]];
    NSMutableData *PostData=[[NSMutableData alloc] init];
    NSString *Boundary=@"--------342543dsffgfdsg";
    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"SearchString\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[searchString dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i", UserID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPBody:PostData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    RawData=[[NSMutableData alloc] init];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    }
-(NSInteger) count{
    return [Data count];
}
-(NSMutableDictionary *)dataAtIndex:(NSInteger)index{
    return [Data objectAtIndex:index];
}
-(NSMutableArray *)getAllData{
    return [Data copy];
}
//Delegates:
//Connection Delegates:
-(BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSURLCredential *Credential=[[NSURLCredential alloc] initWithTrust:[challenge.protectionSpace serverTrust]];
    [challenge.sender useCredential:Credential forAuthenticationChallenge:challenge];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [RawData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    SEL ErrorSelector=@selector(searchforuser:FailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate searchforuser:self FailedWithError:error];
    }

}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    Data=[[NSMutableArray alloc] init];
    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:RawData];
    [parser setDelegate:self];
    [parser parse];
}
//XML Delegates:
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"User"]) {
        [Data addObject:attributeDict];
    }else{
        if ([elementName isEqualToString:@"ServerReply"]) {
            FoundError=YES;
        }
    }
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(FoundError){
        NSMutableDictionary *ErrorDetails=[[NSMutableDictionary alloc] init];
        [ErrorDetails setValue:string forKey:NSLocalizedDescriptionKey];
        NSError *Error=[[NSError alloc] initWithDomain:@"UserSearchAPI" code:100 userInfo:ErrorDetails];
        SEL ErrorSelector=@selector(searchforuser:FailedWithError:);
        if([Delegate respondsToSelector:ErrorSelector]){
            [Delegate searchforuser:self FailedWithError:Error];
        }
        [parser abortParsing];
    }
}
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    SEL ErrorSelector=@selector(searchforuser:FailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate searchforuser:self FailedWithError:parseError];
    }

}
-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    SEL ErrorSelector=@selector(searchforuser:FailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate searchforuser:self FailedWithError:validationError];
    }

}
-(void) parserDidEndDocument:(NSXMLParser *)parser{
    if([Data count]>0){
        //Success
        SEL SuccessSelector=@selector(searchforuserFoundUsers:);
        if([Delegate respondsToSelector:SuccessSelector]){
            [Delegate searchforuserFoundUsers:self];
        }
    }else{
        //No Data
        SEL EmptySelector=@selector(searchforuserDidNotFindAnyUsers:);
        if([Delegate respondsToSelector:EmptySelector]){
            [Delegate searchforuserDidNotFindAnyUsers:self];
        }
    }
}
@end
