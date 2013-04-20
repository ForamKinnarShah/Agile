//
//  NSLocationLoader.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/15/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSGlobalConfiguration.h"
#import "NSLocationLoaderProtocol.h"

@interface NSLocationLoader : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate,NSXMLParserDelegate>{
    @private
    NSMutableData *RawData;
    NSMutableArray *Items;
    BOOL ShouldThrowError;
}
@property (strong,nonatomic) id Delegate;
-(void) downloadLocations;
-(NSInteger) count;
-(NSDictionary *)getLocationAtIndex:(NSInteger) index;
@end
