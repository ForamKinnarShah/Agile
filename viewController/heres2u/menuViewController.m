//
//  menuViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import "menuViewController.h"
#import "paymentViewController.h"
#import "orderItem.h" 
#import "NSImageLoaderToImageView.h"
#import "NSGlobalConfiguration.h" 

@interface menuViewController ()

@end

@implementation menuViewController

//#define LOW_PRICE_FOOD_ITEM_NAME @"appetizer" //index 0 
//#define LOW_PRICE_FOOD_ITEM_PRICE 7
//#define MED_PRICE_FOOD_ITEM_NAME @"entree"  //index 1 
//#define MED_PRICE_FOOD_ITEM_PRICE 15
//#define HIGH_PRICE_FOOD_ITEM_NAME @"specialty"
//#define HIGH_PRICE_FOOD_ITEM_PRICE 25
//
//#define LOW_PRICE_DRINK_ITEM_NAME @"drink"
//#define LOW_PRICE_DRINK_ITEM_PRICE 5
//#define MED_PRICE_DRINK_ITEM_NAME @"special drink"
//#define MED_PRICE_DRINK_ITEM_PRICE 7
//#define HIGH_PRICE_DRINK_ITEM_NAME @"very special drink"
//#define HIGH_PRICE_DRINK_ITEM_PRICE 10
//
//#define LOW_PRICE_DESSERT_ITEM_NAME @"dessert"
//#define LOW_PRICE_DESSERT_ITEM_PRICE 5
//#define MED_PRICE_DESSERT_ITEM_NAME @"special dessert"
//#define MED_PRICE_DESSERT_ITEM_PRICE 7
//#define HIGH_PRICE_DESSERT_ITEM_NAME @"very special dessert" //index 8
//#define HIGH_PRICE_DESSERT_ITEM_PRICE 10


@synthesize segmentedControl = _segmentedControl, button1, button2, button3,followeePic,followeeName, timeLabelText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [(UIScrollView*)self.view setContentSize:self.view.bounds.size]; 
    // Do any additional setup after loading the view from its nib.
    [_segmentedControl addTarget:self
     
                         action:@selector(segmentedControlChanged)
     
               forControlEvents:UIControlEventValueChanged];
    menu = [NSArray arrayWithObjects:
                     [[orderItem alloc] initWithName:@"drink" Price:5 itemType:drink],
                     [[orderItem alloc] initWithName:@"special drink" Price:7 itemType:drink],
                     [[orderItem alloc] initWithName:@"amf" Price:10 itemType:drink],
                     [[orderItem alloc] initWithName:@"appetizer" Price:7 itemType:food],
                     [[orderItem alloc] initWithName:@"entree" Price:15 itemType:food],
                     [[orderItem alloc] initWithName:@"specialty" Price:25 itemType:food],
                     [[orderItem alloc] initWithName:@"dessert" Price:7 itemType:dessert],
                     [[orderItem alloc] initWithName:@"special dessert" Price:10 itemType:dessert],
                     [[orderItem alloc] initWithName:@"luxury dessert" Price:15 itemType:dessert],
                     nil];

    
    // initial settings for segmented control 
    self.lowPricelbl.text = [NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:0] price],[[menu objectAtIndex:0] name]];
    self.medPricelbl.text =[NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:1] price],[[menu objectAtIndex:1] name]];
    self.highPricelbl.text = [NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:2] price],[[menu objectAtIndex:2] name]];
    selectedItems = [NSMutableArray arrayWithCapacity:0];
    selectedIndices = [NSMutableArray arrayWithCapacity:9]; 
    for (int i = 0; i<=[menu count];i++)
    {
        selectedIndices[i] = [NSNumber numberWithBool:NO];
    }
    
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    //[button2 setBackgroundImage:[UIImage imageNamed:<#(NSString *)#>] forState:<#(UIControlState)#>]
   // self.followeeName.text = self.followeeNametxt;
    self.followeePic.image = self.followeePicImg;
    //NSImageLoaderToImageView *img=[[NSImageLoaderToImageView alloc] initWithURLString:[NSString stringWithFormat:@"%@%@",[NSGlobalConfiguration URL],[self.userInfo objectForKey:@"ImageURL"]] ImageView:self.followeePic];
    //[img start];
    
    NSLog(@"user info:%@",self.userInfo); 
    self.followeeName.text = [self.userInfo objectForKey:@"FullName"];
    self.timeLabel.text = self.timeLabelText; 
   // NSLog(@"restaurant Info:%@",self.restaurantInfo);
    self.restaurantName.text = [self.restaurantInfo objectForKey:@"Title"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }


