//
//  MyTabSent.m
//  HERES2U
//
//  Created by agilepc97 on 4/12/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "MyTabSent.h"

@implementation MyTabSent

@synthesize arrayData,arrayLocationID,arrayLocationImage,arrayLocationName,arrayMiles,arrayPrice,arraySenderID,arraySenderName,arrayStatus,arrayTransactionsID;
@synthesize isTransactionsID,isLocationID,isLocationImage,isLocationName,isMiles,isPrice,isSenderID,isSenderName,isStatus;


-(id)initWithURL:(NSURL*)parseURL{
    @try {
        NSLog(@"parseURL : %@",parseURL);
        NSString *Items=[[NSString alloc] initWithContentsOfURL:parseURL encoding:NSUTF8StringEncoding error:nil];
        NSXMLParser *nsXmlParser=[[NSXMLParser alloc] initWithData:[Items dataUsingEncoding:NSUTF8StringEncoding]];
        
        dicSent = [[NSMutableDictionary alloc] init];
        
        strMutableElement = [[NSMutableString alloc] init];
        
        self.arrayData = [[NSMutableArray alloc] init];
        self.arrayLocationID = [[NSMutableArray alloc] init];
        self.arrayLocationImage = [[NSMutableArray alloc] init];
        self.arrayLocationName = [[NSMutableArray alloc] init];
        self.arrayMiles = [[NSMutableArray alloc] init];
        self.arrayPrice = [[NSMutableArray alloc] init];
        self.arraySenderID = [[NSMutableArray alloc] init];
        self.arraySenderName = [[NSMutableArray alloc] init];
        self.arrayStatus = [[NSMutableArray alloc] init];
        self.arrayTransactionsID = [[NSMutableArray alloc] init];
        
        
        // set delegate
        [nsXmlParser setDelegate:self];
        // parsing...
        BOOL success = [nsXmlParser parse];
        // test the result
        if (success) {
            
        } else {
            NSLog(@"Error parsing document!");
        }
        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    @try {
        NSLog(@"didStartElement elementName : %@",elementName);
        if([elementName isEqualToString:@"Transaction"]){
            isTransactionsID = YES;
        }
        else if([elementName isEqualToString:@"LocationID"]){
            isLocationID = YES;
        }
        else if([elementName isEqualToString:@"LocationImage"]){
            isLocationImage = YES;
        }
        else if([elementName isEqualToString:@"LocationName"]){
            isLocationName = YES;
        }
        else if([elementName isEqualToString:@"Miles"]){
            isMiles = YES;
        }
        else if([elementName isEqualToString:@"ReceiverID"]){
            isSenderID = YES;
        }
        else if([elementName isEqualToString:@"ReceiverName"]){
            isSenderName = YES;
        }
        else if([elementName isEqualToString:@"Price"]){
            isPrice = YES;
        }
        else if([elementName isEqualToString:@"Status"]){
            isStatus = YES;
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    @try {
        NSLog(@"foundCharacters string : %@",string);
        strMutableElement = [string copy];
        
        if(isLocationID){
            [arrayLocationID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayLocationID : %@",arrayLocationID);
        }
        else if(isLocationImage){
            [arrayLocationImage addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayLocationImage : %@",arrayLocationImage);
        }
        else if(isLocationName){
            [arrayLocationName addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayLocationName : %@",arrayLocationName);
        }
        else if(isMiles){
            [arrayMiles addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayMiles : %@",arrayMiles);
        }
        else if(isSenderID){
            [arraySenderID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arraySenderID : %@",arraySenderID);
        }
        else if(isSenderName){
            [arraySenderName addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arraySenderName : %@",arraySenderName);
        }
        else if(isPrice){
            [arrayPrice addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayPrice : %@",arrayPrice);
        }
        else if(isStatus){
            [arrayStatus addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayStatus : %@",arrayStatus);
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    @try {
        if(isLocationID){
            isLocationID = NO;
            [dicSent setValue:arrayLocationID forKey:@"LocationID"];
        }
        else if(isLocationImage){
            isLocationImage = NO;
            [dicSent setValue:arrayLocationImage forKey:@"LocationImage"];
        }
        else if(isLocationName){
            isLocationName = NO;
            [dicSent setValue:arrayLocationName forKey:@"LocationName"];
        }
        else if(isMiles){
            isMiles = NO;
            [dicSent setValue:arrayMiles forKey:@"Miles"];
        }
        else if(isSenderID){
            isSenderID = NO;
            [dicSent setValue:arraySenderID forKey:@"senderId"];
        }
        else if(isSenderName){
            isSenderName = NO;
            [dicSent setValue:arraySenderName forKey:@"senderName"];
        }
        else if(isPrice){
            isPrice  =NO;
            [dicSent setValue:arrayPrice forKey:@"Price"];
        }
        else if(isStatus){
            isStatus = NO;
            [dicSent setValue:arrayStatus forKey:@"Status"];
        }
        
    }
    @catch (NSException *exception) {
        
    }
}

@end