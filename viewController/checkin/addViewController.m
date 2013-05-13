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
   // [(UIScrollView*)self.view setContentSize:self.view.bounds.size];
    // Do any additional setup after loading the view from its nib.
    NSString *centerImageName = @"logo_small.png";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];

    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    if(isiPhone5){
        btnSubmit.frame = CGRectMake(5, 406, 310, 44);
    }
    else{
        btnSubmit.frame = CGRectMake(5, 306, 310, 44);
    }
    [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"dot-green.png"] forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
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
//    [(UIScrollView*)self.view setContentSize:self.view.frame.size];
    
    if(strZip.length==0){
        UITextView *textZIP = (UITextView*)[self.view viewWithTag:7];
        if(textZIP.text.length>0){
            strZip = textZIP.text;
        }
        else{
            NSLog(@"textZIP.text : %@",textZIP.text);
        }
    }
    
    if(strBusName.length==0 || strTypeofBusiness.length==0 || strAdd.length==0 || strCity.length==0 || strState.length==0 || strZip.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heres2U" message:@"All Fields are Must be Filled !" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        return;
        
    }
    
    
    MFMailComposeViewController *mf = [[MFMailComposeViewController alloc] init];
    mf.mailComposeDelegate = self; 
    [mf setSubject:@"Request for new restaurant"];
    NSMutableString *messageBody = [[NSMutableString alloc] init];
    [messageBody appendFormat:@"Name:%@\n",strBusName];
    [messageBody appendFormat:@"Type of Business:%@\n",strTypeofBusiness];
    [messageBody appendFormat:@"Address:%@\n",strAdd];
    if (strAdd1.length>0)
    {
        [messageBody appendFormat:@"%@\n",strAdd1];
    }
    [messageBody appendFormat:@"%@, %@ %@\n",strCity,strState,strZip];
    if (checkBoxClicked)
    {
        [messageBody appendFormat:@"*This business has recently opened or will soon open\n"]; 
    }
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
        strBusName = @"";
        strTypeofBusiness = @"";
        [objTableView reloadData];
    }
    else if (result == MFMailComposeErrorCodeSendFailed || result == MFMailComposeResultFailed)
    {
        [self showAlertMessage:@"" withTitle:@"message sending failed"];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}// Default is 1 if not implemented

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = 0;
    if(section==0){
        count=2;
    }
    else{
        count=6;
    }
    
    NSLog(@"count : %d",count);
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str;
    if(section==0){
        str = @"Request a Restaurant to be Added";
    }
    else{
        str = @"Profile";
    }
    return str;
    
    
    
}// fixed font style. use custom view

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = nil;
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if(indexPath.section==0){
               
                if(indexPath.row==0){

                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                    [lbl setText:@"Business   Name "];
                    [lbl setBackgroundColor:[UIColor clearColor]];  
                    [lbl setTextColor:[UIColor blackColor]];
                    [lbl setFont:[UIFont boldSystemFontOfSize:13.0]];
                    [lbl setTextAlignment:NSTextAlignmentLeft];
                    [lbl setNumberOfLines:2.0];
                    [cell addSubview:lbl];
                    
                    CGRect textFieldFrame = CGRectMake(100.0, 10.0, 200.0, 27.0);
                    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
                    [textField setBorderStyle:UITextBorderStyleNone];
                    [textField setTextAlignment:NSTextAlignmentRight];
                    [textField setTag:1];
                    [textField setTextColor:[UIColor blueColor]];
                    [textField setFont:[UIFont systemFontOfSize:15]];
                    [textField setDelegate:self];
                    if(strBusName.length>0){
                        textField.text = strBusName;
                    }
                    else{
                        [textField setPlaceholder:@"enter text"];
                    }
                    [textField setBackgroundColor:[UIColor clearColor]];
                    textField.keyboardType = UIKeyboardTypeDefault;
                    [cell addSubview:textField];
                
                }
                else{
                
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                    [lbl setText:@"Type of Business "];
                    [lbl setBackgroundColor:[UIColor clearColor]];
                    [lbl setTextColor:[UIColor blackColor]];
                    [lbl setFont:[UIFont boldSystemFontOfSize:13.0]];
                    [lbl setTextAlignment:NSTextAlignmentLeft];
                    [lbl setNumberOfLines:2.0];
                    [cell addSubview:lbl];
                    
                    CGRect textFieldFrame = CGRectMake(100.0, 10.0, 200.0, 27.0);
                    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
                    [textField setBorderStyle:UITextBorderStyleNone];
                    [textField setTextAlignment:NSTextAlignmentRight];
                    [textField setTag:2];
                    [textField setTextColor:[UIColor blueColor]];
                    [textField setFont:[UIFont systemFontOfSize:15]];
                    [textField setDelegate:self];
                    if(strTypeofBusiness.length>0){
                        textField.text = strTypeofBusiness;
                    }
                    else{
                        [textField setPlaceholder:@"enter text"];
                    }
                    [textField setBackgroundColor:[UIColor clearColor]];
                    textField.keyboardType = UIKeyboardTypeDefault;
                    [cell addSubview:textField];
                }
                
            }
            else{
                
                if(indexPath.row==0){
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                    [lbl setText:@"Address "];
                    [lbl setBackgroundColor:[UIColor clearColor]];
                    [lbl setTextColor:[UIColor blackColor]];
                    [lbl setFont:[UIFont boldSystemFontOfSize:13.0]];
                    [lbl setTextAlignment:NSTextAlignmentLeft];
                    [lbl setNumberOfLines:2.0];
                    [cell addSubview:lbl];
                    
                    CGRect textFieldFrame = CGRectMake(100.0, 10.0, 200.0, 27.0);
                    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
                    [textField setBorderStyle:UITextBorderStyleNone];
                    [textField setTextAlignment:NSTextAlignmentRight];
                    [textField setTag:3];
                    [textField setTextColor:[UIColor blueColor]];
                    [textField setFont:[UIFont systemFontOfSize:15]];
                    [textField setDelegate:self];
                    [textField setPlaceholder:@"enter text"];
                    [textField setBackgroundColor:[UIColor clearColor]];
                    textField.keyboardType = UIKeyboardTypeDefault;
                    [cell addSubview:textField];
                }
                else if(indexPath.row==1){
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                    [lbl setText:@"Address1 "];
                    [lbl setBackgroundColor:[UIColor clearColor]];
                    [lbl setTextColor:[UIColor blackColor]];
                    [lbl setFont:[UIFont boldSystemFontOfSize:13.0]];
                    [lbl setTextAlignment:NSTextAlignmentLeft];
                    [lbl setNumberOfLines:2.0];
                    [cell addSubview:lbl];
                    
                    CGRect textFieldFrame = CGRectMake(100.0, 10.0, 200.0, 27.0);
                    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
                    [textField setBorderStyle:UITextBorderStyleNone];
                    [textField setTextAlignment:NSTextAlignmentRight];
                    [textField setTag:4];
                    [textField setTextColor:[UIColor blueColor]];
                    [textField setFont:[UIFont systemFontOfSize:15]];
                    [textField setDelegate:self];
                    [textField setPlaceholder:@"enter text"];
                    [textField setBackgroundColor:[UIColor clearColor]];
                    textField.keyboardType = UIKeyboardTypeDefault;
                    [cell addSubview:textField];
                }
                else if(indexPath.row==2){
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                    [lbl setText:@"City "];
                    [lbl setBackgroundColor:[UIColor clearColor]];
                    [lbl setTextColor:[UIColor blackColor]];
                    [lbl setFont:[UIFont boldSystemFontOfSize:13.0]];
                    [lbl setTextAlignment:NSTextAlignmentLeft];
                    [lbl setNumberOfLines:2.0];
                    [cell addSubview:lbl];
                    
                    CGRect textFieldFrame = CGRectMake(100.0, 10.0, 200.0, 27.0);
                    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
                    [textField setBorderStyle:UITextBorderStyleNone];
                    [textField setTextAlignment:NSTextAlignmentRight];
                    [textField setTag:5];
                    [textField setTextColor:[UIColor blueColor]];
                    [textField setFont:[UIFont systemFontOfSize:15]];
                    [textField setDelegate:self];
                    [textField setPlaceholder:@"enter text"];
                    [textField setBackgroundColor:[UIColor clearColor]];
                    textField.keyboardType = UIKeyboardTypeDefault;
                    [cell addSubview:textField];
                }
                else if(indexPath.row==3){
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                    [lbl setText:@"State "];
                    [lbl setBackgroundColor:[UIColor clearColor]];
                    [lbl setTextColor:[UIColor blackColor]];
                    [lbl setFont:[UIFont boldSystemFontOfSize:13.0]];
                    [lbl setTextAlignment:NSTextAlignmentLeft];
                    [lbl setNumberOfLines:2.0];
                    [cell addSubview:lbl];
                    
                    CGRect textFieldFrame = CGRectMake(100.0, 10.0, 200.0, 27.0);
                    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
                    [textField setBorderStyle:UITextBorderStyleNone];
                    [textField setTextAlignment:NSTextAlignmentRight];
                    [textField setTag:6];
                    [textField setTextColor:[UIColor blueColor]];
                    [textField setFont:[UIFont systemFontOfSize:15]];
                    [textField setDelegate:self];
                    [textField setPlaceholder:@"enter text"];
                    [textField setBackgroundColor:[UIColor clearColor]];
                    textField.keyboardType = UIKeyboardTypeDefault;
                    [cell addSubview:textField];
                }
                else if(indexPath.row==4){
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                    [lbl setText:@"Zip "];
                    [lbl setBackgroundColor:[UIColor clearColor]];
                    [lbl setTextColor:[UIColor blackColor]];
                    [lbl setFont:[UIFont boldSystemFontOfSize:13.0]];
                    [lbl setTextAlignment:NSTextAlignmentLeft];
                    [lbl setNumberOfLines:2.0];
                    [cell addSubview:lbl];
                    
                    CGRect textFieldFrame = CGRectMake(100.0, 10.0, 200.0, 27.0);
                    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
                    [textField setBorderStyle:UITextBorderStyleNone];
                    [textField setTextAlignment:NSTextAlignmentRight];
                    [textField setTag:7];
                    [textField setTextColor:[UIColor blueColor]];
                    [textField setFont:[UIFont systemFontOfSize:15]];
                    [textField setDelegate:self];
                    [textField setPlaceholder:@"enter text"];
                    [textField setBackgroundColor:[UIColor clearColor]];
                    textField.keyboardType = UIKeyboardTypeDefault;
                    [cell addSubview:textField];
                }
                else if(indexPath.row==5){
                    
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 260, 30)];
                    [lbl setText:@"This business recently opened or is opening soon."];
                    [lbl setBackgroundColor:[UIColor clearColor]];
                    [lbl setTextColor:[UIColor blackColor]];
                    [lbl setFont:[UIFont boldSystemFontOfSize:13.0]];
                    [lbl setTextAlignment:NSTextAlignmentLeft];
                    [lbl setNumberOfLines:2.0];
                    [cell addSubview:lbl];
                    
                    UIButton *checkBox = [[UIButton alloc] initWithFrame:CGRectMake(275, 4, 30, 30)];
                    //[checkBox setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
                    [checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
                    [checkBox setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateSelected];
                    //[checkBox setBackgroundImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateSelected];
                    [checkBox setUserInteractionEnabled:YES];
                    [checkBox setContentMode:UIViewContentModeCenter]; 
                    [checkBox addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:checkBox]; 
                    
                }
            //    else if(indexPath.row==6){
                    
