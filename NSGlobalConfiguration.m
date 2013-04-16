//
//  NSGlobalConfiguration.m
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/6/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "NSGlobalConfiguration.h"

@implementation NSGlobalConfiguration
+(NSString *)URL{
    return [NSString stringWithFormat:@"http://%@",[self Host]];
}
+(NSString *)Host{
    return @"50.62.148.155:8080/heres2u/api/";
    //return @"heres2u.calarg.net";
}
+(void)setConfigurationItem:(NSString *)key Item:(id)item{
    NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
    [Defaults setValue:item forKey:key];
    [Defaults synchronize];
}
+(id)getConfigurationItem:(NSString *)key{
      NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
    return [Defaults objectForKey:key];
}
@end