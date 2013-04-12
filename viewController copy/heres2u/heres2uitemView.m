//
//  heres2uitemView.m
//  HERES2U
//
//  Created by Paul Sukhanov on 3/25/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "heres2uitemView.h"
#import "heres2uitemdelegate.h"

@implementation heres2uitemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *Items=[[NSBundle mainBundle] loadNibNamed:@"heres2uItemView" owner:self options:nil];
        heres2uitemView *item=[Items objectAtIndex:0];
        [self addSubview:item];

        // Initialization code
    }
    return self;
}

-(IBAction)giftAFriendPressed:(id)sender{
    if ([self.delegate respondsToSelector:@selector(giftAFriend:)])
    {
        [self.delegate giftAFriend:self];
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
