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
@synthesize isLatitude,isLongitude;
@synthesize arrayLatitude,arrayLongitude;


-(id)initWithURL:(NSURL*)parseURL{
    @try {
   //     NSLog(@"parseURL : %@",parseURL);
//        NSString *Items=[[NSString alloc] initWithContentsOfURL:parseURL encoding:NSUTF8StringEncoding error:nil];
//        NSXMLParser *nsXmlParser=[[NSXMLParser alloc] initWithData:[Items dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *Items=[[NSString alloc] initWithContentsOfURL:parseURL encoding:NSUTF8StringEncoding error:nil];
        NSData *xmlData = [[Items stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *nsXmlParser=[[NSXMLParser alloc] initWithData:xmlData];
        
        dicSent = [[NSMutableDictionary alloc] init];
        
        strMutableElement = [[NSMutableString alloc] init];
        
        self.arrayTransactionsID = [[NSMutableArray alloc] init];
        self.arrayData = [[NSMutableArray alloc] init];
        self.arrayLocationID = [[NSMutableArray alloc] init];
        self.arrayLocationImage = [[NSMutableArray alloc] init];
        self.arrayLocationName = [[NSMutableArray alloc] init];
        self.arrayMiles = [[NSMutableArray alloc] init];
        self.arrayPrice = [[NSMutableArray alloc] init];
        self.arraySenderID = [[NSMutableArray alloc] init];
        self.arraySenderName = [[NSMutableArray alloc] init];
        self.arrayStatus = [[NSMutableArray alloc] init];
        self.arrayLatitude = [[NSMutableArray alloc] init];
        self.arrayLongitude = [[NSMutableArray alloc] init];
        self.arrayLatitude = [[NSMutableArray alloc] init];
        self.arrayLongitude = [[NSMutableArray alloc] init];

        
        // set delegate
        [nsXmlParser setDelegate:self];
        // parsing...
        BOOL success = [nsXmlParser parse];
        // test the result
        if (success) {
        //    NSLog(@"success.");
            return (id)dicSent;
        } else {
        //    NSLog(@"Error parsing document!");
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
   //     NSLog(@"didStartElement elementName : %@",elementName);
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
        else if([elementName isEqualToString:@"Latitude"]){
            isLatitude = YES;
        }
        else if([elementName isEqualToString:@"Longitude"]){
            isLongitude = YES;
        }
        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    @try {
    //    NSLog(@"foundCharacters string : %@",string);
        strMutableElement = [string copy];
/*        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(!string || [string isEqualToString:@""] || [string isEqualToString:@" "] || string==NULL || string==nil || string==Nil || strMutableElement.length==0){
            strMutableElement = [NSString stringWithFormat:@"No Data"];
        }
        strMutableElement = [string copy];*/
               
        if(isTransactionsID){
            [self.arrayTransactionsID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
       //     NSLog(@"arrayTransactionsID : %@",self.arrayTransactionsID);
        }
        else if(isLocationID){
            [arrayLocationID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arrayLocationID : %@",arrayLocationID);
        }
        else if(isLocationImage){
            [arrayLocationImage addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
       //     NSLog(@"arrayLocationImage : %@",arrayLocationImage);
        }
        else if(isLocationName){
            [arrayLocationName addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
         //   NSLog(@"arrayLocationName : %@",arrayLocationName);
        }
        else if(isMiles){
            [arrayMiles addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arrayMiles : %@",arrayMiles);
        }
        else if(isSenderID){
            [arraySenderID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arraySenderID : %@",arraySenderID);
        }
        else if(isSenderName){
            [arraySenderName addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arraySenderName : %@",arraySenderName);
        }
        else if(isPrice){
            [arrayPrice addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
       //     NSLog(@"arrayPrice : %@",arrayPrice);
        }
        else if(isStatus){
            [arrayStatus addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arrayStatus : %@",arrayStatus);
        }
        else if(isLatitude){
        //    NSLog(@"strMutableElement : %@",strMutableElement);
            if([strMutableElement isEqualToString:@""]){
                strMutableElement = [NSString stringWithFormat:@"00.0000"];
            }
            [self.arrayLatitude addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arrayLatitude : %@",arrayLatitude);
        }
        else if(isLongitude){
         //   NSLog(@"strMutableElement : %@",strMutableElement);
            if([strMutableElement isEqualToString:@""]){
                strMutableElement = [NSString stringWithFormat:@"00.0000"];
            }
            [self.arrayLongitude addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arrayLongitude : %@",arrayLongitude);
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    @try {
        if(isTransactionsID){
            isTransactionsID = NO;
            [dicSent setValue:self.arrayTransactionsID forKey:@"TransactionsID"];
        }
        else if(isLocationID){
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
        else if(isLatitude){
            isLatitude = NO;
            [dicSent setValue:self.arrayLatitude forKey:@"Latitude"];
        }
        else if(isLongitude){
            isLongitude = NO;
            [dicSent setValue:self.arrayLongitude forKey:@"Longitude"];
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
