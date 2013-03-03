//
//  MytabViewController.h
//  HERES2U
//
//  Created by Paul Amador on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MytabViewController : UIViewController <UITabBarControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate>
{
    UISegmentedControl IBOutlet *segmented;
}
@end
