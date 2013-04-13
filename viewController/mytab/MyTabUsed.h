//
//  MyTabUsed.h
//  HERES2U
//
//  Created by agilepc97 on 4/12/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTabUsed : NSObject<NSXMLParserDelegate>{
    NSXMLParser *xmlParser;
    NSMutableString *strMutableElement;
}

//Private Methods
-(id)initWithURL:(NSURL*)parseURL;

//Private Property
@property(nonatomic,strong)NSMutableArray *arrayData;
@property(nonatomic,strong)NSMutableArray *arrayTransactionsID;
@property(nonatomic,strong)NSMutableArray *arrayLocationID;
@property(nonatomic,strong)NSMutableArray *arrayLocationImage;
@property(nonatomic,strong)NSMutableArray *arrayLocationName;
@property(nonatomic,strong)NSMutableArray *arrayMiles;
@property(nonatomic,strong)NSMutableArray *arraySenderID;
@property(nonatomic,strong)NSMutableArray *arraySenderName;
@property(nonatomic,strong)NSMutableArray *arrayPrice;
@property(nonatomic,strong)NSMutableArray *arrayStatus;

@property(nonatomic,assign)BOOL isTransactionsID;
@property(nonatomic,assign)BOOL isLocationID;
@property(nonatomic,assign)BOOL isLocationImage;
@property(nonatomic,assign)BOOL isLocationName;
@property(nonatomic,assign)BOOL isMiles;
@property(nonatomic,assign)BOOL isSenderID;
@property(nonatomic,assign)BOOL isSenderName;
@property(nonatomic,assign)BOOL isPrice;
@property(nonatomic,assign)BOOL isStatus;

@end
