//
//  FollowingViewController.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 7/14/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUserInteractionItem.h"
#import "NSUserInterfaceCommands.h"
#import "NSFollowersDatasource.h"
#import "NSImageLoaderToImageView.h"
#import "NSFollowingDatasource.h"
#import "NSGlobalConfiguration.h"
#import "NSSearchForUser.h"
@interface FollowingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSFollowersDatasourceProtocol,NSFollowingDatasourceProtocol,NSUserInterfaceCommandsProtocol,UISearchBarDelegate,NSSearchForUserProtocol>{
    @private
    BOOL isFollowers;
    NSFollowersDatasource *Followers;
    NSFollowingDatasource *Followees;
    UIActivityIndicatorView *UIBlocker;
    NSMutableArray *OutputData;
    NSMutableArray *ServerSearchResults;
    NSSearchForUser *Search;
}
@property (strong, nonatomic) IBOutlet UITableView *userstable;
@property int ID; 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ID:(int)ID;

@end
