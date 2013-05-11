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
    NSString *centerImageName = @"logo_small.png";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableview cell for row");
    creditCards = [NSGlobalConfiguration getConfigurationItem:[NSGlobalConfiguration getConfigurationItem:@"Email"]]; 
    NSMutableDictionary *card = [creditCards objectAtIndex:indexPath.row];
    NSString *last4Digits = [card objectForKey:@"cardNumberLast4Digits"];
    NSString *cardType = [card objectForKey:@"cardType"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",cardType, last4Digits];
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 10, 70, 24)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"buttonProfile.png"] forState:UIControlStateNormal]; 
    [deleteButton addTarget:self action:@selector(deleteCard:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    deleteButton.tag = indexPath.row; 
    [cell.contentView addSubview:deleteButton];
    return cell; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"tableview numberOfRows");
    int count = [creditCards count];
    return count; 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary *card = [creditCards objectAtIndex:indexPath.row];
    
    creditCardInfoViewController *cardController = [[creditCardInfoViewController alloc] initWithNibName:@"creditCardInfoViewController" bundle:nil];
    cardController.strnameTextField = [card objectForKey:@"nameOnCard"];
    cardController.strcardTypeTextField = [card objectForKey:@"cardType"];
    cardController.straddress1TextField = [card objectForKey:@"address1"];
    cardController.straddress2TextField = [card objectForKey:@"address2"];
    cardController.strcardNumberTextField = [NSString stringWithFormat:@"xxxx-xxxx-xxxx-%@",[card objectForKey:@"cardNumberLast4Digits"]];
    [self.navigationController pushViewController:cardController animated:YES];

    
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

-(void)deleteCard:(UIButton*)sender
{
    deleteCardIndex = sender.tag; 
    [[[UIAlertView alloc] initWithTitle:@"About to Delete Credit Card Info" message:@"Are you sure you would like to do this?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil] show];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"tableview heightForRow");
//    return 120;
//}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [creditCards removeObjectAtIndex:deleteCardIndex];
        [NSGlobalConfiguration setConfigurationItem:[NSGlobalConfiguration getConfigurationItem:@"Email"] Item:creditCards]; 
        [cardTable reloadData]; 
    }
}

@end
