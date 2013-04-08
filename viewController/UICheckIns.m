//
//  UICheckIns.m
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/15/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "UICheckIns.h"

@implementation UICheckIns
@synthesize Delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 320, 94)];
    if (self) {
        // Initialization code
        NSArray *Items=[[NSBundle mainBundle] loadNibNamed:@"UICheckIns" owner:self options:nil];
        UICheckIns *CheckInItem=[Items objectAtIndex:0];
        [self addSubview:CheckInItem];
    }
    return self;
}
- (IBAction)requestCheckIn:(id)sender {
    SEL CheckInSel=@selector(checkinRequested:);
    if([Delegate respondsToSelector:CheckInSel]){
        [Delegate checkinRequested:self];
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
