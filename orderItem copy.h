//
//  orderItem.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/22/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>

enum itemType{
        food,
        drink,
        dessert
}itemType; 

@interface orderItem : NSObject

@property NSString *name;
@property float price;
@property enum itemType itemType;

-(id)initWithName:(NSString*)name Price:(NSInteger)price itemType:(enum itemType)itemType; 

@end
