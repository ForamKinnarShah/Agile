//
//  NSLocationLoaderProtocol.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/15/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSLocationLoader;
@protocol NSLocationLoaderProtocol <NSObject>
@optional
-(void)locationloaderFailedWithError:(NSError *) error;
-(void)locationloaderCompleted:(NSLocationLoader *)loader;
@end
