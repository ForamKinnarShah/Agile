//
//  CommentViewController.m
//  HERES2U
//
//  Created by Abed Alatif Abouel Joud on 2/17/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "CommentViewController.h"

#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

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
    if(![CommentText.text isEqualToString:@""])
    {
        [NSUserInterfaceCommands addComment:[(NSString *)[NSGlobalConfiguration getConfigurationItem:@"ID"] integerValue] Comment:[CommentText text] FeedID:[internal ID] CallbackDelegate:self];
        [CommentText resignFirstResponder];
        CommentText.text = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *centerImageName = @"logo_small.png";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];

    
    // make app compatible for both 3.5" & 4" screen size
    _screenSize = [[UIScreen mainScreen] bounds].size;

    //    if iPhone5
    if(_screenSize.height == 568)
    {
        NSLog(@"iphone 5"); 
        [_imgNav setFrame:CGRectMake(5, 6, 310, 81)];
        [ProfilePicture setFrame:CGRectMake(5, 5, 80, 80)];
        [Title setFrame:CGRectMake(101, 11, 180, 18)];
        [Time setFrame:CGRectMake(112, 29, 141, 17)];
        [_btnTitle_bg setFrame:CGRectMake(5, 55, 310, 22)];
        [FullName setFrame:CGRectMake(13, 53, 208, 22)]; // height 22
        [_lblBuy setFrame:CGRectMake(274, 55, 35, 22)]; // height 22
        [MainComment setFrame:CGRectMake(13, 87, 292, 20)];
        [_toolTab_bg setFrame:CGRectMake(0, 417, 320, 38)];
        [CommentText setFrame:CGRectMake(13, 415, 243, 30)];
//        [_btnPost setFrame:CGRectMake(249, 415, 60, 30)];
        [_tblComment setFrame:CGRectMake(0, 115, 320, 298)];
        
        originalToolBarFrame = CGRectMake(0, 417, 320, 38);
    }
    else
    {
        NSLog(@"not iphone 5, height 480"); 
        [_imgNav setFrame:CGRectMake(5, 4, 310, 82)];
        [ProfilePicture setFrame:CGRectMake(5, 5, 80, 80)];
        [Title setFrame:CGRectMake(101, 11, 180, 18)];
        [Time setFrame:CGRectMake(112, 29, 141, 17)];
        [_btnTitle_bg setFrame:CGRectMake(5, 64, 310, 22)];
        [FullName setFrame:CGRectMake(13, 63, 205, 22)];
        [_lblBuy setFrame:CGRectMake(274, 64, 35, 22)];
        [MainComment setFrame:CGRectMake(13, 86, 292, 20)];
        [_toolTab_bg setFrame:CGRectMake(0, 323, 320, 44)];
        [CommentText setFrame:CGRectMake(13, 330, 243, 30)];
//        [_btnPost setFrame:CGRectMake(249, 329, 60, 30)];
        [_tblComment setFrame:CGRectMake(0, 115, 320, 210)];
        
        originalToolBarFrame = CGRectMake(0, 323, 320, 44);

    }

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
    [Comment setFrame:CGRectMake(0, Size.height, 309, 100)];
    [CommentsScroll addSubview:Comment];
    [CommentsScroll setContentSize:CGSizeMake(CommentsScroll.frame.size.width, Size.height+105)];
    [CommentsScroll setScrollEnabled:NO ];
    [CommentsScroll setBackgroundColor:[UIColor yellowColor]];
    [self textFieldShouldReturn:CommentText];
    
    NSCommentLoader *loader=[[NSCommentLoader alloc] init];
    [loader setDelegate:self];
    [loader getCommentsForFeed:[internal ID]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [CommentsScroll setUserInteractionEnabled:NO];
    //CGRect CurrentRect=[self.view frame];
    CGRect toolFrame = _toolTab_bg.frame; 
    [UIView animateWithDuration:0.2 animations:^(void) {
       // CGRect frm=CGRectMake(0, -160, CurrentRect.size.width, CurrentRect.size.height);
        CGRect frm=CGRectMake(0, toolFrame.origin.y-160, toolFrame.size.width, toolFrame.size.height);

        [_toolTab_bg setFrame:frm];
    }];
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [CommentsScroll setUserInteractionEnabled:YES];
//    CGRect CurrentRect=[self.view frame];
//    [UIView animateWithDuration:0.1 animations:^(void) {
//        CGRect frm=CGRectMake(0, 0, CurrentRect.size.width, CurrentRect.size.height);
//        [self.view setFrame:frm];
//    }];
    CGRect toolFrame = _toolTab_bg.frame;
    [UIView animateWithDuration:0.2 animations:^(void) {
        // CGRect frm=CGRectMake(0, -160, CurrentRect.size.width, CurrentRect.size.height);
        CGRect frm=originalToolBarFrame; 
        
        [_toolTab_bg setFrame:frm];
    }];

    [textField resignFirstResponder];
    return YES;

}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
//    CGRect CurrentRect=[self.view frame];
//    [UIView animateWithDuration:0.1 animations:^(void) {
//        CGRect frm=CGRectMake(0, 0, CurrentRect.size.width, CurrentRect.size.height);
//        [self.view setFrame:frm];
//    }];
    [UIView animateWithDuration:0.2 animations:^(void) {
        // CGRect frm=CGRectMake(0, -160, CurrentRect.size.width, CurrentRect.size.height);
        CGRect frm=originalToolBarFrame;
        
        [_toolTab_bg setFrame:frm];
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
-(void)commentsLoaded:(NSCommentLoader *)loader
{
    NSLog(@"Successfully loaded comments %i",[loader count]);
    NSLog(@"comments >> %@",loader.Data);
    
    _arrComment = [[NSMutableArray alloc] initWithArray:loader.Data];

    for(NSInteger i=0;i<[loader count];i++)
    {
        NSDictionary *ItemData=[loader getCommentAtIndex:i];
        UIComment *Comment=[[UIComment alloc]init];
        [Comment.Comment setText:[ItemData valueForKey:@"Comment"]];
        [Comment.FullName setText:[ItemData valueForKey:@"FullName"]];
        [Comment setFrame:CGRectMake(0, (i*100), 320, 100)];
        [CommentsScroll addSubview:Comment];
        NSLog(@"ItemData >> %@",ItemData);
    }
    [CommentsScroll setContentSize:CGSizeMake(320, [loader count]*105)];
    [_tblComment reloadData];
}

#pragma mark
#pragma mark tableview 

#pragma mark tableview datasource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrComment count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UILabel *label = nil;
    UILabel *lblDetailed = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setTag:1];
        
//        [[label layer] setBorderWidth:2.0f];
        
        [[cell contentView] addSubview:label];
        
    }
    NSString *text = [[_arrComment objectAtIndex:indexPath.row] valueForKey:@"Comment"];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    
    UILabel *lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, label.frame.size.height + 5.0, 200, 20.0)];
    [lblUsername setMinimumFontSize:12];
    [lblUsername setNumberOfLines:1];
    [lblUsername setFont:[UIFont systemFontOfSize:12]];
    [lblUsername setTag:2];
    [lblUsername setTextColor:[UIColor grayColor]];
    [[cell contentView] addSubview:lblUsername];
    [lblUsername setText:[[_arrComment objectAtIndex:indexPath.row] valueForKey:@"FullName"]];

    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
