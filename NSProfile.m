//
//  NSProfile.m
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/8/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "NSProfile.h"

@implementation NSProfile
@synthesize FullName,ImageURL,Followers,Following,canFollow,Delegate,ProfileID,Feeds;
-(id)initWithProfileID:(NSInteger)ID{
    self=[super init];
    if(self){
        ProfileID=ID;
    }
    return self;
}
-(void) setProfileID:(NSInteger)ID{
    ProfileID=ID;
    //Refetch;
    //[self startFetching];
}
//Private Functions:
-(void) startFetching{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=requestprofile", [NSGlobalConfiguration URL]]];
    NSMutableURLRequest *Request=[[NSMutableURLRequest alloc] initWithURL:URL];
    NSMutableData *POSTData=[[NSMutableData alloc]init];
    NSString *Boundary=@"--------dgrhyrt564dsagu";
    [POSTData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\nContent-Disposition:form-data;name=\"id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[[NSString stringWithFormat:@"%i", ProfileID] dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
     [POSTData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
   // NSLog([[NSString alloc] initWithData:POSTData encoding:NSUTF8StringEncoding]);
    [Request setHTTPBody:POSTData];
    [Request setHTTPMethod:@"post"];
    [Request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [Request setValue:[NSString stringWithFormat:@"%i",[POSTData length]] forHTTPHeaderField:@"Content-Length"];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:Request delegate:self];
    RawData=[[NSMutableData alloc] init];
    Feeds=[[NSMutableArray alloc] init];
    [connection start];
}
//Delegates
//Connection Delegates
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [RawData appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //Invoke Parser
    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:RawData];
    [parser setDelegate:self];
  //  NSLog([[NSString alloc] initWithData:RawData encoding:NSUTF8StringEncoding]);
    [parser parse];
    [connection cancel];
    connection=nil;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    SEL ErrorSelector=@selector(ProfileLoadingFailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate ProfileLoadingFailedWithError:error];
    }
}
//Parser Deletgates
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    CurrentString=@"";
    tempDict=attributeDict;
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    CurrentString=[NSString stringWithFormat:@"%@%@",CurrentString,string];
    CurrentString = [CurrentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([[elementName lowercaseString] isEqualToString:@"id"]){
        ProfileID=[CurrentString integerValue];
    }else{
        if ([[elementName lowercaseString] isEqualToString:@"fullname"]) {
            FullName=CurrentString;
        }else{
            if ([[elementName lowercaseString] isEqualToString:@"imageurl"]) {
                ImageURL=CurrentString;
            }else{
                if([[elementName lowercaseString] isEqualToString:@"canfollow"]){
                    canFollow=[CurrentString boolValue];
                }else{
                    if([[elementName lowercaseString]isEqualToString:@"usercomment"]){
                       // UserComment=CurrentString;
                    }else{
                        if([[elementName lowercaseString] isEqualToString:@"followers"]){
                            Followers=[CurrentString integerValue];
                        }else{
                            if([[elementName lowercaseString] isEqualToString:@"following"]){
                                Following=[CurrentString integerValue];
                            }else{
                                if([[elementName lowercaseString] isEqualToString:@"feed"]){
                                    NSLog(@"adding feed");
                                    [Feeds addObject:tempDict];
                                }else{
                                    if([[elementName lowercaseString] isEqualToString:@"serverreply"]){
                                        //Error Detected, Throw error.....
                                        NSMutableDictionary *ErrorDict=[[NSMutableDictionary alloc] init];
                                        [ErrorDict setValue:CurrentString forKey:NSLocalizedDescriptionKey];
                                        NSError *error=[[NSError alloc] initWithDomain:@"Heres2U" code:200 userInfo:ErrorDict];
                                        SEL ErrorSelector=@selector(ProfileLoadingFailedWithError:);
                                        if([Delegate respondsToSelector:ErrorSelector]){
                                            [Delegate ProfileLoadingFailedWithError:error];
                                            [parser abortParsing];
                                            RawData=nil;
                                            CurrentString=nil;
                                            tempDict=nil;
                                        }
                                    }
                                }
                            }
                        }
                    }
                        
                }
            }
        }
    }
}
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    SEL ErrorSelector=@selector(ProfileLoadingFailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate ProfileLoadingFailedWithError:parseError];
    }
    [parser abortParsing];
    parser=nil;
}
-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    SEL ErrorSelector=@selector(ProfileLoadingFailedWithError:);
    if([Delegate respondsToSelector:ErrorSelector]){
        [Delegate ProfileLoadingFailedWithError:validationError];
    }
    [parser abortParsing];
    parser=nil;
}
-(void) parserDidEndDocument:(NSXMLParser *)parser{
    //Send completion signal
    SEL CompletionSelector=@selector(ProfileLoadingCompleted:);
    if([Delegate respondsToSelector:CompletionSelector]){
        [Delegate ProfileLoadingCompleted:self];
    }
    [parser abortParsing];
    parser=nil;
}
@end
