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
@interface checkinCommentViewController : UIViewController<NSUserInterfaceCommandsProtocol>{
    @private
    UICheckIns *Checkin;
}
@property (strong, nonatomic) IBOutlet UITextField *CommentField;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIButton *POSTButton;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *UserImage;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Checkin:(UICheckIns *)checkin;
@end
