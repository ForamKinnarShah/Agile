//
//  NSImageLoaderToImageView.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 12/21/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "NSImageLoaderToImageView.h"

@implementation NSImageLoaderToImageView
@synthesize ImageView,Delegate,LoaderObject;
-(id)initWithURL:(NSURL *)objURL ImageView:(UIImageView *)imageview{
    self=[super init];
    if(self){
        LoaderObject=[[NSImageLoader alloc] initWithURL:objURL];
        ImageView=imageview;
    }
    return self;
}
-(id)initWithURLString:(NSString *)objURL ImageView:(UIImageView *)imageview{
    self=[super init];
    if(self){
        LoaderObject=[[NSImageLoader alloc] initWithURLString:objURL];
        ImageView=imageview;
    }
    return self;
}
-(id)initWithURL:(NSURL *)objURL ImageView:(UIImageView *)imageview StartImmediately:(BOOL)startImmediately{
    self=[super init];
    if(self){
        LoaderObject=[[NSImageLoader alloc] initWithURL:objURL StartImmediately:startImmediately];
        ImageView=imageview;
    }
    return self;
}
-(id) initWithURLString:(NSString *)objURL ImageView:(UIImageView *)imageview StartImmediately:(BOOL)startImmediately{
    self=[super init];
    if(self){
        LoaderObject=[[NSImageLoader alloc] initWithURLString:objURL StartImmediately:startImmediately];
        ImageView=imageview;
    }
    return self;
}
-(void) start{
    [LoaderObject setDelegate:self];
    [LoaderObject startDownloading];
}
//ImageLoader Delegates
-(void) ImageDownloadingCompleted:(NSImageLoader *)loader Image:(UIImage *)image{
    [ImageView setImage:image];
    SEL CompletionSelector=@selector(imageviewloaderLoadingCompleted:);
    if([Delegate respondsToSelector:CompletionSelector]){
        [Delegate imageviewloaderLoadingCompleted:self];
    }
}
@end
