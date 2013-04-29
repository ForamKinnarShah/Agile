//
//  addViewController.h
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AssetsLibrary/AssetsLibrary.h"


@interface addViewController : UIViewController <MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate>

{
    
    IBOutletCollection(UITextField)NSArray * collection;
    IBOutlet UIButton *btnImage;
    UIImagePickerController *objPicker;
    BOOL isCamera;
}
@property UITextField *activeTextField;

-(IBAction)submitClicked:(id)sender;

//button actions
- (IBAction)bg_clicked:(id)sender;
- (IBAction)btnImage_Click:(id)sender;

@end
