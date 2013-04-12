//
//  NSFollowingDatasourceProtocol.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 1/7/13.
//  Copyright (c) 2013 CSUS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSFollowingDatasource;
@protocol NSFollowingDatasourceProtocol <NSObject>
@optional
-(void) followingdatasource:(NSFollowingDatasource *)datasource FailedWithError:(NSError *) error;
-(void) followingdatasourceFinishedLoading:(NSFollowingDatasource *) datasource;
@end
