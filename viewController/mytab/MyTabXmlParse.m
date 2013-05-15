//
//  MyTabXmlParse.m
//  HERES2U
//
//  Created by agilepc97 on 4/12/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "MyTabXmlParse.h"


@implementation MyTabXmlParse

@synthesize arrayData,arrayTransactionsID,arrayLocationID,arrayLocationImage,arrayLocationName,arrayMiles,arrayPrice,arraySenderID,arraySenderName,arrayStatus,arrayCoupancode,arrayLatitude,arrayLongitude,arraySayThanksRece;
@synthesize isTransactionsID,isLocationID,isLocationImage,isLocationName,isMiles,isPrice,isSenderID,isSenderName,isStatus,isCoupancode,isLatitude,isLongitude,isSayThanksRece;


-(id)initWithURL:(NSURL*)parseURL{
    @try {
   //     NSLog(@"parseURL : %@",parseURL);
        
//        NSString *Items=[[NSString alloc] initWithContentsOfURL:parseURL encoding:NSUTF8StringEncoding error:nil];
//        NSXMLParser *nsXmlParser=[[NSXMLParser alloc] initWithData:[Items dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *Items=[[NSString alloc] initWithContentsOfURL:parseURL encoding:NSUTF8StringEncoding error:nil];
        NSData *xmlData = [[Items stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *nsXmlParser=[[NSXMLParser alloc] initWithData:xmlData];
      
        if(!dicReceived){
            dicReceived = [[NSMutableDictionary alloc] init];
        }
        
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
        self.arrayCoupancode = [[NSMutableArray alloc] init];
        self.arrayLatitude = [[NSMutableArray alloc] init];
        self.arrayLongitude = [[NSMutableArray alloc] init];
        self.arraySayThanksRece = [[NSMutableArray alloc] init];
        
        // set delegate
        [nsXmlParser setDelegate:self];
        // parsing...
        BOOL success = [nsXmlParser parse];
        // test the result
        if (success) {
      //      NSLog(@"success.");
            return (id)dicReceived;
        } else {
       //     NSLog(@"Error parsing document!");
            isParseFailed = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"Error parsing document!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            return NULL;
        }
    
    }
    @catch (NSException *exception) {
   //     NSLog(@"exception : %@",exception);
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
        else if([elementName isEqualToString:@"Latitude"]){
            isLatitude = YES;
        }
        else if([elementName isEqualToString:@"Longitude"]){
            isLongitude = YES;
        }
        else if([elementName isEqualToString:@"CouponCode"]){
            isCoupancode = YES;
        }
        else if([elementName isEqualToString:@"SayThanks"]){
            isSayThanksRece = YES;
        }

        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    @try {
   //     NSLog(@"foundCharacters string : %@",string);
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     //   NSLog(@"foundCharacters string : %@",string);
        if(!string || [string isEqualToString:@""] || [string isEqualToString:@" "] || string==NULL || string==nil || string==Nil){
            strMutableElement = [NSString stringWithFormat:@"No Data"];
        }
        strMutableElement = [string copy];
    //    NSLog(@"strMutableElement.length :%d",strMutableElement.length);
//        if([strMutableElement isEqualToString:@" "]){
//            strMutableElement = [NSString stringWithFormat:@"No Data"];
//        }
        
        if(isTransactionsID){
            [self.arrayTransactionsID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
         //   NSLog(@"arrayTransactionsID : %@",self.arrayTransactionsID);
        }
        else if(isLocationID){
            [self.arrayLocationID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arrayLocationID : %@",arrayLocationID);
        }
        else if(isLocationImage){
            [self.arrayLocationImage addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
         //   NSLog(@"arrayLocationImage : %@",arrayLocationImage);
        }
        else if(isLocationName){
            [self.arrayLocationName addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
         //   NSLog(@"arrayLocationName : %@",arrayLocationName);
        }
        else if(isMiles){
            [self.arrayMiles addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //   NSLog(@"arrayMiles : %@",arrayMiles);
        }
        else if(isSenderID){
            [self.arraySenderID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
       //     NSLog(@"arraySenderID : %@",arraySenderID);
        }
        else if(isSenderName){
            [self.arraySenderName addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arraySenderName : %@",arraySenderName);
        }
        else if(isPrice){
            [self.arrayPrice addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arrayPrice : %@",arrayPrice);
        }
        else if(isStatus){
            [self.arrayStatus addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
         //   NSLog(@"arrayStatus : %@",arrayStatus);
        }
        else if(isLatitude){
        //    NSLog(@"strMutableElement : %@",strMutableElement);
            if([strMutableElement isEqualToString:@""]){
                strMutableElement = [NSString stringWithFormat:@"00.0000"];
            }
            [self.arrayLatitude addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
         //   NSLog(@"arrayLatitude : %@",arrayLatitude);
        }
        else if(isLongitude){
         //   NSLog(@"strMutableElement : %@",strMutableElement);
            if([strMutableElement isEqualToString:@""]){
                strMutableElement = [NSString stringWithFormat:@"00.0000"];
            }
            [self.arrayLongitude addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
         //   NSLog(@"arrayLongitude : %@",arrayLongitude);
        }
        else if(isCoupancode){
            [self.arrayCoupancode addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arrayCoupancode : %@",arrayCoupancode);
        }
        else if(isSayThanksRece){
            [self.arraySayThanksRece addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
        //    NSLog(@"arraySayThanksRece : %@",arraySayThanksRece);
        }
        

    }
    @catch (NSException *exception) {
     //   NSLog(@"exception : %@",exception);
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    @try {
        if(isTransactionsID){
            isTransactionsID = NO;
            [dicReceived setValue:self.arrayTransactionsID forKey:@"TransactionsID"];
        }
        else if(isLocationID){
            isLocationID = NO;
            [dicReceived setValue:self.arrayLocationID forKey:@"LocationID"];
        }
        else if(isLocationImage){
            isLocationImage = NO;
            [dicReceived setValue:self.arrayLocationImage forKey:@"LocationImage"];
        }
        else if(isLocationName){
            isLocationName = NO;
            [dicReceived setValue:self.arrayLocationName forKey:@"LocationName"];
        }
        else if(isMiles){
            isMiles = NO;
            [dicReceived setValue:self.arrayMiles forKey:@"Miles"];
        }
        else if(isSenderID){
            isSenderID = NO;
            [dicReceived setValue:self.arraySenderID forKey:@"senderId"];
        }
        else if(isSenderName){
            isSenderName = NO;
            [dicReceived setValue:self.arraySenderName forKey:@"senderName"];
        }
        else if(isPrice){
            isPrice  =NO;
            [dicReceived setValue:self.arrayPrice forKey:@"Price"];
        }
        else if(isStatus){
            isStatus = NO;
            [dicReceived setValue:self.arrayStatus forKey:@"Status"];
        }
        else if(isLatitude){
            isLatitude = NO;
            [dicReceived setValue:self.arrayLatitude forKey:@"Latitude"];
        }
        else if(isLongitude){
            isLongitude = NO;
            [dicReceived setValue:self.arrayLongitude forKey:@"Longitude"];
        }
        else if(isCoupancode){
            isCoupancode = NO;
            [dicReceived setValue:self.arrayCoupancode forKey:@"CoupanCode"];
        }
        else if(isSayThanksRece){
            isSayThanksRece = NO;
            [dicReceived setValue:self.arraySayThanksRece forKey:@"SayThanksId"];
        }
    
    }
    @catch (NSException *exception) {
  //      NSLog(@"exception : %@",exception);
    }
}

@end
