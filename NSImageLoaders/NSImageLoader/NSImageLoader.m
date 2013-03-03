//
//  NSImageLoader.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 9/2/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "NSImageLoader.h"

@implementation NSImageLoader
@synthesize URL,URLString;
-(id) initWithURL:(NSURL *)objURL{
    self=[super init];
    //NSLog(@"Activated:");
    //NSLog(@"%@",[objURL absoluteString]);
    ImageData=[[NSMutableData alloc] init];
    URL=[objURL copy];
    ImageName=[[URL absoluteString] lastPathComponent];
    URLString=[URL absoluteString];
    urlRequest=[[NSURLRequest alloc] initWithURL:URL];
    urlConnection=[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    return self;
}
-(id) initWithURL:(NSURL *)objURL StartImmediately:(BOOL)startImmediately{
    self= [self initWithURL:objURL];
    if(startImmediately){
        [self startDownloading];
    }
    return self;
}
-(id) initWithURLString:(NSString *)objURL{
    self=[self initWithURL:[NSURL URLWithString:[[objURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"%0A" withString:@""]]];
    return self;
}
-(id) initWithURLString:(NSString *)objURL StartImmediately:(BOOL)startImmediately{
    self=[self initWithURLString:objURL];
    if(startImmediately){
        [self startDownloading];
    }
    return self;
}
-(void)startDownloading{
    //Check if the Image has already been downloaded
    @autoreleasepool {
    NSString *Directory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *Path=[Directory stringByAppendingPathComponent:ImageName];
    BOOL imageExists=[[NSFileManager defaultManager] fileExistsAtPath:Path];
    if(imageExists){
        //Return the image
        NSFileHandle *handle=[NSFileHandle fileHandleForReadingAtPath:Path];
        UIImage *OutputImage=[UIImage imageWithData:[handle readDataToEndOfFile]];
        [handle closeFile];
        SEL selector=@selector(ImageDownloadingCompleted:Image:);
        if([[self Delegate] respondsToSelector:selector]){
            [[self Delegate] ImageDownloadingCompleted:self Image:OutputImage];
        }

    }else{
        [urlConnection start];
        SEL selector=@selector(ImageDownloadingStarted:);
        if([[self Delegate] respondsToSelector:selector]){
            [[self Delegate] ImageDownloadingStarted:self];
        }
    }
    }
}
-(void)abortDownloading{
    [urlConnection cancel];
    SEL selector=@selector(ImageDownloadingAborted:);
    if([[self Delegate] respondsToSelector:selector]){
        [[self Delegate] ImageDownloadingAborted:self];
    }
}
//Delegates
-(BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if([challenge.protectionSpace.host isEqualToString:URL.host]){
        NSURLCredential *credentials=[[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credentials forAuthenticationChallenge:challenge];
    }
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
   //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [ImageData appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //NSLog(@"Finished Downloading Image: %@" ,[connection.originalRequest.URL absoluteString]);
    UIImage *CompiledImage=[UIImage imageWithData:ImageData];
    //Save it to the Documents path
    NSString *Directory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *Path=[Directory stringByAppendingPathComponent:ImageName];
    BOOL created=[[NSFileManager defaultManager] createFileAtPath:Path contents:nil attributes:nil];
    if(created){
        NSFileHandle *handle=[NSFileHandle fileHandleForWritingAtPath:Path];
        [handle writeData:ImageData];
        [handle closeFile];
    }
    SEL selector=@selector(ImageDownloadingCompleted:Image:);
    if([[self Delegate] respondsToSelector:selector]){
        [[self Delegate] ImageDownloadingCompleted:self Image:CompiledImage];
    }
   //NSLog(@"Image Size:%i", [ImageData length]);
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
   //NSLog(@"Internal URL: %@" ,[connection.originalRequest.URL absoluteString]);
    SEL selector=@selector(ImageDownloadingFailedWithError:Error:);
    if([[self Delegate] respondsToSelector:selector]){
        [[self Delegate] ImageDownloadingFailedWithError:self Error:error];
    }
    
}
-(void) dealloc{
    [self setURL:nil];
    [self setDelegate:nil];
    [self setURLString:nil];
    ImageData=nil;
    urlRequest=nil;
    urlConnection=nil;
    
}
@end
