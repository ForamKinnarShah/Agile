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
    CGRect originalToolBarFrame; 
}
@property (strong, nonatomic) IBOutlet UILabel *Title;
@property (strong, nonatomic) IBOutlet UIImageView *ProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *Time;
@property (strong, nonatomic) IBOutlet UILabel *FullName;

@property (strong, nonatomic) IBOutlet UIScrollView *CommentsScroll;
@property (strong, nonatomic) IBOutlet UILabel *MainComment;
@property (strong, nonatomic) IBOutlet UITextField *CommentText;

// stores value for comments
@property (strong, nonatomic) NSMutableArray *arrComment;
@property (strong, nonatomic) IBOutlet UITableView *tblComment;

// assign properties
@property (strong, nonatomic) IBOutlet UIImageView *imgNav;
@property (strong, nonatomic) IBOutlet UIButton *btnTitle_bg;
@property (strong, nonatomic) IBOutlet UILabel *lblBuy;
@property (strong, nonatomic) IBOutlet UIToolbar *toolTab_bg;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnPost;

// iPhone5 screen size
@property (nonatomic) CGSize screenSize;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ActivityView:(UIActivityView *)activity;

// button actions
- (IBAction)bg_clicked:(id)sender;

@end