//                    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
//                    btnSubmit.frame = CGRectMake(30, 0, 260, 40);
//                    [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
//                    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"buttonProfile.png"] forState:UIControlStateNormal];
//                    [btnSubmit addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell addSubview:btnSubmit];
                    
              //  }
                
                
            }
          
        }
        return cell;
    }
    @catch (NSException *exception) {
        NSLog(@"NSException : %@",exception);
    }
    
}

-(void)checkBoxClicked:(UIButton*)sender
{
    [sender setSelected:![sender isSelected]];
    checkBoxClicked = !checkBoxClicked; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
   
    if(textField.tag==1){
        if(textField.text.length>0){
            strBusName = textField.text;
        }
    }
    else if(textField.tag==2){
        if(textField.text.length>0){
            strTypeofBusiness = textField.text;
        }
    }
    else if(textField.tag==3){
        if(textField.text.length>0){
            strAdd = textField.text;
        }
    }
    else if(textField.tag==4){
        if(textField.text.length>0){
            strAdd1 = textField.text;
        }
    }
    else if(textField.tag==5){
        if(textField.text.length>0){
            strCity = textField.text;
        }
    }
    else if(textField.tag==6){
        if(textField.text.length>0){
            strState = textField.text;
        }
    }
    else if(textField.tag==7){
        if(textField.text.length>0){
            strZip = textField.text;
        }
    }

    
    if(self.view.frame.origin.y!=0){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.25];
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView commitAnimations];
    }
    
    return YES;
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    if(textField.tag==1){
        if(textField.text.length>0){
            strBusName = textField.text;
        }
        else{
            strBusName  = @"";
        }
    }
    else if(textField.tag==2){
        if(textField.text.length>0){
            strTypeofBusiness = textField.text;
        }
        else{
            strTypeofBusiness  = @"";
        }
    }
    else if(textField.tag==3){
        if(textField.text.length>0){
            strAdd = textField.text;
        }
        else{
            strAdd  = @"";
        }
    }
    else if(textField.tag==4){
        if(textField.text.length>0){
            strAdd1 = textField.text;
        }
        else{
            strAdd1  = @"";
        }
    }
    else if(textField.tag==5){
        if(textField.text.length>0){
            strCity = textField.text;
        }
        else{
            strCity  = @"";
        }

    }
    else if(textField.tag==6){
        if(textField.text.length>0){
            strState = textField.text;
        }
        else{
            strState  = @"";
        }
    }
    else if(textField.tag==7){
        if(textField.text.length>0){
            strZip = textField.text;
        }
        else{
            strZip  = @"";
        }
    }
    
    return YES;
}
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag>=3){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.25];
        self.view.transform = CGAffineTransformMakeTranslation(0, -130);
        [UIView commitAnimations];
    }
    else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.25];
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView commitAnimations];
    }

    return YES;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

#pragma mark
#pragma mark button actions

// user touches anywhere in the background
- (IBAction)bg_clicked:(id)sender
{
    [_activeTextField resignFirstResponder];
}

@end
