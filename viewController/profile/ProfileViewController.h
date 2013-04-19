//
//  ProfileViewController.h
//  HERES2U
//
//  Created by Paul Amador on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSGlobalConfiguration.h"
#import "FollowingViewController.h"
#import "NSProfile.h"
#import "NSImageLoaderToImageView.h"
#import "UIActivityView.h"
#import "CommentViewController.h"
#import "utilities.h" 

@interface ProfileViewController : UIViewController <UITabBarControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,NSProfileProtocol,NSImageLoaderToImageViewProtocol>{
@private
    NSInteger ProfileID;
    NSProfile *Profile;
}
@property (strong, nonatomic) IBOutlet UIScrollView *ProSroll;
@property (strong, nonatomic) IBOutlet UIImageView *ProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *FollowingCount;
@property (strong, nonatomic) IBOutlet UIImageView *FollowingRect;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ImageLoader;
@property (strong, nonatomic) IBOutlet UIImageView *FollowersRect;
@property (strong, nonatomic) IBOutlet UILabel *FollowersCount;
@property (strong, nonatomic) IBOutlet UILabel *UserName;
@property (strong, nonatomic) IBOutlet UILabel *FollowButton;
@property (strong, nonatomic) IBOutlet UIButton *btnFollowBack;
@property IBOutlet UIButton *defaultViewButton;
@property utilities *UIBlocker; 
@property UIView *SourceSelector;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ProfileID:(NSInteger) ID;
@end
