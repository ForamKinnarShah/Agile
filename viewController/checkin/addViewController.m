//
//  addViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "addViewController.h"

@interface addViewController ()

@end

@implementation addViewController

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
    [(UIScrollView*)self.view setContentSize:self.view.bounds.size];
    // Do any additional setup after loading the view from its nib.
    NSString *centerImageName = @"logo_small.png";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnImage_Click:(id)sender{
    @try {
        UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Photos" message:@"Select Photo From." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera",@"Library", nil];
        alrt.tag=1;
        [alrt show];
    }
    @catch (NSException *exception) {
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    @try {
        
        if(alertView.tag==1){
            objPicker = [[UIImagePickerController alloc] init];
            objPicker.delegate = self;
            
            if(buttonIndex==1){
                isCamera = YES;
                objPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:objPicker animated:YES completion:nil];
            }
            else if(buttonIndex==2){
                isCamera = NO;
                objPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:objPicker animated:YES completion:nil];
                
            }
            else if(buttonIndex==3){
                [btnImage setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];

            }
        }
    }
    @catch (NSException *exception) {
        
    }    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
	UIImage *image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *image = [self resizeImage:image1 resizeSize:CGSizeMake(500, 500)];
    
    if(isCamera){
        isCamera = NO;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[image1 CGImage] orientation:(ALAssetOrientation)[image1 imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                NSLog(@"error");
            } else {
                NSLog(@"url %@", assetURL);
                NSURL *imagePath = assetURL;
                NSString *name = [NSString stringWithFormat:@"%@",imagePath];
                NSLog(@"name : %@",name);
                NSArray *listItems = [name componentsSeparatedByString:@"="];
                NSLog(@"listItems : %@",listItems);
                NSString *imgName = [listItems objectAtIndex:listItems.count-2];
                imgName = [NSString stringWithFormat:@"%@.png",imgName];
                NSString *extention = [listItems objectAtIndex:listItems.count-1];
                [btnImage setImage:image forState:UIControlStateNormal];
                
            }
        }];
        
    }
    else{
        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSString *name = [NSString stringWithFormat:@"%@",imagePath];
        NSLog(@"name : %@",name);
        NSArray *listItems = [name componentsSeparatedByString:@"="];
        NSLog(@"listItems : %@",listItems);
        NSString *imgName = [listItems objectAtIndex:listItems.count-2];
        imgName = [NSString stringWithFormat:@"%@.png",imgName];
        NSString *extention = [listItems objectAtIndex:listItems.count-1];
        [btnImage setImage:image forState:UIControlStateNormal];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *) resizeImage:(UIImage *)orginalImage resizeSize:(CGSize)size
{
	CGFloat actualHeight = orginalImage.size.height;
	CGFloat actualWidth = orginalImage.size.width;
	if(actualWidth <= size.width && actualHeight<=size.height)
	{
		return orginalImage;
	}
	float oldRatio = actualWidth/actualHeight;
	float newRatio = size.width/size.height;
	if(oldRatio < newRatio)
	{
		oldRatio = size.height/actualHeight;
		actualWidth = oldRatio * actualWidth;
		actualHeight = size.height;
	}
	else
	{
		oldRatio = size.width/actualWidth;
		actualHeight = oldRatio * actualHeight;
		actualWidth = size.width;
	}
	CGRect rect = CGRectMake(0.0,0.0,actualWidth,actualHeight);
	UIGraphicsBeginImageContext(rect.size);
	[orginalImage drawInRect:rect];
	orginalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return orginalImage;
}





-(IBAction)submitClicked:(id)sender
{
    [(UIScrollView*)self.view setContentSize:self.view.frame.size];
    
    MFMailComposeViewController *mf = [[MFMailComposeViewController alloc] init];
    mf.mailComposeDelegate = self; 
    [mf setSubject:@"Request for new restaurant"];
    NSMutableString *messageBody = [[NSMutableString alloc] init];
    [messageBody appendFormat:@"Name:%@\n",[(UITextField*)collection[0] text]];
    [messageBody appendFormat:@"Type of Business:%@\n",[(UITextField*)collection[1] text]];
    [messageBody appendFormat:@"Address:%@\n",[(UITextField*)collection[2] text]];
    if (![[(UITextField*) collection[3] text] isEqualToString:@""])
    {
        [messageBody appendFormat:@"%@\n",[(UITextField*)collection[3] text]];
    }
    [messageBody appendFormat:@"%@, %@ %@\n",[(UITextField*)collection[4] text],[(UITextField*)collection[5] text],[(UITextField*)collection[6] text]];
    [messageBody appendString:@"----------------------------------------------------\n"]; 
    [mf setToRecipients:[NSArray arrayWithObject:@"support@heres2uapp.com"]];
    [mf setMessageBody:messageBody isHTML:NO];
    if ([MFMailComposeViewController canSendMail]){
    [self presentViewController:mf animated:YES completion:nil]; 
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"cannot send mail" message:@"Please check your mail settings and internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show]; 
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error)
    {
        NSLog(@"error:%@",error);
    }
    
    if (result == MFMailComposeResultSent)
    {
        [self showAlertMessage:@"Message was queued in outbox. Will send if/when connected to email" withTitle:@"Email Sent"];
    }
    else if (result == MFMailComposeErrorCodeSendFailed || result == MFMailComposeResultFailed)
    {
        [self showAlertMessage:@"" withTitle:@"message sending failed"];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        CGRect Current=self.view.frame;
        Current.origin.y=0;
        [self.view setFrame:Current];
    }];
    
    return YES;
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    _activeTextField = textField;
    if (textField == collection[4] || textField == collection[5] || textField == collection[6])
    {
    NSInteger UP=-190+20;
    
    [UIView animateWithDuration:0.1 animations:^{
        CGRect Current=self.view.frame;
        Current.origin.y=UP;
        [self.view setFrame:Current];
    }];
    }
    //[self sendDimensionsToParentController:newFrame];
    return YES;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_activeTextField resignFirstResponder]; 
    }

#pragma mark
#pragma mark button actions

// user touches anywhere in the background
- (IBAction)bg_clicked:(id)sender
{
    [_activeTextField resignFirstResponder];
}

@end
