//
//  NSCommentLoaderProtocol.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSCommentLoader;
@protocol NSCommentLoaderProtocol <NSObject>
@optional
-(void) loaderFailed:(NSError *)error;
-(void) commentsLoaded:(NSCommentLoader *)loader;
@end
