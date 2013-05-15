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

#define LIVE_PAYMENT_GATEWAY_URL @"https://merchantaccount.quickbooks.com/j/AppGateway"
#define LIVE_APPLICATION_LOGIN @"heres2u.com.calarg"
#define LIVE_CONNECTION_TICKET @""

@synthesize data, returnID;

-(BOOL)sendChargeRequest:(NSMutableDictionary*)creditCard forAmount:(NSString*)amount
{
    
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];
    NSString *dateString = [nsdf stringFromDate:[NSDate date]]; 
    NSString *transactionRequestID = @"11"; //needs to be changed to actual. 
 //   NSString *expirationDate = [creditCard objectForKey:@"expirationDate"];
    
  //  NSLog(@"%@",expirationDate);
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
<CustomerCreditCardChargeRq>\
<TransRequestID>%@</TransRequestID>\
<CreditCardNumber>%@</CreditCardNumber>\
<ExpirationMonth>%@</ExpirationMonth>\
<ExpirationYear>%@</ExpirationYear>\
<IsCardPresent>false</IsCardPresent>\
<Amount>%@</Amount>\
</CustomerCreditCardChargeRq>\
</QBMSXMLMsgsRq>\
</QBMSXML>",dateString,APPLICATION_LOGIN,CONNECTION_TICKET,transactionRequestID,[creditCard objectForKey:@"cardNumber"],expirationMonth,expirationYear,amount];
    
    NSMutableURLRequest *chargeRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:PAYMENT_GATEWAY_URL]];
    [chargeRequest setHTTPMethod:@"POST"];
    [chargeRequest setValue:@"application/x-qbmsxml" forHTTPHeaderField:@"content-type"]; 
    [chargeRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]]; 
    
  //  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:chargeRequest delegate:self startImmediately:YES];
    return YES;
    
}

-(BOOL)sendChargeRequestWithWalletID:(NSString*)walletID customerID:(NSString*)custID forAmount:(NSString*)amount
{
    
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];
    NSString *dateString = [nsdf stringFromDate:[NSDate date]];
    
    NSString *transactionRequestID = @"12"; //needs to be changed to actual.
    
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
                               <CustomerCreditCardWalletChargeRq>\
                               <TransRequestID>%@</TransRequestID>\
                               <WalletEntryID>%@</WalletEntryID>\
                               <CustomerID>%@</CustomerID>\
                               <Amount>%@</Amount>\
                               </CustomerCreditCardWalletChargeRq>\
                               </QBMSXMLMsgsRq>\
                               </QBMSXML>",dateString,APPLICATION_LOGIN,CONNECTION_TICKET,transactionRequestID,walletID,custID,amount];
    /*NSString *requestString = @"<?xml version=\"1.0\"?>\
    <?qbmsxml version=\"4.5\"?>\
    <QBMSXML>\
    <SignonMsgsRq>\
    <SignonDesktopRq>                               <ClientDateTime>2013-05-09</ClientDateTime>                               <ApplicationLogin>heres2u.calarg.com</ApplicationLogin>                               <ConnectionTicket>SDK-TGT-50-osMAdr$lxIsdmbZ$V4SCzQ</ConnectionTicket>                               </SignonDesktopRq>\
    </SignonMsgsRq>\
    <QBMSXMLMsgsRq>                               <CustomerCreditCardWalletChargeRq>                               <TransRequestID>11</TransRequestID>                               <WalletEntryID>101110826741100770621111</WalletEntryID>                               <CustomerID>85</CustomerID>                               <Amount>11.36</Amount>                               </CustomerCreditCardWalletChargeRq>\
    </QBMSXMLMsgsRq>\
    </QBMSXML>"; */
    
 //   NSLog(@"charge request:%@",requestString);
    NSMutableURLRequest *chargeRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:PAYMENT_GATEWAY_URL]];
    [chargeRequest setHTTPMethod:@"POST"];
    [chargeRequest setValue:@"application/x-qbmsxml" forHTTPHeaderField:@"content-type"]; 
    [chargeRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]]; 
    
  //  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:chargeRequest delegate:self startImmediately:YES];
    return YES;
    
}

-(BOOL)sendAddWalletRequestForCustomerID:(NSString*)CustID CCNumber:(NSString*)CCNumber ExpiryDate:(NSDate*)expiryDate
{
    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];
    NSString *dateString = [nsdf stringFromDate:[NSDate date]];
    
//NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:expiryDate];

 //   NSLog(@"expiryDate >> %@",expiryDate);
    NSString *expiryMonth = [NSString stringWithFormat:@"%i",[components month]];
    NSString *expiryYear = [NSString stringWithFormat:@"%i",[components year]];

    
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
                               <CustomerCreditCardWalletAddRq>\
                               <CustomerID>%@</CustomerID>\
                               <CreditCardNumber>%@</CreditCardNumber>\
                               <ExpirationMonth>%@</ExpirationMonth>\
                               <ExpirationYear>%@</ExpirationYear>\
                               </CustomerCreditCardWalletAddRq>\
                               </QBMSXMLMsgsRq>\
                               </QBMSXML>",dateString,APPLICATION_LOGIN,CONNECTION_TICKET,CustID,CCNumber,expiryMonth,expiryYear];
    
    NSMutableURLRequest *chargeRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:PAYMENT_GATEWAY_URL]];
    [chargeRequest setHTTPMethod:@"POST"];
    [chargeRequest setValue:@"application/x-qbmsxml" forHTTPHeaderField:@"content-type"]; 
    [chargeRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]]; 
    
 //   NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:chargeRequest delegate:self startImmediately:YES];
    return YES;
    
}

