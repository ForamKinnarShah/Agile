//
//  phpCaller.m
//  HERES2U
//
//  Created by Paul Sukhanov on 3/25/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "phpCaller.h"
#import "NSGlobalConfiguration.h" 

@implementation phpCaller

@synthesize rawData, returnData, delegate, encounteredServerReply;

-(id)init
{
    self = [super init];
    inputsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:
                     [NSArray arrayWithObjects:@"id",nil],@"requestprofile",
                     [NSArray arrayWithObjects:@"UserID", nil],@"getfollowees",
                     [NSArray arrayWithObjects:@"UserID", nil],@"getfollowers",
                     [NSArray arrayWithObjects:@"SearchString",@"UserID", nil],@"searchforusers",
                     [NSArray arrayWithObjects:@"CommenterID",@"FeedID",@"Comment", nil],@"addcomment",
                     [NSArray arrayWithObjects:@"UserID",@"FolloweeID",nil],@"followuser",
                     [NSArray arrayWithObjects:@"UserID",@"FolloweeID",nil],@"unfollowuser",
                     [NSArray arrayWithObjects:@"UserID",@"comment",@"locationID",nil],@"postfeed",
                     [NSArray arrayWithObjects:@"UserID",@"locationID",nil],@"checkin",
                     [NSArray arrayWithObjects:@"ID",nil],@"getReceivedItems",
                     [NSArray arrayWithObjects:@"ID",nil],@"getSentItems",
                     [NSArray arrayWithObjects:@"ID",nil],@"getUsedItems",
                     [NSArray arrayWithObjects:@"sendingUserID",@"receivingUserID",@"chargeAmount",@"creditTransID",@"locationID",nil],@"addTransactionRequest",nil];
    
    
    outputsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:
                       [NSArray arrayWithObjects:@"id",nil],@"requestprofile",
                       @"followee",@"getfollowees",
                       @"follower",@"getfollowers",
                       @"user",@"searchforusers",
                       [NSArray arrayWithObjects:@"CommenterID",@"FeedID",@"Comment", nil],@"addcomment",
                       [NSArray arrayWithObjects:@"UserID",@"FolloweeID",nil],@"followuser",
                       [NSArray arrayWithObjects:@"UserID",@"FolloweeID",nil],@"unfollowuser",
                       [NSArray arrayWithObjects:@"UserID",@"comment",@"locationID",nil],@"postfeed",
                       [NSArray arrayWithObjects:@"UserID",@"locationID",nil],@"checkin",
                       @"transaction",@"getReceivedItems",
                       [NSArray arrayWithObjects:@"UserID",nil],@"getSentItems",
                       [NSArray arrayWithObjects:@"UserID",nil],@"getUsedItems",
                       @"response",@"addTransactionRequest",nil];
    
                    return self;
}

//list of parameter names for actions

