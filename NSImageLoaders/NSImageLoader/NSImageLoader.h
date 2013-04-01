//
//  NSImageLoader.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 9/2/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSImageLoaderProtocol.h"
@interface NSImageLoader : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    @private
    NSMutableData *ImageData;
    NSURLRequest *urlRequest;
    NSURLConnection *urlConnection;
    UIImage *Target;
    NSString *ImageName;
}
@property (weak, nonatomic) NSString *URLString;
@property (weak, nonatomic) NSURL *URL;
@property (weak, nonatomic) id Delegate;
-(id) initWithURL:(NSURL *)objURL;
-(id) initWithURL:(NSURL *) objURL StartImmediately:(BOOL) startImmediately;
-(id) initWithURLString:(NSString *) objURL;
-(id) initWithURLString:(NSString *) objURL StartImmediately:(BOOL) startImmediately;
-(void) startDownloading;
-(void) abortDownloading;

@end
