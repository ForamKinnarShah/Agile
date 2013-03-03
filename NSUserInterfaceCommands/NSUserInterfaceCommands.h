//
//  NSUserInterfaceCommands.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 12/15/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSTaggedURLConnection.h"
#import "NSTaggedXMLParser.h"
#import "NSGlobalConfiguration.h"
#import "NSUserInterfaceCommandsProtocol.h"
@interface NSUserInterfaceCommands : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>
+(void) deleteUserRating:(NSInteger)PosterID WineID:(NSInteger) WineID CallbackDelegate:(id)Delegate;
+(void) flagUserRating:(NSInteger)FlaggingUserID PosterID:(NSInteger) PosterID WineID:(NSInteger) WineID CallbackDelegate:(id)Delegate;
+(void) addComment:(NSInteger)CommenterID Comment:(NSString *)Comment FeedID:(NSInteger) FeedID CallbackDelegate:(id)Delegate;
+(void) toggleWant:(NSInteger) UserID WineID:(NSInteger) WineID PosterID:(NSInteger)PosterID Callback:(id)Delegate;
+(void) followUser:(NSInteger) UserID FolloweeID:(NSInteger) FolloweeID CallbackDelegate:(id) Delegate;
+(void) unfollowUser:(NSInteger) UserID FolloweeID:(NSInteger)FolloweeID CallbackDelegate:(id)Delegate;
+(void) stopUserFollow:(NSInteger) UserID FollowerID:(NSInteger)FollowerID CallbackDelegate:(id)Delegate;
+(void) updateProfilePicture:(NSInteger) UserID NewPicture:(UIImage *) newpicture CallbackDelegate:(id) Delegate;
+(void) sendActivityConfirmation:(NSInteger) UserID PosterIDList:(NSString *)PosterIDList WineIDList:(NSString *)WineIDList UUID:(NSString *) UUID Callback:(id) Delegate;
+(void) PostFeed:(NSInteger) UserID Comment:(NSString *)comment LocationID:(NSInteger) locationID CallbackDelegate:(id) delegate;

@end
