//
//  UIUserInteractionItem.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 1/3/13.
//  Copyright (c) 2013 CSUS. All rights reserved.
//

#import "UIUserInteractionItem.h"

@implementation UIUserInteractionItem
@synthesize uivProfilePicture,lblCorkzRated,lblFullName,lblWineIQ,allowsStopFollow,allowsUnfollow,userID,Delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 320, 70)];
    if (self) {
        // Initialization code
        NSArray *Items=[[NSBundle mainBundle] loadNibNamed:@"UIUserInteractionItem" owner:self options:nil];
        UIUserInteractionItem *me=[Items objectAtIndex:0];
        [self addSubview:me];
        UIPanGestureRecognizer *PanGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        [PanGesture setDelegate:self];
        [self addGestureRecognizer:PanGesture];
       
       // [self setUserInteractionEnabled:YES];
        
    }
    return self;
}
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void) swiped:(UIPanGestureRecognizer *)gesture{
    //NSLog(@"Swiped");
    CGPoint Direction=[gesture velocityInView:self];
    //NSLog(@"X: %f",Direction.x);
    if(Direction.x>1000){
       // NSLog(@"Hiding");
        [self hideOptionsView];
    }else{
        //NSLog(@"Showing");
        if(Direction.x<-1000){
            [self showOptionsView];
        }
    }
    
}
-(void)showOptionsView{
   // NSLog(@"Showing");
    if(!OptionsView){
        OptionsView=[[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, 70)];
        [OptionsView setBackgroundColor:[UIColor clearColor]];
        if(allowsStopFollow && allowsUnfollow){
            //Both Buttons
            UIButton *Unfollow=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [Unfollow setFrame:CGRectMake(10, 13, 90, 44)];
            //[Unfollow setBackgroundColor:[UIColor redColor]];
            //[Unfollow setTintColor:[UIColor blueColor]];
            UIColor * highColor = [UIColor colorWithWhite:1.000 alpha:0.5000];
            UIColor * lowColor = [UIColor redColor];
            CAGradientLayer *unfollowlayer=[CAGradientLayer layer];
            [unfollowlayer setShadowColor:[UIColor lightGrayColor].CGColor];
            [unfollowlayer setFrame:CGRectMake(0, 0, 90, 44)];
            [unfollowlayer setColors:[NSArray arrayWithObjects:(id)[lowColor CGColor],(id)[lowColor CGColor], nil]];
            [unfollowlayer setBorderColor:[UIColor grayColor].CGColor];
            [unfollowlayer setBorderWidth:1.5];
            CALayer *wwhiteLayer=[CALayer layer];
            [wwhiteLayer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5].CGColor];
            [wwhiteLayer setFrame:CGRectMake(0, 0, 90, 22)];
            //[whiteLayer setBorderColor:<#(CGColorRef)#>]
            [unfollowlayer addSublayer:wwhiteLayer];
            // [unfollowlayer setLocations:[NSArray arrayWithObjec, nil]]
            [unfollowlayer setCornerRadius:6.0f];
            [Unfollow.layer insertSublayer:unfollowlayer atIndex:1];
            [Unfollow setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
            [Unfollow setTitleShadowOffset:CGSizeMake(1, 1)];
            [Unfollow setTitle:@"Unfollow" forState:UIControlStateNormal];
            [Unfollow setFont:[UIFont boldSystemFontOfSize:14.0]];
            
            [Unfollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [Unfollow addTarget:self action:@selector(unfollowButtonPressed:) forControlEvents:UIControlEventTouchDown];
            [OptionsView addSubview:Unfollow];
            UIButton *StopFollow=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [StopFollow setFrame:CGRectMake(220, 13, 90, 44)];
            //[StopFollow setBackgroundColor:[UIColor redColor]];
            //[StopFollow setTintColor:[UIColor blueColor]];
           // UIColor * highColor = [UIColor colorWithWhite:1.000 alpha:0.5000];
            //UIColor * lowColor = [UIColor redColor];
            CAGradientLayer *layer=[CAGradientLayer layer];
            [layer setShadowColor:[UIColor lightGrayColor].CGColor];
            [layer setFrame:CGRectMake(0, 0, 90, 44)];
            [layer setColors:[NSArray arrayWithObjects:(id)[lowColor CGColor],(id)[lowColor CGColor], nil]];
            [layer setBorderColor:[UIColor grayColor].CGColor];
            [layer setBorderWidth:1.5];
            CALayer *whiteLayer=[CALayer layer];
            [whiteLayer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5].CGColor];
            [whiteLayer setFrame:CGRectMake(0, 0, 90, 22)];
            //[whiteLayer setBorderColor:<#(CGColorRef)#>]
            [layer addSublayer:whiteLayer];
            // [layer setLocations:[NSArray arrayWithObjec, nil]]
            [layer setCornerRadius:6.0f];
            [StopFollow.layer insertSublayer:layer atIndex:1];
            [StopFollow setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
            [StopFollow setTitleShadowOffset:CGSizeMake(1, 1)];
            [StopFollow setTitle:@"Stop Follow" forState:UIControlStateNormal];
            [StopFollow setFont:[UIFont boldSystemFontOfSize:14.0]];
            
            [StopFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [StopFollow addTarget:self action:@selector(stopFollowButtonPressed:) forControlEvents:UIControlEventTouchDown];
            [OptionsView addSubview:StopFollow];
        }else{
            if(allowsStopFollow){
                UIButton *StopFollow=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                [StopFollow setFrame:CGRectMake(220, 13, 90, 44)];
                //[StopFollow setBackgroundColor:[UIColor redColor]];
                //[StopFollow setTintColor:[UIColor blueColor]];
                UIColor * highColor = [UIColor colorWithWhite:1.000 alpha:0.5000];
                UIColor * lowColor = [UIColor redColor];
                CAGradientLayer *layer=[CAGradientLayer layer];
                [layer setShadowColor:[UIColor lightGrayColor].CGColor];
                [layer setFrame:CGRectMake(0, 0, 90, 44)];
                [layer setColors:[NSArray arrayWithObjects:(id)[lowColor CGColor],(id)[lowColor CGColor], nil]];
                [layer setBorderColor:[UIColor grayColor].CGColor];
                [layer setBorderWidth:1.5];
                CALayer *whiteLayer=[CALayer layer];
                [whiteLayer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5].CGColor];
                [whiteLayer setFrame:CGRectMake(0, 0, 90, 22)];
                //[whiteLayer setBorderColor:<#(CGColorRef)#>]
                [layer addSublayer:whiteLayer];
               // [layer setLocations:[NSArray arrayWithObjec, nil]]
                [layer setCornerRadius:6.0f];
                [StopFollow.layer insertSublayer:layer atIndex:1];
                [StopFollow setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
                [StopFollow setTitleShadowOffset:CGSizeMake(1, 1)];
                [StopFollow setTitle:@"Stop Follow" forState:UIControlStateNormal];
                [StopFollow setFont:[UIFont boldSystemFontOfSize:14.0]];
                
                [StopFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [StopFollow addTarget:self action:@selector(stopFollowButtonPressed:) forControlEvents:UIControlEventTouchDown];
                [OptionsView addSubview:StopFollow];
            }else{
                if(allowsUnfollow){
                    UIButton *Unfollow=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [Unfollow setFrame:CGRectMake(220, 13, 90, 44)];
                    //[Unfollow setBackgroundColor:[UIColor redColor]];
                    //[Unfollow setTintColor:[UIColor blueColor]];
                    UIColor * highColor = [UIColor colorWithWhite:1.000 alpha:0.5000];
                    UIColor * lowColor = [UIColor redColor];
                    CAGradientLayer *layer=[CAGradientLayer layer];
                    [layer setShadowColor:[UIColor lightGrayColor].CGColor];
                    [layer setFrame:CGRectMake(0, 0, 90, 44)];
                    [layer setColors:[NSArray arrayWithObjects:(id)[lowColor CGColor],(id)[lowColor CGColor], nil]];
                    [layer setBorderColor:[UIColor grayColor].CGColor];
                    [layer setBorderWidth:1.5];
                    CALayer *whiteLayer=[CALayer layer];
                    [whiteLayer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5].CGColor];
                    [whiteLayer setFrame:CGRectMake(0, 0, 90, 22)];
                    //[whiteLayer setBorderColor:<#(CGColorRef)#>]
                    [layer addSublayer:whiteLayer];
                    // [layer setLocations:[NSArray arrayWithObjec, nil]]
                    [layer setCornerRadius:6.0f];
                    [Unfollow.layer insertSublayer:layer atIndex:1];
                    [Unfollow setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [Unfollow setTitleShadowOffset:CGSizeMake(1, 1)];
                    [Unfollow setTitle:@"Unfollow" forState:UIControlStateNormal];
                    [Unfollow setFont:[UIFont boldSystemFontOfSize:14.0]];
                    
                    [Unfollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [Unfollow addTarget:self action:@selector(unfollowButtonPressed:) forControlEvents:UIControlEventTouchDown];
                    [OptionsView addSubview:Unfollow];
                }
            }
        }
        
        [self addSubview:OptionsView];
    }
    if(!animating){
    animating=YES;
    [UIView animateWithDuration:0.1 animations:^{
        CGRect Frm=[OptionsView frame];
        Frm.origin.x=0;
        [OptionsView setFrame:Frm];
        
        animating=NO;
    }];
    }
}
-(void)hideOptionsView{
    [UIView animateWithDuration:0.1 animations:^{
        CGRect Frm=[OptionsView frame];
        Frm.origin.x=320;
        [OptionsView setFrame:Frm];
    }];
}
-(IBAction)unfollowButtonPressed:(id)sender{
    NSLog(@"Unfollowing");
    SEL  UnfollowSelector=@selector(userRequestedToUnfollowUser:);
    if([self.Delegate respondsToSelector:UnfollowSelector]){
        [self.Delegate userRequestedToUnfollowUser:userID];
    }
}
-(IBAction)stopFollowButtonPressed:(id)sender{
     NSLog(@"Stopping Follow");
    SEL StopFollowSelector=@selector(userRequestedToStopUserFromFollowing:);
    if([self.Delegate respondsToSelector:StopFollowSelector]){
        [self.Delegate userRequestedToStopUserFromFollowing:userID];
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
