//
//  SayThanksXML.m
//  HERES2U
//
//  Created by agilepc97 on 4/16/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "SayThanksXML.h"

@implementation SayThanksXML

@synthesize isSayThanks,arraySayThanks;

-(id)initWithURL:(NSURL*)parseURL{
    @try {
        NSLog(@"parseURL : %@",parseURL);
//        NSString *Items=[[NSString alloc] initWithContentsOfURL:parseURL encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"items %@",Items);
//        NSData *xmlData = [[NSData alloc] initWithContentsOfURL:parseURL];
//        NSXMLParser *nsXmlParser=[[NSXMLParser alloc] initWithData:xmlData];
//        NSXMLParser *nsXmlParser=[[NSXMLParser alloc] initWithData:[Items dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *Items=[[NSString alloc] initWithContentsOfURL:parseURL encoding:NSUTF8StringEncoding error:nil];
        NSData *xmlData = [[Items stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *nsXmlParser=[[NSXMLParser alloc] initWithData:xmlData];
        
        dicSayThanks = [[NSMutableDictionary alloc] init];        
        strMutableElement = [[NSMutableString alloc] init];
        self.arraySayThanks = [[NSMutableArray alloc] init];
        
        // set delegate
        [nsXmlParser setDelegate:self];
        // parsing...
        BOOL success = [nsXmlParser parse];
        // test the result
        if (success) {
            NSLog(@"success.");
            return (id)dicSayThanks;
        } else {    
            NSLog(@"Error parsing document!");
            isParseFailed = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Error parsing document!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            return NULL;

        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    @try {
        NSLog(@"didStartElement elementName : %@",elementName);
        if([elementName isEqualToString:@"successmessage"]){
            isSayThanks = YES;
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    @try {
        NSLog(@"foundCharacters string : %@",string);
        strMutableElement = [string copy];
        
        if(isSayThanks){
            [arraySayThanks addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    @try {
        if(isSayThanks){
            isSayThanks = NO;
            [dicSayThanks setValue:self.arraySayThanks forKey:@"SayThanksId"];
        }
    }
    @catch (NSException *exception) {
        
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@",[parseError description]);
}

@end
