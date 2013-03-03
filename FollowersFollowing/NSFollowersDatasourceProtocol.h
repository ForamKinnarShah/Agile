//
//  NSFollowersDatasourceProtocol.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 1/7/13.
//  Copyright (c) 2013 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSFollowersDatasource;
@protocol NSFollowersDatasourceProtocol <NSObject>
@optional
-(void) followersdatasource:(NSFollowersDatasource *)datasource FailedWithError:(NSError *) error;
-(void) followersdatasourceFinishedLoading:(NSFollowersDatasource *) datasource;
@end
