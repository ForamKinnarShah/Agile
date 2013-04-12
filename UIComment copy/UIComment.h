//
//  UIComment.h
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 12/20/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIComment : UIView
@property (strong,readonly, nonatomic) IBOutlet UILabel *Comment;
@property (strong, readonly,nonatomic) IBOutlet UILabel *FullName;
@property (strong, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *LoaderView;

@end
