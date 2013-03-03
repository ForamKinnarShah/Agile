//
//  NSCommentLoader.m
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "NSCommentLoader.h"

@implementation NSCommentLoader
@synthesize Delegate;
-(void) getCommentsForFeed:(NSInteger)FeedID{
    NSString *Items=[[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?webservice=ui&action=getcomments&FeedID=%i",[NSGlobalConfiguration URL],FeedID]] encoding:NSUTF8StringEncoding error:nil];
   // NSLog(Items);
    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:[Items dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:self];
    Data=[[NSMutableArray alloc] init];
    [parser parse];
}
-(NSInteger) count{
    return [Data count];
}
-(NSDictionary *) getCommentAtIndex:(NSInteger)index{
    return [Data objectAtIndex:index];
}
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([[elementName lowercaseString] isEqualToString:@"comment"] ){
        [Data addObject:attributeDict];
    }else{
        if([elementName isEqualToString:@"ServerReply"]){
            encounteredServerReply=YES;
        }
    }
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(encounteredServerReply){
        //Error
        NSLog(@"Error:%@",string);
        SEL error=@selector(loaderFailed:);
        if([Delegate respondsToSelector:error]){
                    }
    }
}
-(void) parserDidEndDocument:(NSXMLParser *)parser{
    SEL Success=@selector(commentsLoaded:);
    if([Delegate respondsToSelector:Success]){
        [Delegate commentsLoaded:self];
    }
}
@end
