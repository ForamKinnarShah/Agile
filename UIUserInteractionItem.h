//
//  UIUserInteractionItem.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 1/3/13.
//  Copyright (c) 2013 CSUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIUserInteractionItemProtocol.h"
@interface UIUserInteractionItem : UIView<UIGestureRecognizerDelegate>{
    @private
    UIView *OptionsView;
    BOOL animating;
}
@property (strong, nonatomic) IBOutlet UILabel *lblFullName;
@property (strong, nonatomic) IBOutlet UILabel *lblWineIQ;
@property (strong, nonatomic) IBOutlet UILabel *lblCorkzRated;
@property (strong, nonatomic) IBOutlet UIImageView *uivProfilePicture;
@property (nonatomic) NSInteger userID;
@property (nonatomic) BOOL allowsUnfollow;
@property (strong,nonatomic) id Delegate;
@property (nonatomic) BOOL allowsStopFollow;
@end
