//
//  NSLoaderToImageViewProtocol.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 12/21/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSImageLoaderToImageView;
@protocol NSImageLoaderToImageViewProtocol <NSObject>
@optional
-(void) imageviewloaderLoadingCompleted:(NSImageLoaderToImageView *) loader;
@end
