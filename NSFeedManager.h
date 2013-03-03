//
//  NSFeedManager.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSGlobalConfiguration.h"
#import "NSFeedManagerProtocol.h"
@interface NSFeedManager : NSObject<NSXMLParserDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    @private
    NSMutableData *RawData;
    NSMutableArray *Feeds;
    BOOL encounteredServerReply;
}
@property (strong,nonatomic) id Delegate;
-(void) getFeeds;
-(NSInteger) count;
-(NSDictionary *) getFeedAtIndex:(NSInteger) index;
@end