//        cell.selectionStyle = UITableViewCellEditingStyleNone;
//        cell.frame = CGRectZero;
//        label = [[UILabel alloc] initWithFrame:CGRectZero];
//        [label setLineBreakMode:UILineBreakModeWordWrap];
//        [label setMinimumFontSize:FONT_SIZE];
//        [label setNumberOfLines:0];
//        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
//        [label setTag:1];
//        [label setTextColor:[UIColor blackColor]];
//        [[cell contentView] addSubview:label];
//        
//        // assign detailed lable
//        lblDetailed = [[UILabel alloc] init];
//        [lblDetailed setLineBreakMode:UILineBreakModeWordWrap];
//        [lblDetailed setMinimumFontSize:12];
//        [lblDetailed setNumberOfLines:0];
//        [lblDetailed setFont:[UIFont systemFontOfSize:12]];
//        [lblDetailed setTag:2];
//        [lblDetailed setTextColor:[UIColor grayColor]];
//        [[cell contentView] addSubview:lblDetailed];
//    }
//    NSString *text = [NSString stringWithFormat:@"%@",[[_arrComment objectAtIndex:indexPath.row] valueForKey:@"Comment"]];
//    NSLog(@"text >> %@",text);
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//
//    if (!label)
//        label = (UILabel*)[cell viewWithTag:1];
//    
//    [label setText:text];
//    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
//
//    NSLog(@"label frame >> %@",NSStringFromCGRect(label.frame));
//    
//    // detailed label
//    NSString *textDetailed = [NSString stringWithFormat:@"%@",[[_arrComment objectAtIndex:indexPath.row] valueForKey:@"FullName"]];
//    NSLog(@"text >> %@",textDetailed);
//    CGSize constraint1 = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//    CGSize size1 = [textDetailed sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint1 lineBreakMode:UILineBreakModeWordWrap];
//    
//    // detailed label
//    if (!lblDetailed)
//        lblDetailed = (UILabel*)[cell viewWithTag:2];
//    
//    [lblDetailed setText:textDetailed];
//    [lblDetailed setFrame:CGRectMake(CELL_CONTENT_MARGIN, label.frame.size.height +5, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size1.height, 20.0f))];
//    NSLog(@"lblDetailed frame >> %@",NSStringFromCGRect(lblDetailed.frame));

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSString *text = [[_arrComment objectAtIndex:indexPath.row] valueForKey:@"Comment"];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height + 28.0, 44.0f);
    NSLog(@"height %f",height);
    return height + (CELL_CONTENT_MARGIN * 2);
    
    
//    NSString *text = [NSString stringWithFormat:@"%@\n%@",[[_arrComment objectAtIndex:indexPath.row] valueForKey:@"Comment"],[[_arrComment objectAtIndex:indexPath.row] valueForKey:@"FullName"]];
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    CGFloat height = MAX(size.height, 44.0f);
//    NSLog(@"%f",height + (CELL_CONTENT_MARGIN * 2));
//    return height + (CELL_CONTENT_MARGIN * 2) + 10;
}

- (void)viewDidUnload {
    [self setImgNav:nil];
    [self setBtnTitle_bg:nil];
    [self setLblBuy:nil];
    [self setToolTab_bg:nil];
    [self setBtnPost:nil];
    [super viewDidUnload];
}

#pragma mark
#pragma mark button actions

// user touches anywhere in the background
- (IBAction)bg_clicked:(id)sender
{
    [CommentText resignFirstResponder];
}

@end
