//
//  FeedItems.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FeedItems : NSManagedObject

@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * userImage;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * feedID;
@property (nonatomic, retain) NSDate * dateCreated;

@end
