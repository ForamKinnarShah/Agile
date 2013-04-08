//
//  CommentViewController.m
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize Title,ProfilePicture,Time,FullName,CommentsScroll,CommentText,MainComment;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ActivityView:(UIActivityView *)activity{
    self=[self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        internal=activity;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (IBAction)PostComment:(id)sender {
    if(![CommentText.text isEqualToString:@""]){
    [NSUserInterfaceCommands addComment:[(NSString *)[NSGlobalConfiguration getConfigurationItem:@"ID"] integerValue] Comment:[CommentText text] FeedID:[internal ID] CallbackDelegate:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [Title setText:[internal.lblLocation text]];
    [ProfilePicture setImage:[internal.ProfilePicture image]];
    [Time setText:[internal.lblTime text]];
    [MainComment setText:[internal.lblComment text]];
    [FullName setText:[internal.UserName text]];
    [CommentText setDelegate:self];
    NSCommentLoader *loader=[[NSCommentLoader alloc] init];
    [loader setDelegate:self];
    [loader getCommentsForFeed:[internal ID]];
}
-(void)userinterfaceCommandFailed:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void) userinterfaceCommandSucceeded:(NSString *)message{
    //Add Current Comment
    NSLog(@"Succeeded");
    CGSize Size=CommentsScroll.contentSize;
    UIComment *Comment=[[UIComment alloc]init];
    [Comment.Comment setText:[CommentText text]];
    [Comment.FullName setText:[NSGlobalConfiguration getConfigurationItem:@"FullName"]];
    [Comment setFrame:CGRectMake(0, Size.height, 320, 100)];
    [CommentsScroll addSubview:Comment];
    [CommentsScroll setContentSize:CGSizeMake(320, Size.height+105)];
    [CommentsScroll setScrollEnabled:YES];
    [self textFieldShouldReturn:CommentText];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [CommentsScroll setUserInteractionEnabled:NO];
    CGRect CurrentRect=[self.view frame];
    [UIView animateWithDuration:0.1 animations:^(void) {
        CGRect frm=CGRectMake(0, -160, CurrentRect.size.width, CurrentRect.size.height);
        [self.view setFrame:frm];
    }];
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [CommentsScroll setUserInteractionEnabled:YES];
    CGRect CurrentRect=[self.view frame];
    [UIView animateWithDuration:0.1 animations:^(void) {
        CGRect frm=CGRectMake(0, 0, CurrentRect.size.width, CurrentRect.size.height);
        [self.view setFrame:frm];
    }];
    [textField resignFirstResponder];
    return YES;

}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    CGRect CurrentRect=[self.view frame];
    [UIView animateWithDuration:0.1 animations:^(void) {
        CGRect frm=CGRectMake(0, 0, CurrentRect.size.width, CurrentRect.size.height);
        [self.view setFrame:frm];
    }];
    [CommentsScroll setUserInteractionEnabled:YES];
    [textField resignFirstResponder];
    return YES;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    if(touch.view!=CommentText){
        CGRect CurrentRect=[self.view frame];
        [UIView animateWithDuration:0.1 animations:^(void) {
            CGRect frm=CGRectMake(0, 0, CurrentRect.size.width, CurrentRect.size.height);
            [self.view setFrame:frm];
        }];
        [CommentsScroll setUserInteractionEnabled:YES];
        [CommentText resignFirstResponder];

    }
}
-(void)commentsLoaded:(NSCommentLoader *)loader{
    NSLog(@"Successfully loaded comments %i",[loader count]);
    for(NSInteger i=0;i<[loader count];i++){
        NSDictionary *ItemData=[loader getCommentAtIndex:i];
        UIComment *Comment=[[UIComment alloc]init];
        [Comment.Comment setText:[ItemData valueForKey:@"Comment"]];
        [Comment.FullName setText:[ItemData valueForKey:@"FullName"]];
        [Comment setFrame:CGRectMake(0, (i*100), 320, 100)];
        [CommentsScroll addSubview:Comment];
      //  NSLog([ItemData valueForKey:@"Comment"]);
       // NSLog([ItemData valueForKey:@"FullName"]);
    }
    [CommentsScroll setContentSize:CGSizeMake(320, [loader count]*105)];
}
@end
