//
//  FeedViewController.h
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSGlobalConfiguration.h"
#import "LoginViewController.h"
#import "NSUserAccessControl.h"
#import "NSFeedManager.h"
#import "NSFeedManagerProtocol.h"
#import "UIActivityView.h"
#import "CommentViewController.h"
@interface FeedViewController : UIViewController <NSFeedManagerProtocol,UITabBarControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate,NSUserAccessControlProtocol,UIActivityViewProtocol>{
    @private
    UIActivityIndicatorView *UIBlocker;
    NSFeedManager *feedManager;
    NSTimer *timer;
}
-(IBAction)search:(id)sender;

@end