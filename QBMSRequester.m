//
//  QBMSRequester.m
//  HERES2U
//
//  Created by Paul Sukhanov on 3/19/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "QBMSRequester.h"
#import "QBMSRequesterDelegate.h" 

@implementation QBMSRequester

#define PAYMENT_GATEWAY_URL @"https://merchantaccount.ptc.quickbooks.com/j/AppGateway"
#define APPLICATION_LOGIN @"heres2u.calarg.com"
#define CONNECTION_TICKET @"SDK-TGT-50-osMAdr$lxIsdmbZ$V4SCzQ"

@synthesize data, creditCardTransactionID;

-(BOOL)sendChargeRequest:(NSMutableDictionary*)creditCard forAmount:(NSString*)amount
{
    
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];
    NSString *dateString = [nsdf stringFromDate:[NSDate date]]; 
    NSString *transactionRequestID = @"11";
    NSString *expirationDate = [creditCard objectForKey:@"expirationDate"]; 
    
    
    NSString *expirationMonth = @"12";
    NSString *expirationYear = @"2013";
    
    
    
NSString *requestString = [NSString stringWithFormat:@"<?xml version=\"1.0\"?>\
<?qbmsxml version=\"4.5\"?>\
<QBMSXML>\
<SignonMsgsRq>\
<SignonDesktopRq>\
<ClientDateTime>%@</ClientDateTime>\
<ApplicationLogin>%@</ApplicationLogin>\
<ConnectionTicket>%@</ConnectionTicket>\
</SignonDesktopRq>\
</SignonMsgsRq>\
<QBMSXMLMsgsRq>\
<CustomerCreditCardAuthRq>\
<TransRequestID>%@</TransRequestID>\
<CreditCardNumber>%@</CreditCardNumber>\
<ExpirationMonth>%@</ExpirationMonth>\
<ExpirationYear>%@</ExpirationYear>\
<IsCardPresent>false</IsCardPresent>\
<Amount>%@</Amount>\
</CustomerCreditCardAuthRq>\
</QBMSXMLMsgsRq>\
</QBMSXML>",dateString,APPLICATION_LOGIN,CONNECTION_TICKET,transactionRequestID,[creditCard objectForKey:@"cardNumber"],expirationMonth,expirationYear,amount];
    
    NSMutableURLRequest *chargeRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:PAYMENT_GATEWAY_URL]];
    [chargeRequest setHTTPMethod:@"POST"];
    [chargeRequest setValue:@"application/x-qbmsxml" forHTTPHeaderField:@"content-type"]; 
    [chargeRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:chargeRequest delegate:self startImmediately:YES]; 
    return YES;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data]; 
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    data = [NSMutableData dataWithCapacity:0]; 
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"received response:%@",response); 
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.data];
    parser.delegate = self; 
    [parser parse]; 
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    currentString = [[NSMutableString alloc] initWithCapacity:0];
    
    if ([elementName isEqualToString:@"SignonDesktopRs"])
    {
        NSLog(@"attributeDict:%@",attributeDict);
        
        if ([[attributeDict objectForKey:@"statusCode"] isEqualToString:@"0"])
        {
            NSLog(@"signon worked");
        }
        else {
            NSLog(@"signon error occurred");
            [parser abortParsing];
            if ([self.delegate respondsToSelector:@selector(QBMSRequesterDelegateFailedWithError:)])
            {
                [self.delegate QBMSRequesterDelegateFailedWithError:nil];
            }

        }
    }

    else if ([elementName isEqualToString:@"CustomerCreditCardAuthRs"])
    {
        NSLog(@"attributeDict:%@",attributeDict); 
        
        if ([[attributeDict objectForKey:@"statusCode"] isEqualToString:@"0"])
        {
            NSLog(@"authorization worked");
        }
        else {
            NSLog(@"authorization error occurred");
            [parser abortParsing]; 
            if ([self.delegate respondsToSelector:@selector(QBMSRequesterDelegateFailedWithError:)])
            {
                [self.delegate QBMSRequesterDelegateFailedWithError:nil];
            }

        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
    
    if ([elementName isEqualToString:@"CreditCardTransID"])
    {
        creditCardTransactionID = [currentString copy];
        NSLog(@"recorded creditCardTransactionID as:%@",currentString); 
    }
}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
   if ([self.delegate respondsToSelector:@selector(QBMSRequesterDelegateFailedWithError:)])
   {
       [self.delegate QBMSRequesterDelegateFailedWithError:parseError]; 
   }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([self.delegate respondsToSelector:@selector(QBMSRequesterDelegateFinishedWithCode:)])
    {
        [self.delegate QBMSRequesterDelegateFinishedWithCode:creditCardTransactionID]; 
    }
}
//card authorization xml template

