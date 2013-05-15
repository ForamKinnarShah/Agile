//
//  ImageViewLoading.m
//  Plunder
//
//  Created by agilepc97 on 2/22/13.
//  Copyright (c) 2013 Agile. All rights reserved.
//

#import "ImageViewLoading.h"

@implementation ImageViewLoading

- (id)initWithFrame:(CGRect)frame ImageUrl:(NSString*)strUrlString
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self returnImage:strUrlString];
    }
    return self;
}
                            

-(void)returnImage:(NSString*)url{
    
    //LastName
    self.image = [UIImage imageNamed:@"Loading.png"];
    [self setContentMode:UIViewContentModeScaleAspectFit];
    
    NSString *imageUrl = url;
    NSArray *parts = [imageUrl componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    
    NSArray *arrayFileName = [filename componentsSeparatedByString:@"."];
    NSString *strImageName;
    NSString *strExtentionName;
    
    if(arrayFileName.count==3){
        NSString *firstName = [NSString stringWithFormat:@"%@",[arrayFileName objectAtIndex:0]];
        NSString *secondName = [NSString stringWithFormat:@"%@",[arrayFileName objectAtIndex:1]];
        strImageName = [NSString stringWithFormat:@"%@.%@",firstName,secondName];
        strExtentionName = [NSString stringWithFormat:@"%@",[arrayFileName objectAtIndex:arrayFileName.count-1]];
    }
    else{
        strImageName = [NSString stringWithFormat:@"%@",[arrayFileName objectAtIndex:0]];
        strExtentionName = [NSString stringWithFormat:@"%@",[arrayFileName objectAtIndex:arrayFileName.count-1]];
    }
    
    NSString* docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *FilePath = [NSString stringWithFormat:@"%@/%@.%@",docDir,strImageName,strExtentionName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:FilePath];

    if(fileExists){
        self.image = [UIImage imageWithContentsOfFile:FilePath];
    }
    else{
        dispatch_queue_t DownloadQueue = dispatch_queue_create("Download Pic", NULL);
        dispatch_async(DownloadQueue, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imageData];
                if(image){
                    self.image = image;
                    //save image
                    if([strExtentionName isEqualToString:@"png"])
                    {
                 //       NSLog(@"saving png");
                        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
                        [data1 writeToFile:FilePath atomically:YES];
                    }
                    else if([strExtentionName isEqualToString:@"jpeg"] || [strExtentionName isEqualToString:@"jpg"])
                    {
                   //     NSLog(@"saving jpeg");
                        NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
                        [data2 writeToFile:FilePath atomically:YES];
                    }
                    else
                    {
                        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
                        [data1 writeToFile:FilePath atomically:YES];
                    }
                }
                else{
                    self.image = [UIImage imageNamed:@"Image_not_available.jpg"];
                    
                }
                
            });
        });
//        dispatch_release(DownloadQueue);
    }
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
