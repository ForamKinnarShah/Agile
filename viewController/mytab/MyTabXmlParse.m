//
//  MyTabXmlParse.m
//  HERES2U
//
//  Created by agilepc97 on 4/12/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "MyTabXmlParse.h"


@implementation MyTabXmlParse

@synthesize arrayData,arrayTransactionsID,arrayLocationID,arrayLocationImage,arrayLocationName,arrayMiles,arrayPrice,arraySenderID,arraySenderName,arrayStatus;
@synthesize isTransactionsID,isLocationID,isLocationImage,isLocationName,isMiles,isPrice,isSenderID,isSenderName,isStatus;
@synthesize rawData; 

-(id)initWithURL:(NSURL*)parseURL{
    @try {
        NSLog(@"parseURL : %@",parseURL);
        
        NSString *Items=[[NSString alloc] initWithContentsOfURL:parseURL encoding:NSUTF8StringEncoding error:nil];
        
        NSLog(@"Items:%@",Items);
        
        NSXMLParser *nsXmlParser=[[NSXMLParser alloc] initWithData:[Items dataUsingEncoding:NSUTF8StringEncoding]];
      
        dicReceived = [[NSMutableDictionary alloc] init];
        
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

//-(id)initWithURL:(NSURL*)parseURL{
//    @try {
//        NSLog(@"parseURL : %@",parseURL);
//        
//        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:parseURL];
//        req.HTTPMethod = @"POST";
//        rawData = [NSMutableData data]; 
//        [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
//    }
//    @catch (NSException *exception) {
//        
//    }
//}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [rawData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    SEL ErrorSelector=@selector(phpCallerFailedWithError:);
//    if([delegate respondsToSelector:ErrorSelector]){
//        [delegate phpCallerFailed:error];
//    }
    NSLog(@"connection failed:%@",error.localizedDescription);
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //XML PARSER:
    NSLog(@"connection finished loading with response:%@",[[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding]);
    dicReceived = [[NSMutableDictionary alloc] init];
    
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
    
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:rawData]; 
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
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    @try {
        NSLog(@"foundCharacters string : %@",string);
        strMutableElement = [string copy];

        if(isTransactionsID){
            [self.arrayTransactionsID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayTransactionsID : %@",self.arrayTransactionsID);
        }
        else if(isLocationID){
            [self.arrayLocationID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayLocationID : %@",arrayLocationID);
        }
        else if(isLocationImage){
            [self.arrayLocationImage addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayLocationImage : %@",arrayLocationImage);
        }
        else if(isLocationName){
            [self.arrayLocationName addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayLocationName : %@",arrayLocationName);
        }
        else if(isMiles){
            [self.arrayMiles addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayMiles : %@",arrayMiles);
        }
        else if(isSenderID){
            [self.arraySenderID addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arraySenderID : %@",arraySenderID);
        }
        else if(isSenderName){
            [self.arraySenderName addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arraySenderName : %@",arraySenderName);
        }
        else if(isPrice){
            [self.arrayPrice addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayPrice : %@",arrayPrice);
        }
        else if(isStatus){
            [self.arrayStatus addObject:[NSString stringWithFormat:@"%@",strMutableElement]];
            NSLog(@"arrayStatus : %@",arrayStatus);
        }
    }
    @catch (NSException *exception) {
        
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

    }
    @catch (NSException *exception) {
        
    }
}

@end
