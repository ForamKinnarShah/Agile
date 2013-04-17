//
//  UIRegistrationForm.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/23/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "UIRegistrationForm.h"

@implementation UIRegistrationForm
@synthesize RegistrationTable,AccountTable,ProfileTable,ProfilePicture,Password,Email,Name,Phone,DOB,ZipCode,Register,BackButton,ViewController,currentProfilePicture;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        AccountTableDone=YES;
        ProfileTableDone=YES;
        // Initialization code
        UIToolbar *NavigationBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [NavigationBar setTintColor:[UIColor grayColor]];
        BackButton=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemAction target:self action:@selector(backButtonPressed:)];
        UIBarButtonItem *Flexiblity=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        Register=[[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleBordered target:self action:nil];
        NSArray *TBButtons=[[NSArray alloc] initWithObjects:BackButton,Flexiblity,Register, nil];
        [NavigationBar setItems:TBButtons];
        AccessoryView=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [AccessoryView setTintColor:[UIColor grayColor]];
        UIBarButtonItem *BtnDone=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard:)];
        UIBarButtonItem *FlexSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *buttons=[[NSArray alloc] initWithObjects:FlexSpace,BtnDone, nil];
        [AccessoryView setItems:buttons];
        RegistrationTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.frame.size.height-44) style:UITableViewStyleGrouped];
        AccountTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 221, 70) style:UITableViewStylePlain];
        ProfileTable=[[UITableView alloc] initWithFrame:CGRectMake(12, 5, 296, 165) style:UITableViewStylePlain];
        [ProfileTable setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
        [RegistrationTable setAllowsSelection:NO];
        [RegistrationTable setUserInteractionEnabled:YES];
        [RegistrationTable setTag:0];
        [AccountTable setTag:1];
        [ProfileTable setTag:2];
        [RegistrationTable setDelegate:self];
        [RegistrationTable setDataSource:self];
        [AccountTable setDelegate:self];
        [AccountTable setDataSource:self];
        [ProfileTable setDelegate:self];
        [ProfileTable setDataSource:self];
        [ProfileTable setAllowsSelection:NO];
        [AccountTable setBackgroundColor:[UIColor clearColor]];
        [ProfileTable setBackgroundColor:[UIColor clearColor]];
        [AccountTable setUserInteractionEnabled:YES];
        [RegistrationTable setAllowsSelection:NO];
        [AccountTable setAllowsSelection:NO];
        [ProfileTable reloadData];
        [self addSubview:RegistrationTable];
        [self addSubview:NavigationBar];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//Delegates:
//TableViewDelegates:
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView tag]==0){
        return 1;
    }else{
        if([tableView tag]==1){
            return 2;
        }else{
            if([tableView tag]==2){
                return 5;
            }else{
                NSLog(@"Returning 0");
                return 0;
            }
        }
    }
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if([tableView tag]==0){
        return 3;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView tag]==0){
        if(indexPath.section==0){
            return 87;
        }else{
            if(indexPath.section==1){
            return (33*5)+10;
            }else{
                return 50;
            }
        }
    }else{
        //if([tableView tag]==2 && indexPath.row==3){
          //  return 122;
        //}
        return 33;
    }
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0 && tableView.tag==0){
        return @"Account Information";
    }else{
        if(tableView.tag==0 && section==1)
        return @"Profile Information";
    }
        return nil;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView.tag==0){
    return 25.0;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Current: %i",tableView.tag);
    switch (tableView.tag) {
        case 0:
            //Registration View
            switch (indexPath.section) {
                case 0:{
                    //Account Info
                    UITableViewCell *cell=[RegistrationTable dequeueReusableCellWithIdentifier:@"Cell"];
                    if (!cell) {
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    }
                    [cell addSubview:AccountTable];
                    ProfilePicture=[[UIImageView alloc] init];
                    [cell addSubview:ProfilePicture];
                    UITapGestureRecognizer *picturetap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
                    [ProfilePicture addGestureRecognizer:picturetap];
                    [ProfilePicture setUserInteractionEnabled:YES];
                    NSLog(@"Cell width: %f",cell.frame.size.width);
                    [AccountTable setFrame:CGRectMake(87, 12, 221, 66)];
                    [ProfilePicture setFrame:CGRectMake(15, 12, 66, 66)];
                    [ProfilePicture setImage:[UIImage imageNamed:@"photo"]];
                    return cell;
                    break;
                }
                case 1:{
                    //Profile Info
                    UITableViewCell *cell=[RegistrationTable dequeueReusableCellWithIdentifier:@"Cell"];
                    if (!cell) {
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    }
                    [cell addSubview:ProfileTable];
                    return cell;
                    break;
                }
                case 2:{
                    UILabel *TOS=[[UILabel alloc] initWithFrame:CGRectMake(12, -9, 296, 50)];
                    [TOS setLineBreakMode:NSLineBreakByWordWrapping];
                    [TOS setNumberOfLines:0];
                    [TOS setFont:[UIFont systemFontOfSize:11.0]];
                    [TOS setTextAlignment:NSTextAlignmentCenter];
                    [TOS setTextColor:[UIColor grayColor]];
                    [TOS setBackgroundColor:[UIColor clearColor]];
                    [TOS setText:@"By clicking Register, you are indicating that you have read and agreed to the"];
                    UILabel *TOSLink=[[UILabel alloc] initWithFrame:CGRectMake(12, 35, 296, 9)];
                    [TOSLink setLineBreakMode:NSLineBreakByWordWrapping];
                    [TOSLink setNumberOfLines:0];
                    [TOSLink setFont:[UIFont systemFontOfSize:12.0]];
                    [TOSLink setTextAlignment:NSTextAlignmentCenter];
                    [TOSLink setTextColor:[UIColor blueColor]];
                    [TOSLink setBackgroundColor:[UIColor clearColor]];
                    [TOSLink setText:@"Terms of Service"];
                    UITapGestureRecognizer *tostap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTOS:)];
                    //[TOSLink addGestureRecognizer:tostap];
                    //[TOSLink setUserInteractionEnabled:YES];
                    UITableViewCell *cell=[RegistrationTable dequeueReusableCellWithIdentifier:@"Cell"];
                    if(!cell){
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    }
                    [cell setUserInteractionEnabled:YES];
                    [cell addGestureRecognizer:tostap];
                    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
                    [cell addSubview:TOS];
                    [cell addSubview:TOSLink];
                    return cell;
                    break;
                }
                default:{
                    return [[UITableViewCell alloc] init];
                    break;
                }
            }
            break;
        case 1:
            //Account View
            switch (indexPath.row) {
                case 0:{
                    //Email
                    if(!Email){
                        Email=[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 216, 33)];
                    }
                    [Email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [Email setAutocorrectionType:UITextAutocorrectionTypeNo]; 
                    [Email setInputAccessoryView:AccessoryView];
                    [Email setPlaceholder:@"Email"];
                    [Email setTextColor:[UIColor grayColor]];
                    [Email addTarget:self action:@selector(textFieldDismissed:) forControlEvents:UIControlEventEditingDidEnd];
                    [Email addTarget:self action:@selector(textFieldSelected:) forControlEvents:UIControlEventEditingDidBegin];
                    UITableViewCell *cell=[AccountTable dequeueReusableCellWithIdentifier:@"Cell"];
                    if (!cell) {
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    }
                    [cell addSubview:Email];
                    
                    return cell;
                    break;
                }
                case 1:{
                    //Password
                    if(!Password){
                        Password=[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 216, 33)];

                    }
                    [Password setInputAccessoryView:AccessoryView];
                    [Password setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [Password setAutocorrectionType:UITextAutocorrectionTypeNo];
                    [Password setTextColor:[UIColor grayColor]];
                    [Password setPlaceholder:@"Password"];
                    [Password addTarget:self action:@selector(textFieldSelected:) forControlEvents:UIControlEventEditingDidBegin];
                    [Password addTarget:self action:@selector(textFieldDismissed:) forControlEvents:UIControlEventEditingDidEnd];
                    UITableViewCell *cell=[AccountTable dequeueReusableCellWithIdentifier:@"Cell"];
                    if (!cell) {
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    }
                    
                    [cell addSubview:Password];
                    return cell;
                    break;
                }
                default:{
                    return [[UITableViewCell alloc] init];
                    break;
                }
            }
            break;
        case 2:
            //ProfileView
            switch (indexPath.row) {
                case 0:{
                    //Facebook Login
                    UIButton *btnFacebookLogin=[[UIButton alloc] initWithFrame:CGRectMake(5, 5, 150, 22)];
                    [btnFacebookLogin setBackgroundImage:[UIImage imageNamed:@"loginFacebook"] forState:UIControlStateNormal];
                    UITableViewCell *cell=[ProfileTable dequeueReusableCellWithIdentifier:@"Cell"];
                    if (!cell) {
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    }
                    [cell addSubview:btnFacebookLogin];
                    return cell;
                    break;
                }
                case 1:{
                    //Name
                    if(!Name){
                        Name=[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 216, 33)];
                    }
                    [Name setTextColor:[UIColor grayColor]];
                    [Name setInputAccessoryView:AccessoryView];
                    [Name addTarget:self action:@selector(textFieldSelected:) forControlEvents:UIControlEventEditingDidBegin];
                    [Name addTarget:self action:@selector(textFieldDismissed:) forControlEvents:UIControlEventEditingDidEnd];
                    [Name setPlaceholder:@"Full Name"];
                    
                    UITableViewCell *cell=[ProfileTable dequeueReusableCellWithIdentifier:@"Cell"];
                    if (!cell) {
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    }
                    [cell addSubview:Name];
                    return cell;
                    break;
                }
                case 2:{
                    //phone
                    if(!Phone){
                        Phone=[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 216, 33)];
                    }
                    [Phone setTextColor:[UIColor grayColor]];
                    [Phone setInputAccessoryView:AccessoryView];
                    [Phone setKeyboardType:UIKeyboardTypeNumberPad];
                    [Phone addTarget:self action:@selector(textFieldDismissed:) forControlEvents:UIControlEventEditingDidEnd];
                    [Phone setPlaceholder:@"Phone"];
                    [Phone addTarget:self action:@selector(textFieldSelected:) forControlEvents:UIControlEventEditingDidBegin];
                    UITableViewCell *cell=[ProfileTable dequeueReusableCellWithIdentifier:@"Cell"];
                    if (!cell) {
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    }
                    [cell addSubview:Phone];
                    return cell;
                    break;
                }
                case 3:{
                    //DOB
                   if(!DOB){
                        DOB=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320,216)];
                       [DOB setDatePickerMode:UIDatePickerModeDate];
                       [DOB setMaximumDate:[NSDate date]];
                       // NSLog(@"CreatedDOB");
                    }
                    //[DOB setFrame:CGRectMake(0, 0, 296, 66)];
                    DOBView=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-256, 320, 256)];
                    UIToolbar *DOBToolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
                    UIBarButtonItem *FlexSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                    UIBarButtonItem *DoneBtn=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(selectedDOB:)];
                    NSArray *btnarray=[[NSArray alloc] initWithObjects:FlexSpace,DoneBtn, nil];
                    [DOBToolbar setItems:btnarray];
                    [DOBToolbar setTintColor:[UIColor grayColor]];
                    [DOBView addSubview:DOBToolbar];
                    [DOBView addSubview:DOB];
                    lblDOB=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 296, 33)];
                    [lblDOB setText:@"Date of birth"];
                    UITapGestureRecognizer *dobtap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DOBClicked:)];
                    [lblDOB setUserInteractionEnabled:YES];
                    [lblDOB addGestureRecognizer:dobtap];
                    [lblDOB setBackgroundColor:[UIColor clearColor]];
                    [lblDOB setTextColor:[UIColor lightGrayColor]];
                    UITableViewCell *cell=[ProfileTable dequeueReusableCellWithIdentifier:@"Cell"];
                    if (!cell) {
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    }
                   [cell addSubview:lblDOB];
                    return cell;
                    break;
                }
                case 4:{
                    //ZipCode
                    if(!ZipCode){
                        ZipCode=[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 216, 33)];
                    }
                    [ZipCode setKeyboardType:UIKeyboardTypeNumberPad];
                    [ZipCode setTextColor:[UIColor grayColor]];
                    
                    [ZipCode setInputAccessoryView:AccessoryView];
                    [ZipCode addTarget:self action:@selector(textFieldSelected:) forControlEvents:UIControlEventEditingDidBegin];
                    [ZipCode addTarget:self action:@selector(textFieldDismissed:) forControlEvents:UIControlEventEditingDidEnd];
                    [ZipCode setPlaceholder:@"Zip Code"];
                    UITableViewCell *cell=[ProfileTable dequeueReusableCellWithIdentifier:@"Cell"];
                    if (!cell) {
                        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    }
                    [cell addSubview:ZipCode];
                    return cell;
                    break;
                }
                default:{
                    break;
                }
            }
            break;
        default:
            break;
    }
}
-(IBAction)selectedDOB:(id) sender{
    NSDateFormatter *Formatter=[[NSDateFormatter alloc] init];
    [Formatter setDateFormat:@"MM/dd/yyyy"];
    CGRect FinalFrame=DOBView.frame;
    FinalFrame.origin.y=self.frame.size.height;
    if(sender!=nil){
    [lblDOB setText:[Formatter stringFromDate:[DOB date]]];
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [DOBView setFrame:FinalFrame];
    }completion:^(BOOL finished){
        [DOBView removeFromSuperview];
    }];
}
-(void)DOBClicked:(UIGestureRecognizer *)event{
    CGRect FinalFrame=CGRectMake(0, self.frame.size.height-256, 320, 256);
    CGRect InitialFrame=DOBView.frame;
    InitialFrame.origin.y=self.frame.size.height;
    [self dismissKeyboard:nil];
    [DOBView setFrame:InitialFrame];
    [self addSubview:DOBView];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [DOBView setFrame:FinalFrame];
    }completion:^(BOOL finished){
        
    }];
}
-(void) selectPhoto:(UIGestureRecognizer *)gesture{
    if(!SourceSelector){
    SourceSelector=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 320, 216)];
    [SourceSelector setBackgroundColor:[UIColor grayColor]];
    //UIButton *CameraButton=[[UIButton alloc] initWithFrame:CGRectMake(12, 12, 296, 44)];
    UIButton *CameraButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [CameraButton setFrame:CGRectMake(12, 12, 296, 44)];
    [CameraButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    [CameraButton setTitle:@"Take a Photo" forState:UIControlStateNormal];
    [CameraButton setTintColor:[UIColor grayColor]];
    UIButton *GalleryButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];//[[UIButton alloc] initWithFrame:CGRectMake(12, 68, 296, 44)];
    [GalleryButton setFrame:CGRectMake(12, 68, 296, 44)];
    [GalleryButton setTitle:@"Choose from Gallery" forState:UIControlStateNormal];
    [GalleryButton setTintColor:[UIColor grayColor]];
    [GalleryButton addTarget:self action:@selector(selectFromLibrary:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *CancelButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];//[[UIButton alloc] initWithFrame:CGRectMake(12, 80, 296, 44)];
    [CancelButton setFrame:CGRectMake(12, 124, 296, 44)];
    [CancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    //UIToolbar *back=[[UIToolbar alloc] initWithFrame:CancelButton.frame];
    [CancelButton setTintColor:[UIColor grayColor]];
    [CancelButton addTarget:self action:@selector(cancelPhotoSet:) forControlEvents:UIControlEventTouchUpInside];
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [CameraButton setEnabled:NO];
    }
    [SourceSelector addSubview:CameraButton];
    [SourceSelector addSubview:GalleryButton];
    [SourceSelector addSubview:CancelButton];
    }
    CGRect FinalFrame=CGRectMake(0, self.frame.size.height-216, 320, 216);
    [self addSubview:SourceSelector];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [SourceSelector setFrame:FinalFrame];
    }completion:nil];
    [self dismissKeyboard:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *PickedImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    currentProfilePicture=[PickedImage copy];
    if ([picker sourceType]==UIImagePickerControllerSourceTypeCamera) {
        //NSLog(@"Saved Image");
        UIImageWriteToSavedPhotosAlbum(PickedImage, nil, nil, nil);
    }
    CGSize newSize=PickedImage.size;
    if (PickedImage.size.height>PickedImage.size.width) {
        CGFloat Height=620.0;
        CGFloat Width= (620.0*PickedImage.size.width)/PickedImage.size.height;
        newSize.height=Height;
        newSize.width=Width;
    }else{
        CGFloat Width=620.0;
        CGFloat Height=(620.0*PickedImage.size.height)/PickedImage.size.width;
        newSize.width=Width;
        newSize.height=Height;
    }
    UIGraphicsBeginImageContext(newSize);
    [PickedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *ScaledImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [ProfilePicture setImage:ScaledImage];
    [picker dismissModalViewControllerAnimated:YES];
    [self cancelPhotoSet:nil];
}
-(IBAction)takePicture:(id)sender{
     UIImagePickerController *controller=[[UIImagePickerController alloc] init];
    [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
    [controller setShowsCameraControls:YES];
    [controller setDelegate:self];
    [ViewController presentModalViewController:controller animated:YES];
}
-(IBAction)selectFromLibrary:(id)sender{
    NSLog(@"Select picture");
    UIImagePickerController *controller=[[UIImagePickerController alloc] init];
    [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [controller setDelegate:self];
    //[controller setShowsCameraControls:YES];
    [ViewController presentModalViewController:controller animated:YES];
}
-(IBAction)cancelPhotoSet:(id)sender{
    CGRect Final=CGRectMake(0, self.frame.size.height, 320, 216);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [SourceSelector setFrame:Final];
    }completion:^(BOOL finished){
        [SourceSelector removeFromSuperview];
    }];
}
-(IBAction)textFieldSelected:(UITextField*)sender{
    NSLog(@"editing began");
    [self selectedDOB:nil];
    /*if(sender==Username){
        if([sender.text isEqualToString:@"Username"]){
            [sender setText:@""];
            [sender setTextColor:[UIColor blackColor]];
        }
    }else{
        if(sender==Password){
            if([sender.text isEqualToString:@"Password"]){
                [sender setText:@""];
                [sender setTextColor:[UIColor blackColor]];
            }
        }else{
            if(sender==Email){
                if([sender.text isEqualToString:@"Email Address"]){
                    [sender setText:@""];
                    [sender setTextColor:[UIColor blackColor]];
                }
            }else{
                if(sender==Phone){
                    if([sender.text isEqualToString:@"Phone"]){
                        [sender setText:@""];
                        [sender setTextColor:[UIColor blackColor]];
                    }
                }else{
                    if(sender==ZipCode){
                        if([sender.text isEqualToString:@"Zip Code"]){
                            [sender setText:@""];
                            [sender setTextColor:[UIColor blackColor]];
                        }
                    }else{
                        if(sender==Name){
                            if([sender.text isEqualToString:@"Full Name"]){
                                [sender setText:@""];
                                [sender setTextColor:[UIColor blackColor]];
                            }
                        }
                    }
                }
            }
        }
    }*/
    CGRect set=[sender convertRect:sender.frame toView:self];
    if(set.origin.y+33>480-265){
       // NSInteger runs=set.origin.y-264;
        CGRect Final=RegistrationTable.frame;
        Final.origin.y=480-265-33-set.origin.y;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
           // if(counter<runs){
            [RegistrationTable setFrame:Final];
            NSLog(@"running animation");
        }completion:^(BOOL finished){
            
        }];
    }
}
-(IBAction)textFieldDismissed:(UITextField*)sender{
    NSLog(@"Ended");
    [sender resignFirstResponder];
    CGRect Final=RegistrationTable.frame;
    Final.origin.y=44;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [RegistrationTable setFrame:Final];
    }completion:^(BOOL finished){
        
    }];
    
       /* if(sender==Password){
            if([sender.text isEqualToString:@"Password"] || [sender.text isEqualToString:@""]){
                [sender setText:@"Password"];
                [sender setTextColor:[UIColor grayColor]];
            }
        }else{
            if(sender==Email){
                if([sender.text isEqualToString:@"Email Address"] || [sender.text isEqualToString:@""]){
                    [sender setText:@"Email Address"];
                    [sender setTextColor:[UIColor grayColor]];
                }
            }else{
                if(sender==Phone){
                    if([sender.text isEqualToString:@"Phone"] || [sender.text isEqualToString:@""]){
                        [sender setText:@"Phone"];
                        [sender setTextColor:[UIColor grayColor]];
                    }
                }else{
                    if(sender==ZipCode){
                        if([sender.text isEqualToString:@"Zip Code"] || [sender.text isEqualToString:@""]){
                            [sender setText:@"Zip Code"];
                            [sender setTextColor:[UIColor grayColor]];
                        }
                    }else{
                        if(sender==Name){
                            if([sender.text isEqualToString:@"Full Name"] || [sender.text isEqualToString:@""]){
                                [sender setText:@"Full Name"];
                                [sender setTextColor:[UIColor grayColor]];
                            }
                        }
                    }
                }
            }
        }*/
    
}
-(IBAction)dismissKeyboard:(id)sender{
   // [Username resignFirstResponder];
    [Password resignFirstResponder];
    [Email resignFirstResponder];
    [Phone resignFirstResponder];
    [Name resignFirstResponder];
    [ZipCode resignFirstResponder];
    CGRect Final=RegistrationTable.frame;
    Final.origin.y=44;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [RegistrationTable setFrame:Final];
    }completion:^(BOOL finished){
        
    }];


}
-(void) dismissTOS:(id)sender{
    CGRect FinalFrame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height-44);
    //[self addSubview:TOS];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [TOS setFrame:FinalFrame];
    }completion:^(BOOL finished){
        [TOS removeFromSuperview];
    }];

}
-(void) showTOS:(UIGestureRecognizer *)gesture{
    NSLog(@"TOS Showing");
    if(!TOS){
   TOS=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIToolbar *TBTOS=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissTOS:)];
    [TBTOS setTintColor:[UIColor grayColor]];
    [TBTOS setItems:[[NSArray alloc] initWithObjects:backBtn, nil]];
    [TOS addSubview:TBTOS];
    UIWebView *wvDoc=[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-44)];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"TOS" ofType:@"html"];
    NSURL *url=[NSURL fileURLWithPath:path];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [wvDoc loadRequest:request];
    [TOS addSubview:wvDoc];
    }
    CGRect FinalFrame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
    CGRect InitialFrame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
    InitialFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
    [TOS setFrame:InitialFrame];
    [self addSubview:TOS];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [TOS setFrame:FinalFrame];
    }completion:nil];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    NSLog(@"Touch Detected");
    if(touch.view!=Password && touch.view !=Email && touch.view!=Phone && touch.view!=ZipCode){
        //[Username resignFirstResponder];
        [Password resignFirstResponder];
        [Email resignFirstResponder];
        [Phone resignFirstResponder];
        [ZipCode resignFirstResponder];
        CGRect Final=RegistrationTable.frame;
        Final.origin.y=44;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [RegistrationTable setFrame:Final];
        }completion:^(BOOL finished){
            
        }];
    }
}
@end
