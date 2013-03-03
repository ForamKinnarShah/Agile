//
//  UIActivityView.m
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/8/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "UIActivityView.h"

@implementation UIActivityView
@synthesize Delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *Items=[[NSBundle mainBundle] loadNibNamed:@"UIActivityView" owner:self options:nil];
        UIActivityView *activity=[Items objectAtIndex:0];
        [self addSubview:activity];
    }
    return self;
}
- (IBAction)comment:(id)sender {
    SEL RequestSelector=@selector(activityviewRequestComment:);
    if([Delegate respondsToSelector:RequestSelector]){
        [Delegate activityviewRequestComment:self];
    }
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
