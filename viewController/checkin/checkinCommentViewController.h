//
//  checkinCommentViewController.h
//  HERES2U
//
//  Created by Paul Amador on 12/16/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICheckIns.h"
#import "NSGlobalConfiguration.h"
#import "NSUserInterfaceCommands.h"
#import "ImageViewLoading.h"

#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import <FacebookSDK/FacebookSDK.h>
#import "MGTwitterEngine.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

#define TWITTER_CONSUMER_KEY @"LH5kISWjImDe9O7v3AG6g"
#define TWITTER_CONSUMER_SECRET @"QUx8OZ7psg31JTeZI7UATBurdDTDDtGXspIfh1IF0gg"


@interface checkinCommentViewController : UIViewController<NSUserInterfaceCommandsProtocol, UITabBarControllerDelegate,UITextFieldDelegate,MGTwitterEngineDelegate>{
    @private
    UICheckIns *Checkin;
    int ProfileID;
    int  locationId;
    
    //switch
    UISwitch *switchFacebook;
    UISwitch *switchTwitter;
    
    SA_OAuthTwitterEngine *engine;
    NSString *strTwitterText;
    
    IBOutlet UIToolbar *objToolbar;
    
}
@property (strong, nonatomic) IBOutlet UITextField *CommentField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *POSTButton;
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lblResName;
@property (strong, nonatomic) IBOutlet UILabel *lblResDis;
@property (strong, nonatomic) IBOutlet UILabel *lblResAddress;



@property (strong, nonatomic) IBOutlet UIImageView *UserImage;
@property UITabBarController *tabBar;

// assign properties for tableview
@property (nonatomic, strong) IBOutlet UITableView *tblShare;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Checkin:(UICheckIns *)checkin;
-(IBAction)switchValueChanged:(UISwitch*)sender;

@end
