//
//  NSSearchForUserProtocol.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 1/9/13.
//  Copyright (c) 2013 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSSearchForUser;
@protocol NSSearchForUserProtocol <NSObject>
@optional
-(void) searchforuser:(NSSearchForUser *) searchobject FailedWithError:(NSError *) error;
-(void) searchforuserDidNotFindAnyUsers: (NSSearchForUser *) searchobject;
-(void) searchforuserFoundUsers:(NSSearchForUser *) searchobject;
@end
