//
//  NSUserInterfaceCommandsProtocol.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 12/15/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSUserInterfaceCommandsProtocol <NSObject>
@optional
-(void)userinterfaceCommandSucceeded:(NSString *) message;
-(void)userinterfaceCommandFailed:(NSString *) message;
@end
