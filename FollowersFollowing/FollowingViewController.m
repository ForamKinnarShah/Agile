//
//  FollowingViewController.m
//  FiveCorkz
//
//  Created by Abed Alatif Abouel Joud on 7/14/12.
//  Copyright (c) 2012 CSUS. All rights reserved.
//

#import "FollowingViewController.h"

@interface FollowingViewController ()

@end

@implementation FollowingViewController
@synthesize userstable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
        UIBlocker=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [UIBlocker setHidesWhenStopped:YES];
        [UIBlocker setAlpha:0.5];
        //[UIBlocker setFrame:]
        if ([self.nibName isEqualToString:@"Followers"]) {
            isFollowers=YES;
            Followers=[[NSFollowersDatasource alloc] init];
            [Followers setDelegate:self];
            NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
            NSString *UserID=[Defaults valueForKey:@"ID"];
            [Followers setUserID:[UserID integerValue]];
            
        }else{
            Followees=[[NSFollowingDatasource alloc] init];
            NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
            NSString *UserID=[Defaults valueForKey:@"ID"];
            [Followees setUserID:[UserID integerValue]];
            [Followees setDelegate:self];
        }
            }
    return self;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /*if(Followers){
        return [Followers count];
    }else{
        return [Followees count];
    }*/
   // NSLog(@"Looking up Section:%i",section);
    if (section==0) {
        return [OutputData count];
    }else{
        if(section==1){
            return [ServerSearchResults count];
        }else{
            return 0;
        }
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *Cell=[userstable dequeueReusableCellWithIdentifier:@"Cell"];
    if(!Cell){
        Cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if(indexPath.section==0){
    //NSLog(@"Getting Table View");
   
    UIUserInteractionItem *Item=[[UIUserInteractionItem alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];NSDictionary *CellData;
    CellData=(NSDictionary *)[OutputData objectAtIndex:[indexPath row]];
    if(isFollowers){
        [Item setAllowsStopFollow:YES];
        NSString *isFollowing=[CellData valueForKey:@"isFollowed"];
        //[Item setAllowsUnfollow:[isFollowing boolValue]];
    }else{
        [Item setAllowsUnfollow:YES];
        NSString *isFollowing=[CellData valueForKey:@"isFollowing"];
       // [Item setAllowsStopFollow:[isFollowing boolValue]];
    }
    [Item.lblFullName setText:[CellData valueForKey:@"FullName"]];
    NSString *WineIQ=[CellData valueForKey:@"WineIQ"];
    //[Item.lblWineIQ setText:[NSString stringWithFormat:@"WineIQ: %i",[WineIQ integerValue]]];
    NSString *CorkzRated=[CellData valueForKey:@"CorkzRated"];
    NSString *UserID=[CellData valueForKey:@"ID"];
    [Item setUserID:[UserID integerValue]];
    //[Item.lblCorkzRated setText:[NSString stringWithFormat:@"Corkz Rated: %i",[CorkzRated integerValue]]];
    NSImageLoaderToImageView *ImgLoader=[[NSImageLoaderToImageView alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[CellData valueForKey:@"ImageURL"]]] ImageView:[Item uivProfilePicture]];
    if(!isFollowers || [Item allowsUnfollow]){
        //[Cell setUserInteractionEnabled:NO];
        [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [Item setDelegate:self];
    [ImgLoader start];
    [Cell addSubview:Item];
    return Cell;
    }else{
        UIUserInteractionItem *Item=[[UIUserInteractionItem alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];NSDictionary *CellData;
        CellData=(NSDictionary *)[ServerSearchResults objectAtIndex:[indexPath row]];
        [Item setAllowsStopFollow:NO];
        [Item setAllowsUnfollow:NO];
        [Item.lblFullName setText:[CellData valueForKey:@"FullName"]];
        //NSString *WineIQ=[CellData valueForKey:@"WineIQ"];
       // [Item.lblWineIQ setText:[NSString stringWithFormat:@"WineIQ: %i",[WineIQ integerValue]]];
       // NSString *CorkzRated=[CellData valueForKey:@"CorkzRated"];
        NSString *UserID=[CellData valueForKey:@"ID"];
        [Item setUserID:[UserID integerValue]];
        //[Item.lblCorkzRated setText:[NSString stringWithFormat:@"Corkz Rated: %i",[CorkzRated integerValue]]];
        [Cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        NSImageLoaderToImageView *ImgLoader=[[NSImageLoaderToImageView alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[CellData valueForKey:@"ImageURL"]]] ImageView:[Item uivProfilePicture]];
            [Item setDelegate:self];
            [ImgLoader start];
            [Cell addSubview:Item];
        return Cell;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    //[userstable setDelegate:self];
    //[userstable setDataSource:self];
    [UIBlocker setFrame:[self.view bounds]];
    [UIBlocker setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:UIBlocker];
    if(Followers){
        [Followers loadData];
        [UIBlocker startAnimating];
    }else{
        [Followees loadData];
        [UIBlocker startAnimating];
    }
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Tab Pressed");
    if([tableView cellForRowAtIndexPath:indexPath].selectionStyle!=UITableViewCellSelectionStyleNone){
        NSDictionary *Data;
        if(isFollowers){
            Data=[Followers dataAtIndex:indexPath.row];
        }else{
            if(indexPath.section==0){
            Data=[Followees dataAtIndex:indexPath.row];
            }else{
                Data=[ServerSearchResults objectAtIndex:indexPath.row];
            }
        }
        NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
        NSString *UserID=[Defaults valueForKey:@"ID"];
        //NSLog(@"User %@ Requesting to Follow UserID:%@",UserID,[Data valueForKey:@"ID"]);
        [NSUserInterfaceCommands followUser:[UserID integerValue] FolloweeID:[(NSString *)[Data valueForKey:@"ID"] integerValue] CallbackDelegate:self];
    }
}
-(void)userRequestedToStopUserFromFollowing:(NSInteger)userID{
    NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[Defaults valueForKey:@"ID"];
    [NSUserInterfaceCommands stopUserFollow:[ID integerValue] FollowerID:userID CallbackDelegate:self];
    [UIBlocker startAnimating];
}
-(void) userRequestedToUnfollowUser:(NSInteger)userID{
    NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[Defaults valueForKey:@"ID"];
    [NSUserInterfaceCommands unfollowUser:[ID integerValue] FolloweeID:userID CallbackDelegate:self];
    [UIBlocker startAnimating];
}
- (void)viewDidUnload
{
    [self setUserstable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void) followersdatasource:(NSFollowersDatasource *)datasource FailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning:" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [UIBlocker stopAnimating];
    [alert show];
    [userstable setDelegate:self];
    [userstable setDataSource:self];
    [userstable reloadData];
}
-(void) followersdatasourceFinishedLoading:(NSFollowersDatasource *)datasource{
    OutputData=[datasource getAllData];
    [userstable setDelegate:self];
    [userstable setDataSource:self];
    [userstable reloadData];
   // NSLog(@"Done Loading followers");
    [UIBlocker stopAnimating];
}
-(void) followingdatasource:(NSFollowingDatasource *)datasource FailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning:" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [UIBlocker stopAnimating];
    [alert show];
    [userstable setDelegate:self];
    [userstable setDataSource:self];
    [userstable reloadData];

}
-(void) followingdatasourceFinishedLoading:(NSFollowingDatasource *)datasource{
    OutputData=[datasource getAllData];
    [userstable setDelegate:self];
    [userstable setDataSource:self];
    [userstable reloadData];
    [UIBlocker stopAnimating];
}
-(void)userinterfaceCommandFailed:(NSString *)message{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [UIBlocker stopAnimating];
    [alertView show];
    [userstable reloadData];
}
-(void) userinterfaceCommandSucceeded:(NSString *)message{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [UIBlocker stopAnimating];
    [alertView show];
    if(isFollowers){
        [Followers loadData];
    }else{
        [Followees loadData];
    }
    ServerSearchResults=nil;
    [userstable reloadData];
}
//Search Bar Delegates:
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //Search on the server
    if(!isFollowers){
        //search users in server
        NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
        NSString *UserID=[Defaults valueForKey:@"ID"];
        NSSearchForUser *Search=[[NSSearchForUser alloc] init];
        [Search setDelegate:self];
        [Search findUsersWhosNameStartsWith:[searchBar text] WhoAreNotBeingFollowedBy:[UserID integerValue]];
    }
    [searchBar resignFirstResponder];
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    if(isFollowers){
        OutputData=[Followers getAllData];
    }else{
        OutputData=[Followees getAllData];
    }
    ServerSearchResults=nil;
    [searchBar resignFirstResponder];
    [userstable reloadData];
}
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([[searchText stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
        if(isFollowers){
            OutputData=[Followers getAllData];
        }else{
            OutputData=[Followees getAllData];
        }
        ServerSearchResults=nil;
    }else{
    if(isFollowers){
        OutputData=[[NSMutableArray alloc] init];
        for (NSInteger i=0; i<[Followers count]; i++) {
            
            NSString *Fullname=[[Followers dataAtIndex:i] valueForKey:@"FullName"];
            if([[Fullname lowercaseString] rangeOfString:[searchText lowercaseString]].location!=NSNotFound){
                [OutputData addObject:[Followers dataAtIndex:i]];
            }
        }
        [userstable reloadData];
    }else{
        OutputData=[[NSMutableArray alloc] init];
        for (NSInteger i=0; i<[Followees count]; i++) {
            
            NSString *Fullname=[[Followees dataAtIndex:i] valueForKey:@"FullName"];
            if([[Fullname lowercaseString] rangeOfString:[searchText lowercaseString]].location!=NSNotFound){
                [OutputData addObject:[Followees dataAtIndex:i]];
            }
        }
        ServerSearchResults=nil;
        [userstable reloadData];
    }
    }
}
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //[userstable setUserInteractionEnabled:NO];
}
-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //NSLog(@"Done Editing");
    //[userstable setUserInteractionEnabled:YES];
}
-(void) searchforuser:(NSSearchForUser *)searchobject FailedWithError:(NSError *)error{
    NSLog(@"Error: %@",[error localizedDescription]);
}
-(void) searchforuserDidNotFindAnyUsers:(NSSearchForUser *)searchobject{
    //Do Nothing...
    NSLog(@"Found Nothing");
    ServerSearchResults=nil;
    [userstable reloadData];
}
-(void) searchforuserFoundUsers:(NSSearchForUser *)searchobject{
    ServerSearchResults=[searchobject getAllData];
    NSLog(@"Done: %i",[searchobject count]);
    [userstable reloadData];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"Counting Sections");
    if(ServerSearchResults && [ServerSearchResults count]>0){
        NSLog(@"%i",2);
        return 2;
    }else{
        NSLog(@"%i",1);
        return 1;
    }
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (ServerSearchResults && [ServerSearchResults count]>0){
        if(section==0){
            return @"Users You're Following:";
        }else{
            if(section==1){
                return @"Search Results:";
            }
        }
    }
    return nil;
}
@end
