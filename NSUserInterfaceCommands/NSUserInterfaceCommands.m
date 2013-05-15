//
//  NSUserInterfaceCommands.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 12/15/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "NSUserInterfaceCommands.h"

@implementation NSUserInterfaceCommands
+(void) deleteUserRating:(NSInteger)PosterID WineID:(NSInteger)WineID CallbackDelegate:(id)Delegate{
    NSString *Boundary=@"----------34872678hjghfags38768";
    NSMutableData *PostData=[[NSMutableData alloc] init];
    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data; name=\"PosterID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding] ];
    [PostData appendData:[[NSString stringWithFormat:@"%i",PosterID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"WineID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",WineID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=deleterating",[NSGlobalConfiguration URL]]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:PostData];
    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
    [connection setCallBackDelegate:Delegate];
    [connection start];
}
+(void) flagUserRating:(NSInteger)FlaggingUserID PosterID:(NSInteger)PosterID WineID:(NSInteger)WineID CallbackDelegate:(id)Delegate{
    NSString *Boundary=@"----------3463jkjhsdfjk565jhk";
    NSMutableData *PostData=[[NSMutableData alloc] init];
    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"\r\nContent-Disposition:form-data; name=\"FlaggingUserID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",FlaggingUserID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data; name=\"PosterID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",PosterID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"WineID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[[NSString stringWithFormat:@"%i",WineID] dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=flagrating",[NSGlobalConfiguration URL]]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:PostData];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
    [connection setCallBackDelegate:Delegate];
    [connection start];
}
+(void) addComment:(NSInteger)CommenterID Comment:(NSString *)Comment FeedID:(NSInteger) FeedID CallbackDelegate:(id)Delegate{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=addcomment",[NSGlobalConfiguration URL]]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    NSMutableData *PostData=[[NSMutableData alloc] init];
    NSString *Boundary=@"--------873jjhg3587hkjasfjg4";
    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"\r\nContent-Disposition:form-data; name=\"CommenterID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[[NSString stringWithFormat:@"%i",CommenterID] dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"FeedID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[[NSString stringWithFormat:@"%i",FeedID] dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"Comment\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Comment dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [request setHTTPBody:PostData];
     [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
     [request setHTTPMethod:@"POST"];
     [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
    [connection setCallBackDelegate:Delegate];
    [connection start];
     }
+(void) toggleWant:(NSInteger)UserID WineID:(NSInteger)WineID PosterID:(NSInteger)PosterID Callback:(id)Delegate{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=togglewant",[NSGlobalConfiguration URL]]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    NSString *Boundary=@"----------dgdfhdhdfhds845739487safsfa";
    NSMutableData *PostData=[[NSMutableData alloc] init];
    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",UserID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"WineID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",WineID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"PosterID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[[NSString stringWithFormat:@"%i",PosterID]dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
     [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [request setHTTPBody:PostData];
     [request setHTTPMethod:@"POST"];
     [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
     [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
     NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
     [connection setCallBackDelegate:Delegate];
    [connection start];
     }
+(void) followUser:(NSInteger)UserID FolloweeID:(NSInteger)FolloweeID CallbackDelegate:(id)Delegate{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=followuser",[NSGlobalConfiguration URL]]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    NSMutableData *PostData=[[NSMutableData alloc] init];
    NSString *Boundary=@"---------34jkkjhkak342334";
    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i", UserID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"FolloweeID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",FolloweeID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:PostData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:	self];
    [connection setCallBackDelegate:Delegate];
    [connection start];
}
+(void)unfollowUser:(NSInteger)UserID FolloweeID:(NSInteger)FolloweeID CallbackDelegate:(id)Delegate{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=unfollowuser",[NSGlobalConfiguration URL]]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    NSMutableData *PostData=[[NSMutableData alloc] init];
    NSString *Boundary=@"-----jkjfhskjh943532453";
    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",UserID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"FolloweeID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",FolloweeID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:PostData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
    [connection setCallBackDelegate:Delegate];
    [connection start];
}
+(void)stopUserFollow:(NSInteger)UserID FollowerID:(NSInteger)FollowerID CallbackDelegate:(id)Delegate{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=stopuserfollow",[NSGlobalConfiguration URL]]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    NSMutableData *PostData=[[NSMutableData alloc] init];
    NSString *Boundary=@"-----jkjfhskjh943532453";
    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",UserID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"FollowerID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",FollowerID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:PostData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
    [connection setCallBackDelegate:Delegate];
    [connection start];
}
+(void) updateProfilePicture:(NSInteger) UserID NewPicture:(UIImage *) newpicture CallbackDelegate:(id)Delegate{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=updateprofilepicture",[NSGlobalConfiguration URL]]];
    NSMutableData *PostData=[[NSMutableData alloc] init];
    NSString *Boundary=@"------33234dsfsdfd34534";
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",UserID]dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"ProfileImage\";filename=\"NewImage.jpg\"\r\nContent-Type:ImageFile\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:UIImageJPEGRepresentation(newpicture, 0.25)];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPBody:PostData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
    [connection setCallBackDelegate:Delegate];
    [connection start];
}
+(void) sendActivityConfirmation:(NSInteger) UserID PosterIDList:(NSString *)PosterIDList WineIDList:(NSString *)WineIDList UUID:(NSString *) UUID Callback:(id) Delegate{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=confirmactivity",[NSGlobalConfiguration URL]]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    NSMutableData *PostData=[[NSMutableData alloc] init];
    NSString *Boundary=@"-----jkjfhskjh943532453";
    [PostData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%i",UserID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"PosterIDList\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%@",PosterIDList] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"WineIDList\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%@",WineIDList] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\nContent-Disposition:form-data;name=\"UUID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[[NSString stringWithFormat:@"%@",UUID] dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [PostData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  //  NSLog(@"%@",[[NSString alloc] initWithData:PostData encoding:NSUTF8StringEncoding]);
    [request setHTTPBody:PostData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i",[PostData length]] forHTTPHeaderField:@"Content-Length"];
    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
    [connection setCallBackDelegate:Delegate];
    [connection start];
}
+(void) PostFeed:(NSInteger) UserID Comment:(NSString *)comment LocationID:(NSInteger) locationID CallbackDelegate:(id) delegate{
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=postfeed",[NSGlobalConfiguration URL]]];
    NSString *Boundary=@"------35345654tgsdgsahefdsg";
    NSMutableData *POSTData=[[NSMutableData alloc] init];
    [POSTData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\nContent-Disposition:form-data;name=\"UserID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[[NSString stringWithFormat:@"%i",UserID] dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\nContent-Disposition:form-data;name=\"comment\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[comment dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\nContent-Disposition:form-data;name=\"locationid\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[[NSString stringWithFormat:@"%i",locationID] dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"\r\n--" dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[Boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [POSTData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPBody:POSTData];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i",[POSTData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    NSTaggedURLConnection *connection=[[NSTaggedURLConnection alloc] initWithRequest:request delegate:self];
    [connection setCallBackDelegate:delegate];
    [connection start];
}
//Delegates:
//Connection Delegates:
+(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSTaggedURLConnection *conn=(NSTaggedURLConnection *) connection;
    [conn.Data appendData:data];
        
}
+(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSTaggedURLConnection *conn=(NSTaggedURLConnection *)connection;
    NSTaggedXMLParser *parser=[[NSTaggedXMLParser alloc] initWithData:[conn Data]];
    [parser setDelegate:self];
   //NSLog(@"This is the Data: %@",[[NSString alloc] initWithData:[conn Data] encoding:NSUTF8StringEncoding]);
    [parser setCallBackDelegate:[conn CallBackDelegate]];
    [parser parse];
    
}
+(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    SEL ErrorSelector=@selector(userinterfaceCommandFailed:);
   NSTaggedURLConnection *conn=(NSTaggedURLConnection *)connection;
    if([conn.CallBackDelegate respondsToSelector:ErrorSelector]){
        [conn.CallBackDelegate userinterfaceCommandFailed:[error localizedDescription]];
    }

}
+(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust];
}
+(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSURLCredential *Credential=[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    [challenge.sender useCredential:Credential forAuthenticationChallenge:challenge];
}
//XMLDelegates:
+(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    NSTaggedXMLParser *par=(NSTaggedXMLParser *)parser;
    [par setLastTag:elementName];
    [par setCurrentCharacters:@""];
}
+(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSTaggedXMLParser *par=(NSTaggedXMLParser *)parser;
    [par setCurrentCharacters:[NSString stringWithFormat:@"%@%@",[par currentCharacters],string]];
    
}
+(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"SuccessMessage"]){
        SEL SuccessSelector=@selector(userinterfaceCommandSucceeded:);
        NSTaggedXMLParser *par=(NSTaggedXMLParser *) parser;
        if([par.CallBackDelegate respondsToSelector:SuccessSelector]){
            [par.CallBackDelegate userinterfaceCommandSucceeded:[par currentCharacters]];
        }
        [parser abortParsing];
    }else{
        if([elementName isEqualToString:@"ServerReply"]){
            SEL ErrorSelector=@selector(userinterfaceCommandFailed:);
            NSTaggedXMLParser *par=(NSTaggedXMLParser *) parser;
            if([par.CallBackDelegate respondsToSelector:ErrorSelector]){
                [par.CallBackDelegate userinterfaceCommandFailed:[par currentCharacters]];
            }
            [parser abortParsing];
        }
    }
}
+(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    SEL ErrorSelector=@selector(userinterfaceCommandFailed:);
    NSTaggedXMLParser *par=(NSTaggedXMLParser *) parser;
    if([par.CallBackDelegate respondsToSelector:ErrorSelector]){
        [par.CallBackDelegate userinterfaceCommandFailed:[parseError localizedDescription]];
    }
    [parser abortParsing];
}
+(void) parserDidEndDocument:(NSXMLParser *)parser{
    SEL ErrorSelector=@selector(userinterfaceCommandFailed:);
    NSTaggedXMLParser *par=(NSTaggedXMLParser *) parser;
    if([par.CallBackDelegate respondsToSelector: ErrorSelector]){
        [par.CallBackDelegate userinterfaceCommandFailed:@"Result Unknown"];
    }
}
+(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    SEL ErrorSelector=@selector(userinterfaceCommandFailed:);
    NSTaggedXMLParser *par=(NSTaggedXMLParser *) parser;
    if([par.CallBackDelegate respondsToSelector:ErrorSelector]){
        [par.CallBackDelegate userinterfaceCommandFailed:[validationError localizedDescription]];
    }
    [parser abortParsing];

}
@end
