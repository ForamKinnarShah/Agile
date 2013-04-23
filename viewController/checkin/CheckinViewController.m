//
//  CheckinViewController.m
//  HERES2U
//
//  Created by Paul Amador on 11/28/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "CheckinViewController.h"
#import "addViewController.h"
#import "checkinCommentViewController.h"
#import "menuViewController.h" 
#import "Heres2uViewController.h" 

@interface CheckinViewController ()

@end

@implementation CheckinViewController
@synthesize FilterButton,FilterTextBox,LocationsView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.title = @"Check-in";
//    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"dot.png"];
//    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:self.title image:img tag:2];
//    self.tabBarItem = tab;
    // Custom initialization
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToAdd:)]];
    Locations=[[NSLocationLoader alloc] init];
    [Locations setDelegate:self];
    //[Locations downloadLocations];
    UIBlocker = [[utilities alloc] init];
    [UIBlocker startUIBlockerInView:self.tabBarController.view];

    arrayTitle = [[NSMutableArray alloc]init];
    arrayFindNumber = [[NSMutableArray alloc]init];

    // Set notification for when textfield is edited
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchForText) name:UITextFieldTextDidChangeNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    FilterTextBox.text =@"";
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [Locations downloadLocations]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"fiterText:%@",FilterTextBox.text);
    
    if([textField.text isEqualToString:@""] || textField.text.length==0){
        [self locationloaderCompleted:nil];
    }
        
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    @try {
        [textField resignFirstResponder];
        [self locationloaderCompleted:nil];
        
    }
    @catch (NSException *exception) {
        
    }
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    NSLog(@"textField.text.length : %d",textField.text.length);
    
    
    
    return YES;
}

-(void)searchForText{
    @try {
        NSLog(@"arrayTitle : %@",arrayTitle);
        NSLog(@"textField.text.length : %d",FilterTextBox.text.length);
        NSLog(@"%@",FilterTextBox.text);
        
        // For string kind of values:
        for(UIView *CurrentView in LocationsView.subviews){
            [CurrentView removeFromSuperview];
        }
        
        NSArray *results=nil;
        NSLog(@"arrayTitle count : %d",arrayTitle.count);
        NSLog(@"Locations count : %d",Locations.count);
        
        for(NSInteger i=0;i<[Locations count];i++){
            
            //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", FilterTextBox.text];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[c] %@", FilterTextBox.text];
            results = [arrayTitle filteredArrayUsingPredicate:predicate];
            NSLog(@"results : %@",results);
        }
        
        
        int count1=0;
        int y=0;
        BOOL isMatch;
        
        for(int i=0; i<results.count; i++){
            isMatch = NO;
            NSString *strArrayTitle = [NSString stringWithFormat:@"%@",[results objectAtIndex:i]];
            NSLog(@"strArrayTitle : %@",strArrayTitle);
            
            
            NSDictionary *ItemData1=[Locations getLocationAtIndex:i];
            
            for(int k=0;k<=ItemData1.count;k++){
                NSLog(@"ItemData1.count : %d",ItemData1.count);
                if(isMatch){
                    break;
                }
                
                NSDictionary *ItemData=[Locations getLocationAtIndex:k];
                NSString *strItemTitle = [NSString stringWithFormat:@"%@",[ItemData valueForKey:@"Title"]];
                
                if([strItemTitle isEqualToString:strArrayTitle]){
                    
                    count1++;
                    UICheckIns *CheckIn=[[UICheckIns alloc] initWithFrame:CGRectMake(0, y, 0, 0)];
                    [CheckIn.Distance setText:@"0.0 m"];
                    [CheckIn.Name setText:[ItemData valueForKey:@"Title"]];
                    
                    [CheckIn.Location setText:[NSString stringWithFormat:@"%@",[ItemData valueForKey:@"Address"]]];
                    [CheckIn setDelegate:self];
                    [CheckIn setTag:i];
                    
                    if (self.presentingViewController)
                    {
                        CheckIn.checkInLabel.text = @"buy gift here";
                    }
                    
                    [CheckIn setID:[(NSString *)[ItemData valueForKey:@"ID"] integerValue]];
                    NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData valueForKey:@"Image"]] ImageView:CheckIn.Picture];
                    [img start];
                    //                    LocationsView.frame = CGRectMake(0, y, 320, 100);
                    [LocationsView addSubview:CheckIn];
                    y+=100;
                    isMatch = YES;
                }
            }
        }
        [LocationsView setContentSize:CGSizeMake(320, ((count1+1)*100))];
        [LocationsView setScrollEnabled:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"NSException : %@",exception);
    }

}



     
-(IBAction)goToAdd:(id)sender {
         addViewController *add = [[addViewController alloc] initWithNibName:@"addViewController" bundle:nil];
         [self.navigationController pushViewController:add animated:YES];
}

