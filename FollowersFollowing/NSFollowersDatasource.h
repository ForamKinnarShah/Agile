//
//  NSFollowersDatasource.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 1/7/13.
//  Copyright (c) 2013 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSFollowersDatasourceProtocol.h"
#import "NSGlobalConfiguration.h"
@interface NSFollowersDatasource : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>{
    @private
    NSMutableArray *Data;
    NSMutableData *RawData;
    BOOL ErrorDetected;
}
@property (strong,nonatomic) id Delegate;
@property (nonatomic)NSInteger userID;
-(void)loadData;
-(NSInteger) count;
-(NSDictionary *)dataAtIndex:(NSInteger)index;
-(NSMutableArray *)getAllData;
@end
