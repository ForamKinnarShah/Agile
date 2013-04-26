//
//  addCreditCardViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 4/14/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "addCreditCardViewController.h"
#import "NSGlobalConfiguration.h"
#import "creditCardInfoViewController.h"

@interface addCreditCardViewController ()

@end

@implementation addCreditCardViewController

@synthesize creditCards, cardTable;

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
    [(UIScrollView*)self.view setContentSize:self.view.bounds.size];
    creditCards = [NSGlobalConfiguration getConfigurationItem:[NSGlobalConfiguration getConfigurationItem:@"Email"]];
    NSLog(@"cards:%@",creditCards);
    if (!creditCards)
    {
        creditCards = [NSMutableArray arrayWithCapacity:0];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableview cell for row"); 
    NSMutableDictionary *card = [creditCards objectAtIndex:indexPath.row];
    NSString *last4Digits = [card objectForKey:@"cardNumberLast4Digits"];
    NSString *cardType = [card objectForKey:@"cardType"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",cardType, last4Digits];
    return cell; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"tableview numberOfRows");
    int count = [creditCards count];
    return count; 
}

-(IBAction)addNewCard:(id)sender
{
    creditCardInfoViewController *card = [[creditCardInfoViewController alloc] initWithNibName:@"creditCardInfoViewController" bundle:nil];
    [self.navigationController pushViewController:card animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [cardTable reloadData]; 
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"tableview heightForRow");
//    return 120;
//}

@end
