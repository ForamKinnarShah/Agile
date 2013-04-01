//
//  orderItem.m
//  HERES2U
//
//  Created by Paul Sukhanov on 3/22/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "orderItem.h"

@implementation orderItem

-(id)initWithName:(NSString*)name Price:(NSInteger)price itemType:(enum itemType)itemType
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.price = price;
        self.itemType = itemType;
        return self;
    }
    return nil; 
}

@end
