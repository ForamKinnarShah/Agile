//
//  NSCommentLoader.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSGlobalConfiguration.h"
#import "NSCommentLoaderProtocol.h"
@interface NSCommentLoader : NSObject
<NSXMLParserDelegate>{
    @private
   BOOL encounteredServerReply;
}
@property (strong, nonatomic) id Delegate;
@property (strong, nonatomic) NSMutableArray *Data;

-(void) getCommentsForFeed:(NSInteger)FeedID;
-(NSInteger) count;
-(NSDictionary *) getCommentAtIndex:(NSInteger)index;
@end