-(IBAction)goToCheckinComment:(id)sender {
    checkinCommentViewController *add = [[checkinCommentViewController alloc] initWithNibName:@"checkinCommentViewController" bundle:nil];
    [self.navigationController pushViewController:add animated:YES];
}

-(IBAction)btnMap_Click:(id)sender
{
    @try {
        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)locationloaderCompleted:(NSLocationLoader *)loader{
    
    [UIBlocker stopUIBlockerInView:self.tabBarController.view]; 
    //Clear Everything in LocationsView
    for(UIView *CurrentView in LocationsView.subviews){
        [CurrentView removeFromSuperview];
    }
    [arrayTitle removeAllObjects];
    
    for(NSInteger i=0;i<[Locations count];i++){
        NSDictionary *ItemData=[Locations getLocationAtIndex:i];
        NSLog(@"ItemData : %@",ItemData);
        
        UICheckIns *CheckIn=[[UICheckIns alloc] initWithFrame:CGRectMake(0, (100*i), 0, 0)];
        [CheckIn.Distance setText:@"0.0 m"];
        [CheckIn.Name setText:[ItemData valueForKey:@"Title"]];
        
        [arrayTitle addObject:[ItemData valueForKey:@"Title"]];
        
        [CheckIn.Location setText:[NSString stringWithFormat:@"%@",[ItemData valueForKey:@"Address"]]];
        [CheckIn setDelegate:self];
        [CheckIn setTag:i];
        
        if (self.presentingViewController)
        {
            CheckIn.checkInLabel.text = @"buy gift here"; 
        }
        
        [CheckIn setID:[(NSString *)[ItemData valueForKey:@"ID"] integerValue]];
        NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[ItemData valueForKey:@"Image"]] ImageView:CheckIn.Picture];
        [img start];
        [LocationsView addSubview:CheckIn];
    }
    [LocationsView setContentSize:CGSizeMake(320, ([Locations count]*100))];
    [LocationsView setScrollEnabled:YES];
}
-(void) locationloaderFailedWithError:(NSError *)error{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [UIBlocker stopUIBlockerInView:self.tabBarController.view];
    [alert show];
}
-(void)checkinRequested:(UICheckIns *)checkin{
    
   // NSLog(@"checkin requested");
    
    if (self.presentingViewController) //indicates it is being called from heres2u view controller, and should go to menu page next
    {  NSLog(@"isBeingPresented");
        
        //Heres2uViewController *h2u = [self.tabBarController.viewControllers objectAtIndex:2];
        
        [self.delegate setRestaurantInfo:[Locations getLocationAtIndex:checkin.tag]];
        [self dismissViewControllerAnimated:YES completion:^{
            
            NSLog(@"something"); 
            if ([self.delegate respondsToSelector:@selector(loadMenuView)])
            {
                NSLog(@"responds to selector");
                [self.delegate loadMenuView];
            }
        }];
        //menuViewController *menu = [[menuViewController alloc] initWithNibName:@"menuViewController" bundle:nil];
        
    }
    else {
    checkinCommentViewController *add = [[checkinCommentViewController alloc] initWithNibName:@"checkinCommentViewController" bundle:nil Checkin:checkin];
        add.tabBar = self.tabBarController; 
    [self.navigationController pushViewController:add animated:YES]
     ;}
}
@end
