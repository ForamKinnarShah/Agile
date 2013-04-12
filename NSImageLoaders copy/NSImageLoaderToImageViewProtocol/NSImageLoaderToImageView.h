//
//  NSImageLoaderToImageView.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 12/21/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSImageLoader.h"
#import "NSImageLoaderToImageViewProtocol.h"
@interface NSImageLoaderToImageView : NSObject<NSImageLoaderProtocol>
@property (weak,nonatomic) UIImageView *ImageView;
@property (weak,nonatomic) id Delegate;
@property (weak, nonatomic) NSImageLoader *LoaderObject;
-(id)initWithURL:(NSURL *)objURL ImageView:(UIImageView *)imageview;
-(id) initWithURLString:(NSString *)objURL ImageView:(UIImageView *)imageview;
-(id) initWithURL:(NSURL *)objURL ImageView:(UIImageView *)imageview StartImmediately:(BOOL)startImmediately;
-(id) initWithURLString:(NSString *)objURL ImageView:(UIImageView *)imageview StartImmediately:(BOOL)startImmediately;
-(void) start;
@end
