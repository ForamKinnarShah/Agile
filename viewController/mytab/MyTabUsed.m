//
//  MyTabUsed.m
//  HERES2U
//
//  Created by agilepc97 on 4/12/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "MyTabUsed.h"

@implementation MyTabUsed

@synthesize arrayData,arrayLocationID,arrayLocationImage,arrayLocationName,arrayMiles,arrayPrice,arraySenderID,arraySenderName,arrayStatus,arrayTransactionsID,arraySayThanks;
@synthesize isTransactionsID,isLocationID,isLocationImage,isLocationName,isMiles,isPrice,isSenderID,isSenderName,isStatus,isSayThanks;


-(id)initWithURL:(NSURL*)parseURL{
    @try {
        NSLog(@"parseURL : %@",parseURL);
        NSString *Items=[[NSString alloc] initWithContentsOfURL:parseURL encoding:NSUTF8StringEncoding error:nil];
        NSXMLParser *nsXmlParser=[[NSXMLParser alloc] initWithData:[Items dataUsingEncoding:NSUTF8StringEncoding]];
        
        dicUsed = [[NSMutableDictionary alloc] init];
        
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
        self.arraySayThanks = [[NSMutableArray alloc] init];
        
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
        if([elementName isEqualToString:@"TransactionID"]){
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
        else if([elementName isEqualToString:@"SenderID"]){
            isSenderID = YES;
        }
        else if([elementName isEqualToString:@"SenderName"]){
            isSenderName = YES;
        }
        else if([elementName isEqualToString:@"Price"]){
            isPrice = YES;
        }
        else if([elementName isEqualToString:@"Status"]){
            isStatus = YES;
        }
        else if([elementName isEqualToString:@"SayThanks"]){
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
        if(isTransactionsID){
            [arrayTransactionsID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
        else if(isLocationID){
            [arrayLocationID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
        else if(isLocationImage){
            [arrayLocationImage addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
        else if(isLocationName){
            [arrayLocationName addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
        else if(isMiles){
            [arrayMiles addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
        else if(isSenderID){
            [arraySenderID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
        else if(isSenderName){
            [arraySenderName addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
        else if(isPrice){
            [arrayPrice addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
        else if(isStatus){
            [arrayStatus addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
        else if(isSayThanks){
            [arraySayThanks addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    @try {
        
        if(isTransactionsID){
            isTransactionsID = NO;
            [dicUsed setValue:arrayTransactionsID forKey:@"TransactionId"];
        }
        else if(isLocationID){
            isLocationID = NO;
            [dicUsed setValue:arrayLocationID forKey:@"LocationID"];
        }
        else if(isLocationImage){
            isLocationImage = NO;
            [dicUsed setValue:arrayLocationImage forKey:@"LocationImage"];
        }
        else if(isLocationName){
            isLocationName = NO;
            [dicUsed setValue:arrayLocationName forKey:@"LocationName"];
        }
        else if(isMiles){
            isMiles = NO;
            [dicUsed setValue:arrayMiles forKey:@"Miles"];
        }
        else if(isSenderID){
            isSenderID = NO;
            [dicUsed setValue:arraySenderID forKey:@"senderId"];
        }
        else if(isSenderName){
            isSenderName = NO;
            [dicUsed setValue:arraySenderName forKey:@"senderName"];
        }
        else if(isPrice){
            isPrice  =NO;
            [dicUsed setValue:arrayPrice forKey:@"Price"];
        }
        else if(isStatus){
            isStatus = NO;
            [dicUsed setValue:arrayStatus forKey:@"Status"];
        }
        else if(isSayThanks){
            isSayThanks = NO;
            [dicUsed setValue:arraySayThanks forKey:@"SayThanksId"];
        }
        
        
    }
    @catch (NSException *exception) {
        
    }
}


@end