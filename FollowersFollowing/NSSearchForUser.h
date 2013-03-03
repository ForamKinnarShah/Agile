//
//  NSSearchForUser.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 1/9/13.
//  Copyright (c) 2013 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSSearchForUserProtocol.h"
#import "NSGlobalConfiguration.h"
@interface NSSearchForUser : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate,NSXMLParserDelegate>
{
    @private
    NSMutableArray *Data;
    NSMutableData *RawData;
    BOOL FoundError;
}
@property (strong,nonatomic) id Delegate;
-(void)findUsersWhosNameStartsWith:(NSString *)searchString WhoAreNotBeingFollowedBy:(NSInteger) UserID;
-(NSInteger) count;
-(NSMutableDictionary *) dataAtIndex:(NSInteger)index;
-(NSMutableArray *) getAllData;
@end
