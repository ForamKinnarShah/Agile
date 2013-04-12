//
//  NSImageLoaderProtocol.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 9/2/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSImageLoader;
@protocol NSImageLoaderProtocol <NSObject>
@optional
-(void) ImageDownloadingStarted:(NSImageLoader *)loader;
-(void) ImageDownloadingAborted:(NSImageLoader *)loader;
-(void) ImageDownloadingFailedWithError:(NSImageLoader *)loader Error:(NSError *)error;
@required
-(void) ImageDownloadingCompleted:(NSImageLoader *)loader Image:(UIImage *)image;
@end
