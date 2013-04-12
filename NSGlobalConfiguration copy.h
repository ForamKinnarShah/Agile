//
//  NSGlobalConfiguration.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/6/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSGlobalConfiguration : NSObject
+(NSString *)URL;
+(NSString *)Host;
+(void)setConfigurationItem:(NSString *)key Item:(id) item;
+(id)getConfigurationItem:(NSString *)key;
@end