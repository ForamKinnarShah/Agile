//
//  UIUserInteractionItemProtocol.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 1/6/13.
//  Copyright (c) 2013 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIUserInteractionItemProtocol <NSObject>
@optional
-(void) userRequestedToUnfollowUser:(NSInteger) userID;
-(void)userRequestedToStopUserFromFollowing:(NSInteger)userID;
@end
