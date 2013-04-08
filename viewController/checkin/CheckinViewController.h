//
//  CheckinViewController.h
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSLocationLoader.h"
#import "UICheckIns.h"
#import "NSImageLoaderToImageView.h"
@interface CheckinViewController : UIViewController <UITabBarControllerDelegate, UITextFieldDelegate,UINavigationControllerDelegate,NSLocationLoaderProtocol,UICheckInsProtocol>{
    @private
    NSLocationLoader *Locations;
}
@property (strong, nonatomic) IBOutlet UIButton *FilterButton;
@property (strong, nonatomic) IBOutlet UITextField *FilterTextBox;
@property (strong, nonatomic) IBOutlet UIScrollView *LocationsView;

@end