//<?xml version="1.0" encoding="utf-8"?>
//<?qbmsxml version="4.5"?>
//<QBMSXML>
//<QBMSXMLMsgsRq>
//<CustomerCreditCardAuthRq>
//<TransRequestID >STRTYPE</TransRequestID> <!-- required -->
//<!-- BEGIN OR -->
//<CreditCardNumber >STRTYPE</CreditCardNumber> <!-- optional -->
//<ExpirationMonth >INTTYPE</ExpirationMonth> <!-- required -->
//<ExpirationYear >INTTYPE</ExpirationYear> <!-- required -->
//<!-- BEGIN OR -->
//<IsCardPresent >BOOLTYPE</IsCardPresent> <!-- optional -->
//<!-- OR -->
//<IsECommerce >BOOLTYPE</IsECommerce> <!-- optional -->
//<!-- OR -->
//<IsRecurring >BOOLTYPE</IsRecurring> <!-- optional -->
//<!-- END OR -->
//<!-- OR -->
//<!-- BEGIN OR -->
//<Track1Data >STRTYPE</Track1Data> <!-- optional -->
//<!-- OR -->
//<Track2Data >STRTYPE</Track2Data> <!-- optional -->
//<!-- END OR -->
//<!-- END OR -->
//<Amount >AMTTYPE</Amount> <!-- required -->
//<NameOnCard >STRTYPE</NameOnCard> <!-- optional -->
//<CreditCardAddress >STRTYPE</CreditCardAddress> <!-- optional -->
//<CreditCardCity >STRTYPE</CreditCardCity> <!-- optional -->
//<CreditCardState >STRTYPE</CreditCardState> <!-- optional -->
//<CreditCardPostalCode >STRTYPE</CreditCardPostalCode> <!-- optional -->
//<CommercialCardCode >STRTYPE</CommercialCardCode> <!-- optional -->
//<SalesTaxAmount >AMTTYPE</SalesTaxAmount> <!-- optional -->
//<CardSecurityCode >STRTYPE</CardSecurityCode> <!-- optional -->
//<Restaurant> <!-- optional -->
//<ServerID >STRTYPE</ServerID> <!-- optional -->
//<FoodAmount >AMTTYPE</FoodAmount> <!-- optional -->
//<BeverageAmount >AMTTYPE</BeverageAmount> <!-- optional -->
//<TaxAmount >AMTTYPE</TaxAmount> <!-- optional -->
//<TipAmount >AMTTYPE</TipAmount> <!-- optional -->
//</Restaurant>
//<BatchID >STRTYPE</BatchID> <!-- optional -->
//<InvoiceID >STRTYPE</InvoiceID> <!-- optional -->
//<UserID >STRTYPE</UserID> <!-- optional -->
//<Comment >STRTYPE</Comment> <!-- optional -->
//<GeoLocationInfo> <!-- optional -->
//<IPAddress >STRTYPE</IPAddress> <!-- optional -->
//<Latitude >STRTYPE</Latitude> <!-- optional -->
//<Longitude >STRTYPE</Longitude> <!-- optional -->
//</GeoLocationInfo>
//<DeviceInfo> <!-- optional -->
//<DeviceID >STRTYPE</DeviceID> <!-- optional -->
//<DeviceType >STRTYPE</DeviceType> <!-- optional -->
//<DevicePhoneNumber >STRTYPE</DevicePhoneNumber> <!-- optional -->
//<DeviceMACAddress >STRTYPE</DeviceMACAddress> <!-- optional -->
//</DeviceInfo>
//</CustomerCreditCardAuthRq>


//<CustomerCreditCardAuthRs statusCode="INTTYPE" statusSeverity="STRTYPE" statusMessage="STRTYPE">
//<CreditCardTransID >STRTYPE</CreditCardTransID> <!-- optional -->
//<AuthorizationCode >STRTYPE</AuthorizationCode> <!-- optional -->
//<!-- AVSStreet may have one of the following values: Pass, Fail, NotAvailable -->
//<AVSStreet >ENUMTYPE</AVSStreet> <!-- optional -->
//<!-- AVSZip may have one of the following values: Pass, Fail, NotAvailable -->
//<AVSZip >ENUMTYPE</AVSZip> <!-- optional -->
//<!-- CardSecurityCodeMatch may have one of the following values: Pass, Fail, NotAvailable -->
//<CardSecurityCodeMatch >ENUMTYPE</CardSecurityCodeMatch> <!-- optional -->
//<ClientTransID >STRTYPE</ClientTransID> <!-- optional -->
//<StatusDetail >STRTYPE</StatusDetail> <!-- optional -->
//</CustomerCreditCardAuthRs>
//</QBMSXMLMsgsRq>
//</QBMSXML>

@end
