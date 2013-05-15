//
//  LostPasswordVC.m
//  HERES2U
//
//  Created by agilepc-103 on 4/18/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "LostPasswordVC.h"
#import "NSGlobalConfiguration.h"
@interface LostPasswordVC ()

@end

@implementation LostPasswordVC
{}

#pragma mark
#pragma mark view life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBlocker = [[utilities alloc] init];
    rawData = [NSMutableData dataWithCapacity:0]; 
    // Do any additional setup after loading the view from its nib.
    // allow user to enter email address
    [_txtEmail becomeFirstResponder];
    // Initialization code
    UIToolbar *NavigationBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [NavigationBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *BackButton=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemAction target:self action:@selector(back)];
    NSArray *TBButtons=[[NSArray alloc] initWithObjects:BackButton, nil];
    [NavigationBar setItems:TBButtons];
    [self.view addSubview:NavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark
# pragma mark button actions

- (IBAction)Submit:(id)sender
{
    //[NSUserAccessControl LostPassword:_txtEmail.text Delegate:self];
    
    NSString *URLString = [[NSString stringWithFormat:@"%@resetpassword.php?Email=%@",[NSGlobalConfiguration URL],_txtEmail.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  //  NSLog(@"URLString : %@",URLString);
    NSURL *url = [[NSURL alloc] initWithString:URLString];
    
    UIBlocker=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [UIBlocker setFrame:self.presentingViewController.view.frame];
    [UIBlocker setBackgroundColor:[UIColor grayColor]];
    [UIBlocker setAlpha:0.8];
    [UIBlocker setHidesWhenStopped:YES];
    [self.view addSubview:UIBlocker];
    [UIBlocker startAnimating];
    
    //NSString *response = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"response:%@",response);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    [_txtEmail resignFirstResponder]; 
}

#pragma mark
#pragma mark invoked methods

// invoked from navigation
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [rawData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [[[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"Was not able to get a response from mail server. Please check your internet connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [UIBlocker stopAnimating];
    }

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //XML PARSER:
    NSString *response = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
 //   NSLog(@"connection finished loading with response:%@",[[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding]);
    if ([response rangeOfString:@"<SuccessMessage>1</SuccessMessage>"].location == NSNotFound)
    {
        [[[UIAlertView alloc] initWithTitle:@"Message Failed to Send" message:@"Your message was not sent. Please confirm your email address is correct and try again. If problems persist, please contact support@heres2uapp.com" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Message Sent" message:@"Please check your email in order to reset your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
    }
    
    [UIBlocker stopAnimating];

    //NSXMLParser *parser=[[NSXMLParser alloc] initWithData:rawData];
    //[parser setDelegate:self];
    //[parser parse];
}
//XML Parser
//-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
//     if ([[elementName lowercaseString] isEqualToString:@"SuccessMessage"]){ //optionally, check if [outputDictionary objectForKey:selectedAction] matches elementName
//         currentString = [[NSMutableString alloc] initWithCapacity:0];
//    }
//}
//-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//    [currentString appendString:string]; 
//    
//}
//-(void) parserDidEndDocument:(NSXMLParser *)parser{
//    
//}
//
//-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
//        [parser abortParsing];
//    [[[UIAlertView alloc] initWithTitle:@"Parse error occurred" message:@"XML Parser encountered an error with the response" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
//}
//-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
//    
//    [parser abortParsing];
//}

@end
