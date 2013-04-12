//
//  NSTaggedXMLParser.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/25/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTaggedXMLParser : NSXMLParser
@property (nonatomic) NSInteger Tag;
@property (strong,nonatomic)id CallBackDelegate;
@property (strong, nonatomic) NSMutableDictionary *ParsedPairs;
@property (strong,nonatomic) NSString *lastTag;
@property (strong,nonatomic) NSString *currentCharacters;
@end
