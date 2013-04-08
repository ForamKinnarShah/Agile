//
//  CommentViewController.h
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIActivityView.h"
#import "NSUserInterfaceCommands.h"
#import "UIComment.h"
#import "NSCommentLoader.h"
@interface CommentViewController : UIViewController<NSUserInterfaceCommandsProtocol,UITextFieldDelegate,NSCommentLoaderProtocol>{
    @private
    UIActivityView *internal;
}
@property (strong, nonatomic) IBOutlet UILabel *Title;
@property (strong, nonatomic) IBOutlet UIImageView *ProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *Time;
@property (strong, nonatomic) IBOutlet UILabel *FullName;

@property (strong, nonatomic) IBOutlet UIScrollView *CommentsScroll;
@property (strong, nonatomic) IBOutlet UILabel *MainComment;
@property (strong, nonatomic) IBOutlet UITextField *CommentText;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ActivityView:(UIActivityView *)activity;
@end
