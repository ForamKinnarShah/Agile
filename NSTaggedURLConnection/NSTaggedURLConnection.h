//
//  NSTaggedURLConnection.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/25/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTaggedURLConnection : NSURLConnection
@property (nonatomic) NSInteger tag;
@property (strong, nonatomic) id CallBackDelegate;
@property (strong,nonatomic) NSMutableData *Data;
@property (nonatomic) BOOL didCallBegin;
@end
