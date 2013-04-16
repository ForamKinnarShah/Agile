//
//  SayThanksXML.h
//  HERES2U
//
//  Created by agilepc97 on 4/16/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SayThanksXML : NSObject<NSXMLParserDelegate>{
    NSXMLParser *xmlParser;
    NSMutableString *strMutableElement;
}

//Private Methods
-(id)initWithURL:(NSURL*)parseURL;

//Private Property
@property(nonatomic,strong)NSMutableArray *arraySayThanks;

@property(nonatomic,assign)BOOL isSayThanks;


@end
