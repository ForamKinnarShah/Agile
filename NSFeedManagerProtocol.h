//
//  NSFeedManagerProtocol.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSFeedManager;
@protocol NSFeedManagerProtocol <NSObject>
@optional
-(void) feedmanagerFailedWithError:(NSError *)error;
-(void) feedmanagerCompleted:(NSFeedManager *) feedmanager;
@end