//generic method
-(BOOL) invokeWebService:(NSString*)webService forAction:(NSString*)action withParameters:(NSMutableArray*)parameters {
    selectedActionName = action; 
    NSLog(@"requested action:%@",action); 
    
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=%@&action=%@", [NSGlobalConfiguration URL],webService,action]];
    NSMutableURLRequest *Request=[[NSMutableURLRequest alloc] initWithURL:URL];
    NSMutableData *POSTData=[[NSMutableData alloc]init];
    NSString *Boundary=@"--------dgrhyrt564dsagu";
    
    NSArray *parameterNames = [inputsDictionary objectForKey:action];
    if (!parameterNames || [parameterNames count] == 0)
    {
        NSLog(@"no parameters found for requested action:%@",action); 
        return NO;
    }
    else if ([parameters count] != [parameterNames count])
    {
        NSLog(@"incorrect number of parameters for action:%@",action);
        return NO;
    }
    
    [POSTData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    for (int i =0; i< [parameters count]; i++)
    {
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[[NSString stringWithFormat:@"\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n",[parameterNames objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[[NSString stringWithFormat:@"%@", [parameters objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    }
        
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // NSLog([[NSString alloc] initWithData:POSTData encoding:NSUTF8StringEncoding]);
    [Request setHTTPBody:POSTData];
    [Request setHTTPMethod:@"post"];
    [Request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [Request setValue:[NSString stringWithFormat:@"%i",[POSTData length]] forHTTPHeaderField:@"Content-Length"];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:Request delegate:self];
    rawData=[[NSMutableData alloc] init];
    returnData=[[NSMutableArray alloc] init];
    [connection start];
    return YES; 
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [rawData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    SEL ErrorSelector=@selector(phpCallerFailedWithError:);
    if([delegate respondsToSelector:ErrorSelector]){
        [delegate phpCallerFailed:error];
    }
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //XML PARSER:
    NSLog(@"connection finished loading with response:%@",[[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding]); 
    encounteredServerReply=NO;
    returnData=[[NSMutableArray alloc] init];
    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:rawData];
    [parser setDelegate:self];
    [parser parse];
}
//XML Parser
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([[elementName lowercaseString] isEqualToString:@"serverReply"]){
        encounteredServerReply=YES;
    }
    else if ([[elementName lowercaseString] isEqualToString:[outputsDictionary objectForKey:selectedActionName]]){ //optionally, check if [outputDictionary objectForKey:selectedAction] matches elementName
        [returnData addObject:attributeDict]; 
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(encounteredServerReply){
        //Throw Error
        [parser abortParsing];
    }
}
-(void) parserDidEndDocument:(NSXMLParser *)parser{
    SEL CompletionSelector=@selector(phpCallerFinished:);
    if([delegate respondsToSelector:CompletionSelector]){
        [delegate phpCallerFinished:returnData];
    }
}
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    SEL ErrorSelector=@selector(phpCallerFailedWithError:);
    if([delegate respondsToSelector:ErrorSelector]){
        [delegate phpCallerFailed:parseError];
    }
    [parser abortParsing];
}
-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    SEL ErrorSelector=@selector(phpCallerFailedWithError:);
    if([delegate respondsToSelector:ErrorSelector]){
        [delegate phpCallerFailed:validationError];
    }
    [parser abortParsing];
}



//Abed methods
//get followees
//-(void) loadData{
//    Data=[[NSMutableArray alloc] init];
//    RawData=[[NSMutableData alloc] init];
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=getfollowees",[NSGlobalConfiguration URL]]];
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
//    NSMutableData *PostData=[[NSMutableData alloc] init];
//    NSString *Boundary=@"------32423dsf345235";
//    
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i",userID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:PostData];
//    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
//    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [connection start];
//}
//
//-(void) getFeeds{
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=getfeeds&userid=%@", [NSGlobalConfiguration URL],[NSGlobalConfiguration getConfigurationItem:@"ID"]]];
//    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:URL];
//    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
//    rawData=[[NSMutableData alloc] init];
//    //  Feeds=[[NSM]]
//    [connection start];
//}
////searchforuser
//-(void)findUsersWhosNameStartsWith:(NSString *)searchString WhoAreNotBeingFollowedBy:(NSInteger) UserID{
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=searchforuser",[NSGlobalConfiguration URL]]];
//    NSMutableData *PostData=[[NSMutableData alloc] init];
//    NSString *Boundary=@"--------342543dsffgfdsg";
//    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"SearchString\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[searchString dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i", UserID] dataUsingEncoding:NSUTF8StringEncoding]];[PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
//    [request setHTTPBody:PostData];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
//    RawData=[[NSMutableData alloc] init];
//    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [connection start];
//}
//
////won't work modularly
//-(void) getCommentsForFeed:(NSInteger)FeedID{
//    NSString *Items=[[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=getcomments&FeedID=%i",[NSGlobalConfiguration URL],FeedID]] encoding:NSUTF8StringEncoding error:nil];
//    // NSLog(Items);
//    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:[Items dataUsingEncoding:NSUTF8StringEncoding]];
//    [parser setDelegate:self];
//    Data=[[NSMutableArray alloc] init];
//    [parser parse];
//}
//
////userinteraction
//+(void) addComment:(NSInteger)CommenterID Comment:(NSString *)Comment FeedID:(NSInteger) FeedID CallbackDelegate:(id)Delegate{
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=addcomment",[NSGlobalConfiguration URL]]];
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
//    NSMutableData *PostData=[[NSMutableData alloc] init];
//    
//    NSString *Boundary=@"--------873jjhg3587hkjasfjg4";
//    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data; name=\"CommenterID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i",CommenterID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"FeedID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i",FeedID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"Comment\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Comment dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPBody:PostData];
//    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
//    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
//    [connection setCallBackDelegate:Delegate];
//    [connection start];
//}
//+(void) followUser:(NSInteger)UserID FolloweeID:(NSInteger)FolloweeID CallbackDelegate:(id)Delegate{
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=followuser",[NSGlobalConfiguration URL]]];
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
//    NSMutableData *PostData=[[NSMutableData alloc] init];
//    NSString *Boundary=@"---------34jkkjhkak342334";
//    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i", UserID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"FolloweeID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i",FolloweeID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPBody:PostData];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
//    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:	self];
//    [connection setCallBackDelegate:Delegate];
//    [connection start];
//}
//+(void)unfollowUser:(NSInteger)UserID FolloweeID:(NSInteger)FolloweeID CallbackDelegate:(id)Delegate{
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=unfollowuser",[NSGlobalConfiguration URL]]];
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
//    NSMutableData *PostData=[[NSMutableData alloc] init];
//    NSString *Boundary=@"-----jkjfhskjh943532453";
//    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i",UserID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"FolloweeID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i",FolloweeID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPBody:PostData];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
//    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
//    [connection setCallBackDelegate:Delegate];
//    [connection start];
//}
//+(void)stopUserFollow:(NSInteger)UserID FollowerID:(NSInteger)FollowerID CallbackDelegate:(id)Delegate{
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=stopuserfollow",[NSGlobalConfiguration URL]]];
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
//    NSMutableData *PostData=[[NSMutableData alloc] init];
//    NSString *Boundary=@"-----jkjfhskjh943532453";
//    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i",UserID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"FollowerID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i",FollowerID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPBody:PostData];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
//    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
//    [connection setCallBackDelegate:Delegate];
//    [connection start];
//}
//+(void) updateProfilePicture:(NSInteger) UserID NewPicture:(UIImage *) newpicture CallbackDelegate:(id)Delegate{
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=updateprofilepicture",[NSGlobalConfiguration URL]]];
//    NSMutableData *PostData=[[NSMutableData alloc] init];
//    NSString *Boundary=@"------33234dsfsdfd34534";
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i",UserID]dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"ProfileImage\";filename=\"NewImage.jpg\"\r\nContent-Type:ImageFile\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:UIImageJPEGRepresentation(newpicture, 0.25)];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
//    [request setHTTPBody:PostData];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
//    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
//    [connection setCallBackDelegate:Delegate];
//    [connection start];
//}
//+(void) sendActivityConfirmation:(NSInteger) UserID PosterIDList:(NSString *)PosterIDList WineIDList:(NSString *)WineIDList UUID:(NSString *) UUID Callback:(id) Delegate{
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=confirmactivity",[NSGlobalConfiguration URL]]];
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
//    NSMutableData *PostData=[[NSMutableData alloc] init];
//    NSString *Boundary=@"-----jkjfhskjh943532453";
//    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%i",UserID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"PosterIDList\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%@",PosterIDList] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"WineIDList\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%@",WineIDList] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UUID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[[NSString stringWithFormat:@"%@",UUID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"%@",[[NSString alloc] initWithData:PostData encoding:NSUTF8StringEncoding]);
//    [request setHTTPBody:PostData];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
//    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
//    [connection setCallBackDelegate:Delegate];
//    [connection start];
//}
//+(void) PostFeed:(NSInteger) UserID Comment:(NSString *)comment LocationID:(NSInteger) locationID CallbackDelegate:(id) delegate{
//    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=postfeed",[NSGlobalConfiguration URL]]];
//    NSString *Boundary=@"------35345654tgsdgsahefdsg";
//    NSMutableData *POSTData=[[NSMutableData alloc] init];
//    [POSTData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[[NSString stringWithFormat:@"%i",UserID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[@"\r\nContent-Disposition:form-data;name=\"comment\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[comment dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[@"\r\nContent-Disposition:form-data;name=\"locationid\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[[NSString stringWithFormat:@"%i",locationID] dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [POSTData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
//    [request setHTTPBody:POSTData];
//    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%i",[POSTData length]] forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPMethod:@"POST"];
//    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
//    [connection setCallBackDelegate:delegate];
//    [connection start];
//}
//
@end
