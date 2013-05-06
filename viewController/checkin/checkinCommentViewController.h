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

@interface checkinCommentViewController : UIViewController<NSUserInterfaceCommandsProtocol, UITabBarControllerDelegate>{
    @private
    UICheckIns *Checkin;
    int ProfileID;
}
@property (strong, nonatomic) IBOutlet UITextField *CommentField;
@property (strong, nonatomic) IBOutlet UIButton *POSTButton;
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lblResName;
@property (strong, nonatomic) IBOutlet UILabel *lblResDis;
@property (strong, nonatomic) IBOutlet UILabel *lblResAddress;



@property (strong, nonatomic) IBOutlet UIImageView *UserImage;
@property UITabBarController *tabBar; 
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Checkin:(UICheckIns *)checkin;
@end
