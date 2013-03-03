//
//  UIComment.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 12/20/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "UIComment.h"

@implementation UIComment
@synthesize Comment,FullName,ProfileImage,LoaderView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 320, 100)];
    if (self) {
        // Initialization code
        NSArray *ViewArray=[[NSBundle mainBundle] loadNibNamed:@"UIComment" owner:self options:nil];
        UIComment *CommentView=[ViewArray objectAtIndex:0];
     [self addSubview:CommentView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