-(void)segmentedControlChanged
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.lowPricelbl.text = [NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:0] price],[[menu objectAtIndex:0] name]];
            self.medPricelbl.text =[NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:1] price],[[menu objectAtIndex:1] name]];
            self.highPricelbl.text = [NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:2] price],[[menu objectAtIndex:2] name]];
            
            if ([selectedIndices[0] boolValue] == YES)
            {
                [button1 setSelected:YES];
            }
            else {
                [button1 setSelected:NO];
            }
            if ([selectedIndices[1] boolValue] == YES)
            {
                [button2 setSelected:YES];
            }
            else {
                [button2 setSelected:NO];
            }
            if ([selectedIndices[2] boolValue] == YES)
            {
                [button3 setSelected:YES];
            }
            else {
                [button3 setSelected:NO];
            }
            
            break;
        case 1:
            self.lowPricelbl.text = [NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:3] price],[[menu objectAtIndex:3] name]];
            self.medPricelbl.text =[NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:4] price],[[menu objectAtIndex:4] name]];
            self.highPricelbl.text = [NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:5] price],[[menu objectAtIndex:5] name]];
            if ([selectedIndices[3] boolValue] == YES)
            {
                [button1 setSelected:YES];
            }
            else {
                [button1 setSelected:NO];
            }
            if ([selectedIndices[4] boolValue] == YES)
            {
                [button2 setSelected:YES];
            }
            else {
                [button2 setSelected:NO];
            }
            if ([selectedIndices[5] boolValue] == YES)
            {
                [button3 setSelected:YES];
            }
            else {
                [button3 setSelected:NO];
            }

            
            break;
        case 2:
            self.lowPricelbl.text = [NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:6] price],[[menu objectAtIndex:6] name]];
            self.medPricelbl.text =[NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:7] price],[[menu objectAtIndex:7] name]];
            self.highPricelbl.text = [NSString stringWithFormat:@"$%.0f %@",[[menu objectAtIndex:8] price],[[menu objectAtIndex:8] name]];
            if ([selectedIndices[6] boolValue] == YES)
            {
                [button1 setSelected:YES];
            }
            else {
                [button1 setSelected:NO];
            }
            if ([selectedIndices[7] boolValue] == YES)
            {
                [button2 setSelected:YES];
            }
            else {
                [button2 setSelected:NO];
            }
            if ([selectedIndices[8] boolValue] == YES)
            {
                [button3 setSelected:YES];
            }
            else {
                [button3 setSelected:NO];
            }

            break;
        default:
            break;
    }
}

-(IBAction)itemSelected:(UIButton*)sender
{
    NSInteger selectedIndex = 0;
    
    if (sender == button1)
    {
        selectedIndex = 0;
    }
    else if (sender == button2)
    {
        selectedIndex = 1;
    }
    else if (sender == button3)
    {
        selectedIndex = 2;
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 1)
    {
        selectedIndex = selectedIndex + 3;    
    }
    else if (self.segmentedControl.selectedSegmentIndex == 2)
    {
        selectedIndex = selectedIndex + 6;
    }


//    if (![sender.titleLabel.textColor isEqual:[UIColor redColor]])
//    {
//        [sender.titleLabel setTextColor:[UIColor redColor]];
//        //[sender setSelected:YES];
//        [selectedItems addObject:[menu objectAtIndex:selectedIndex]];
//        NSLog(@"added %@ to selectedItems",[menu objectAtIndex:selectedIndex]); 
//    }
//    else {
//        //[sender setHighlighted:NO];
//        [sender.titleLabel setTextColor:[UIColor redColor]];
//
//        [selectedItems removeObjectIdenticalTo:[menu objectAtIndex:selectedIndex]];
//    }
    if (![sender isSelected])
    {
        [sender setSelected:YES];
        selectedIndices[selectedIndex] = [NSNumber numberWithBool:YES];
        //[sender setSelected:YES];
        [selectedItems addObject:[menu objectAtIndex:selectedIndex]];
        NSLog(@"added %@ to selectedItems",[menu objectAtIndex:selectedIndex]);
    }
    else {
        //[sender setHighlighted:NO];
        [sender setSelected:NO];
        selectedIndices[selectedIndex] = [NSNumber numberWithBool:NO];
        [selectedItems removeObjectIdenticalTo:[menu objectAtIndex:selectedIndex]];
    }

    
        
}

-(IBAction)clickedSubmit:(id)sender {
    paymentViewController *pay = [[paymentViewController alloc] initWithNibName:@"paymentViewController" bundle:nil];
    pay.orderItems = selectedItems;
    pay.userInfo = self.userInfo;
    pay.restaurantInfo = self.restaurantInfo; 
    NSLog(@"selectedItems:%@",selectedItems); 
    [self.navigationController pushViewController:pay animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES; 
}
@end
