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
#import "AssetsLibrary/AssetsLibrary.h"

@interface ProfileViewController : UIViewController <UITabBarControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,NSProfileProtocol,NSImageLoaderToImageViewProtocol, NSXMLParserDelegate, UIScrollViewDelegate>{
@private
    UIButton *defaultButton; 
    NSInteger ProfileID;
    NSProfile *Profile;
    float contentLength;
    NSString *imgName1;
    NSString *imgExt1;
    UIImage *img1;
    NSString *CurrentString;
    int numberOfFeedsToLoad; 
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
@property utilities *UIBlocker; 
@property UIView *SourceSelector;

// a variable that stores profile image url
@property (strong, nonatomic)  NSURL *urlImg;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ProfileID:(NSInteger) ID;

@end
