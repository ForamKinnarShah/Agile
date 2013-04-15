//
//  QBMSRequester.h
//  HERES2U
//
//  Created by Paul Sukhanov on 3/19/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBMSRequester : NSObject <NSURLConnectionDataDelegate, NSXMLParserDelegate>

{
    NSMutableData *data;
    NSMutableString *currentString;

}

@property (nonatomic,retain) NSMutableData *data;
@property NSString *returnID;
@property id delegate;

-(BOOL)sendChargeRequest:(NSMutableDictionary*)cardNumber forAmount:(NSString*)amount;
-(BOOL)sendAddWalletRequestForCustomerID:(NSString*)CustID CCNumber:(NSString*)CCNumber ExpiryDate:(NSDate*)expiryDate;
-(BOOL)sendChargeRequestWithWalletID:(NSString*)walletID customerID:(NSString*)custID forAmount:(NSString*)amount;

@end
