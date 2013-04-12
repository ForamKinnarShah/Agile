//
//  UIRegistrationForm.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/23/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIRegistrationForm : UIView<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>{
    @private
    BOOL AccountTableDone;
    BOOL ProfileTableDone;
    UIToolbar *AccessoryView;
    UIView *DOBView;
    UILabel *lblDOB;
    UIView *SourceSelector;
    UIView *TOS;
}
@property (strong, nonatomic) UITableView *RegistrationTable;
@property(strong,nonatomic) UITableView *AccountTable;
@property (strong,nonatomic) UITableView *ProfileTable;
@property (strong,nonatomic) UIImageView *ProfilePicture;
@property (strong,nonatomic) UITextField *Password;
@property (strong,nonatomic) UITextField *Email;
@property (strong,nonatomic) UITextField *Name;
@property (strong,nonatomic) UITextField *Phone;
@property (strong,nonatomic) UIDatePicker *DOB;
@property (strong,nonatomic) UITextField *ZipCode;
@property (strong,nonatomic) UIImage *currentProfilePicture;
@property (strong, nonatomic) UIBarButtonItem *Register;
@property (strong,nonatomic) UIBarButtonItem *BackButton;
@property (strong,nonatomic) UIViewController *ViewController;
@end 
