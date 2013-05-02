//
//  contactInfoViewController.m
//  HERES2U
//
//  Created by Paul Sukhanov on 3/26/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "contactInfoViewController.h"
#import "NSGlobalConfiguration.h"

@interface contactInfoViewController ()

@end

@implementation contactInfoViewController

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
    NSString *centerImageName = @"logo_small.png";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:centerImageName]];

    [nameTextField setText:[NSGlobalConfiguration getConfigurationItem:@"FullName"]];
    [emailTextField setText:[NSGlobalConfiguration getConfigurationItem:@"Email"]];
    [phoneTextField setText:[NSGlobalConfiguration getConfigurationItem:@"Phone"]]; 
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO; 
}

#pragma mark
#pragma mark tableview methods

// datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil)
    {
        Cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [Cell setSelectionStyle:UITableViewCellEditingStyleNone];
    }
    
    if (indexPath.row == 0)
        Cell.textLabel.text = [NSGlobalConfiguration getConfigurationItem:@"FullName"];
    if (indexPath.row == 1)
        Cell.textLabel.text = [NSGlobalConfiguration getConfigurationItem:@"Email"];
    if (indexPath.row == 2)
        Cell.textLabel.text = [NSGlobalConfiguration getConfigurationItem:@"Phone"];
    
   return Cell;
}



@end
