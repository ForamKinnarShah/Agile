//
//  NSUserAccessControl.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/25/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "NSUserAccessControl.h"
#import "NSGlobalConfiguration.h"
@implementation NSUserAccessControl
+(void) RegisterUser:(NSString *)email Password:(NSString *)password ProfilePicture:(UIImage *)profilepicture  Phone:(NSString *)phone DateOfBirth:(NSString *)dob Name:(NSString *)name ZipCode:(NSString *)zip CallBackDelegate:(id)Delegate{
    NSLog(@"Registering");
    NSLog(@"Date of Birth: %@",dob);
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/?webservice=uac&action=register",[NSGlobalConfiguration URL]]];

    NSURL *URL = [NSURL URLWithString:@""];
    NSMutableURLRequest *Request=[[NSMutableURLRequest alloc] initWithURL:URL];
    [Request setHTTPMethod:@"POST"];
    NSMutableData *PostData=[[NSMutableData alloc] init];
    NSString *Boundary=@"-----11211211311NNNN";
    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    if(profilepicture){
        //NSLog(@"We have a picture!");
        NSData *ImageData= UIImageJPEGRepresentation(profilepicture, 0.25);
        [PostData appendData:[@"\r\nContent-Disposition:form-data; name=\"ProfilePicture\"; filename=\"Img.jpg\"\r\nContent-Type:ImageFile\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [PostData appendData:[NSData dataWithData:ImageData]];
        [PostData appendData:[@"\r\n--"dataUsingEncoding:NSUTF8StringEncoding]];
        [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"Password\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"Email\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[email dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"Phone\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding] ];
    [PostData appendData:[phone dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"Name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"DOB\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[dob dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"ZipCode\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[zip dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [Request setHTTPBody:PostData];
    [Request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [Request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    NSTaggedURLConnection *Connection=[[NSTaggedURLConnection alloc]initWithRequest:Request delegate:self];
    [Connection setTag:NSUserAccessControlTypeRegisterUser];
    [Connection setCallBackDelegate:Delegate];
}
+(void) Login:(NSString *)email Password:(NSString *)password Delegate:(id) Delegate{
    NSMutableData *POSTData=[[NSMutableData alloc] init];
    NSString *Boundary=@"-------435543efdg43r32efdtwe465464";
    [POSTData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\nContent-Disposition:form-data;name=\"email\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[email dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\nContent-Disposition:form-data;name=\"password\"\r\n\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=login",[NSGlobalConfiguration URL]]];
    NSMutableURLRequest *Request=[[NSMutableURLRequest alloc] initWithURL:URL];
    [Request setHTTPBody:POSTData];
    [Request setHTTPMethod:@"POST"];
    [Request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [Request setValue:[NSString stringWithFormat:@"%i",[POSTData length]] forHTTPHeaderField:@"Content-Length"];
    NSTaggedURLConnection *Connection=[[NSTaggedURLConnection alloc] initWithRequest:Request delegate:self];
    [Connection setCallBackDelegate:Delegate];
    [Connection setTag:NSUserAccessControlTypeLoginUser];
}
+(void) connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    NSTaggedURLConnection *taggedconnection=(NSTaggedURLConnection *)connection;
    if([taggedconnection tag]==NSUserAccessControlTypeRegisterUser){
    SEL startIndication=@selector(registrationDidBegin:);
    if ([taggedconnection.CallBackDelegate respondsToSelector:startIndication] && ![taggedconnection didCallBegin]) {
        [taggedconnection.CallBackDelegate registrationDidBegin:taggedconnection];
        taggedconnection.didCallBegin=YES;
    }
    }else{
        
    }
}
+(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSTaggedURLConnection *taggedconnection=(NSTaggedURLConnection *)connection;
    [taggedconnection.Data appendData:data];
  //  NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
   // NSLog(@"Current Length:%i",[taggedconnection.Data length]);
}
+(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //Return an Error;
    NSTaggedURLConnection *taggedconnection=(NSTaggedURLConnection *)connection;
    if([taggedconnection tag]==NSUserAccessControlTypeRegisterUser){
        SEL selError=@selector(registrationDidFail:);
        if([taggedconnection.CallBackDelegate respondsToSelector:selError]){
            [taggedconnection.CallBackDelegate registrationDidFail:error];
        }
    }else{
        SEL selError=@selector(loggingInFailed:);
        if([taggedconnection.CallBackDelegate respondsToSelector:selError]){
            [taggedconnection.CallBackDelegate loggingInFailed:error];
        }
    }
}
+(void)connectionDidFinishLoading:(NSURLConnection *)connection{
   // NSLog(@"Finished Loading");
     //Init XMLParser
    NSTaggedURLConnection *taggedconnection=(NSTaggedURLConnection *)connection;
   // NSLog(@"Reply:%@",[[NSString alloc] initWithData:[taggedconnection Data] encoding:NSUTF8StringEncoding]);
    //NSLog(@"%i",[taggedconnection tag]);
   //NSLog(<#id, ...#>)
    NSTaggedXMLParser *parser=[[NSTaggedXMLParser alloc] initWithData:[taggedconnection Data]];
    [parser setDelegate:self];
    [parser setTag:[taggedconnection tag]];
    [parser setCallBackDelegate:[taggedconnection CallBackDelegate]];
    [parser parse];
}
+(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSURLCredential *credential=[[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
}
+(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust];
}
+(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    NSTaggedXMLParser *taggedparser=(NSTaggedXMLParser *)parser;
    [taggedparser setLastTag:elementName];
}
+(void) parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"Done Parsing");
    //IF it's login then login has succeeded
    NSTaggedXMLParser   *TaggedParser=parser;
    if ([TaggedParser Tag]==NSUserAccessControlTypeLoginUser) {
        SEL successSelector=@selector(loggingInSucceeded:);
        if ([TaggedParser.CallBackDelegate respondsToSelector:successSelector]) {
            [TaggedParser.CallBackDelegate loggingInSucceeded:@"Successfully Logged In"];
        }
    }
}
+(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
   // NSLog(@"Found Chars: %@",string);
    NSTaggedXMLParser *taggedparser=(NSTaggedXMLParser *)parser;
    if([taggedparser.lastTag isEqualToString:@"ServerReply"]){
        //Address errors
        NSMutableDictionary *errorInformation=[[NSMutableDictionary alloc] init];
        [errorInformation setObject:string forKey:NSLocalizedDescriptionKey];
        NSError *error=[[NSError alloc] initWithDomain:@"APIError" code:200 userInfo:errorInformation];
        SEL errorSelector;
        if([taggedparser Tag]==NSUserAccessControlTypeRegisterUser){
            errorSelector=@selector(registrationDidFail:);
            if([taggedparser.CallBackDelegate respondsToSelector:errorSelector]){
                [taggedparser.CallBackDelegate registrationDidFail:error];
            }
        }else{
            errorSelector=@selector(loggingInFailed:);
            if([taggedparser.CallBackDelegate respondsToSelector:errorSelector]){
                [taggedparser.CallBackDelegate loggingInFailed:error];
            }
        }
        [parser abortParsing];
    }else{
        if([taggedparser.lastTag isEqualToString:@"SuccessMessage"]){
            SEL successSelector=@selector(registrationDidSucceed:);
            if([taggedparser.CallBackDelegate respondsToSelector:successSelector]){
                [taggedparser.CallBackDelegate registrationDidSucceed:string];
            }
            [parser abortParsing];
        }else{
            if([taggedparser Tag]==NSUserAccessControlTypeLoginUser){
                if(![string isEqualToString:@""] && ![string isEqualToString:@"\n"]){
                    NSLog(@"Saving %@ as %@",string,[taggedparser lastTag]);
                    [NSGlobalConfiguration setConfigurationItem:[taggedparser lastTag] Item:string];
                }
            }
        }

    }
}
+(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    NSTaggedXMLParser *taggedparser=(NSTaggedXMLParser *)parser;
    if([taggedparser Tag]==NSUserAccessControlTypeRegisterUser){
        SEL error=@selector(registrationDidFail:);
        if([taggedparser.CallBackDelegate respondsToSelector:error]){
            [taggedparser.CallBackDelegate registrationDidFail:validationError];
        }
    }else{
        SEL error=@selector(loggingInFailed:);
        if([taggedparser.CallBackDelegate respondsToSelector:error]){
            [taggedparser.CallBackDelegate loggingInFailed:validationError];
        }

    }
}
+(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSTaggedXMLParser *taggedparser=(NSTaggedXMLParser *)parser;
    if([taggedparser Tag]==NSUserAccessControlTypeRegisterUser){
        SEL error=@selector(registrationDidFail:);
        if([taggedparser.CallBackDelegate respondsToSelector:error]){
            [taggedparser.CallBackDelegate registrationDidFail:parseError];
        }
    }else{
        SEL error=@selector(loggingInFailed:);
        if([taggedparser.CallBackDelegate respondsToSelector:error]){
            [taggedparser.CallBackDelegate loggingInFailed:parseError];
        }

    }
}
@end
