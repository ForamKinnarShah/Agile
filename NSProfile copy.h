//
//  NSProfile.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/8/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSGlobalConfiguration.h"
#import "NSProfileProtocol.h"
@interface NSProfile : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>{
    NSMutableData *RawData;
    NSString *CurrentString;
    NSDictionary *tempDict;
}
@property (strong, nonatomic,readonly) NSString  *FullName;
@property (strong,nonatomic,readonly) NSString *ImageURL;
@property (nonatomic,readonly) NSInteger Following;
@property (nonatomic,readonly) NSInteger Followers;
@property (nonatomic,readonly) BOOL canFollow;
@property (strong,nonatomic,readonly) NSMutableArray *Feeds;
@property (weak, nonatomic) id Delegate;
@property(nonatomic) NSInteger ProfileID;
-(id) initWithProfileID:(NSInteger)ID;
-(void)  startFetching;
-(void) setProfileID:(NSInteger)ID;
@end
