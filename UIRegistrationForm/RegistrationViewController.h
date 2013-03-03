//
//  RegistrationViewController.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 11/24/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

//#import "FiveCorkzController.h"
#import "UIRegistrationForm.h"
#import "NSUserAccessControl.h"
#import "NSUserAccessControlProtocol.h"
#import "NSTaggedURLConnection.h"
@interface RegistrationViewController : UIViewController<NSUserAccessControlProtocol,UIAlertViewDelegate>{
    @private
    UIActivityIndicatorView *activity;
}
@property (strong,nonatomic) UIRegistrationForm *form;
@end