-(BOOL)importQuickbooksData {

//NSString *queryString = [NSString stringWithFormat:
//@"<?xml version=\"1.0\" ?>\
//<?qbxml version=\"6.0\"?>\
//<QBXML>\
//<QBXMLMsgsRq onError=\"stopOnError\">\
//<SalesReceiptAddRq requestID = \"101\">\
//<SalesReceiptAdd>\
//<CustomerRef>\
//<FullName>John Hamilton</FullName>\
//</CustomerRef>\
//<TxnDate>2009-02-23</TxnDate>\
//<RefNumber>2345</RefNumber>\
//<PaymentMethodRef>\
//<FullName>Visa</FullName>\
//</PaymentMethodRef>\
//<Memo>QBMS SDK Test 2345</Memo>\
//<CreditCardTxnInfo>\
//<CreditCardTxnInputInfo>\
//<CreditCardNumber>xxxxxxxxxxxx4444</CreditCardNumber>\
//<ExpirationMonth>12</ExpirationMonth>\
//<ExpirationYear>2012</ExpirationYear>\
//<NameOnCard>John Hamilton</NameOnCard>\
//<CreditCardAddress>2750 Coast Avenue</CreditCardAddress>\
//<CreditCardPostalCode>94043</CreditCardPostalCode>\
//<CommercialCardCode>123</CommercialCardCode>\
//<TransactionMode>CardNotPresent</TransactionMode>\
//</CreditCardTxnInputInfo>\
//<CreditCardTxnResultInfo>\
//<ResultCode>0</ResultCode>\
//<ResultMessage>STATUS OK</ResultMessage>\
//<CreditCardTransID>V64A76208243</CreditCardTransID>\
//<MerchantAccountNumber>4269281420247209</MerchantAccountNumber>\
//<AuthorizationCode>185PNI</AuthorizationCode>\
//<AVSStreet>Pass</AVSStreet>\
//<AVSZip>Fail</AVSZip>\
//<CardSecurityCodeMatch>Pass</CardSecurityCodeMatch>\
//<ReconBatchID>420050223 MC 2005-02-23 QBMS 15.0 pre-beta</ReconBatchID>\
//<PaymentGroupingCode>4</PaymentGroupingCode>\
//<PaymentStatus>Completed</PaymentStatus>\
//<TxnAuthorizationTime>2005-02-23T20:57:13</TxnAuthorizationTime>\
//<TxnAuthorizationStamp>1109192233</TxnAuthorizationStamp>\
//<ClientTransID>q0002ee5</ClientTransID>\
//</CreditCardTxnResultInfo>\
//</CreditCardTxnInfo>\
//<SalesReceiptLineAdd>\
//<ItemRef>\
//<FullName>Fee</FullName>\
//</ItemRef>\
//<Rate>100.00</Rate>\
//</SalesReceiptLineAdd>\
//</SalesReceiptAdd>\
//</SalesReceiptAddRq>\
//</QBXMLMsgsRq>\
//</QBXML>"
//                         ];
    return YES;
}

#pragma mark - NSURLConnectionDelegate Methods

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
 //  NSString *response = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
  //  NSLog(@"received response:%@",response);
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.data];
    parser.delegate = self;
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    currentString = [[NSMutableString alloc] initWithCapacity:0];
    
    if ([elementName isEqualToString:@"SignonDesktopRs"])
    {
    //    NSLog(@"attributeDict:%@",attributeDict);
        
        if ([[attributeDict objectForKey:@"statusCode"] isEqualToString:@"0"])
        {
     //       NSLog(@"signon worked");
        }
        else {
    //        NSLog(@"signon error occurred");
            [parser abortParsing];
            if ([self.delegate respondsToSelector:@selector(QBMSRequesterDelegateFailedWithError:)])
            {
                [self.delegate QBMSRequesterDelegateFailedWithError:nil];
            }

        }
    }

    else if ([elementName isEqualToString:@"CustomerCreditCardChargeRs"] || [elementName isEqualToString:@"CustomerCreditCardWalletAddRs"] || [elementName isEqualToString:@"CustomerCreditCardWalletChargeRs"])
    {
    //    NSLog(@"attributeDict:%@",attributeDict);
        
        if ([[attributeDict objectForKey:@"statusCode"] isEqualToString:@"0"])
        {
     //       NSLog(@"authorization worked");
        }
        else {
     //       NSLog(@"authorization error occurred");
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
    
    if ([elementName isEqualToString:@"CreditCardTransID"] || [elementName isEqualToString:@"WalletEntryID"])
    {
        returnID = [currentString copy];
   //     NSLog(@"recorded returnID as:%@",currentString);
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
        [self.delegate QBMSRequesterDelegateFinishedWithCode:returnID];
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
